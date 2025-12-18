//
//  FloatArrayCodec.swift
//  Serialization
//
//  Created by Jakub Dolejs on 04/12/2025.
//

import Foundation
import Compression

public enum FloatArrayCodec {
    
    public static var magic: UInt32 { UInt32(0xBEDDEDDE).littleEndian }
    public static var version: UInt8 { 1 }
    
    public static func encode(_ data: [Float]) throws -> Data {
        let uncompressed = Self.floatArrayToData(data)
        let compressed = try Self.compressData(uncompressed)
        var header = FloatArrayCodecHeader(magic: Self.magic, version: Self.version, count: UInt32(data.count).littleEndian)
        var data = Data()
        withUnsafeBytes(of: &header) { bufferPointer in
            data.append(contentsOf: bufferPointer)
        }
        return data + compressed
    }
    
    public static func decode(_ data: Data) throws -> [Float] {
        let headerSize = MemoryLayout<FloatArrayCodecHeader>.size
        guard data.count >= headerSize else { throw FloatArrayCodecError.tooShort }
        let header = data.withUnsafeBytes { $0.load(as: FloatArrayCodecHeader.self) }
        if header.magic != Self.magic {
            throw FloatArrayCodecError.badHeader
        }
        if header.version != Self.version {
            throw FloatArrayCodecError.unsupportedVersion(header.version)
        }
        let payload = data.dropFirst(headerSize)
        let decompressed = try Self.decompressData(payload, decompressedSize: Int(UInt32(header.count).littleEndian) * MemoryLayout<Float>.size)
        let floats = self.dataToFloatArray(decompressed)
        return floats
    }
    
    private static func floatArrayToData(_ floats: [Float]) -> Data {
        var data = Data()
        data.reserveCapacity(floats.count * MemoryLayout<Float>.size)
        floats.withUnsafeBufferPointer { buf in
            for f in buf {
                var bitsLE = f.bitPattern.littleEndian
                withUnsafeBytes(of: &bitsLE) { data.append(contentsOf: $0) }
            }
        }
        return data
    }
    
    private static func dataToFloatArray(_ data: Data) -> [Float] {
        let count = data.count / MemoryLayout<Float>.size
        var result = [Float]()
        result.reserveCapacity(count)
        data.withUnsafeBytes { raw in
            let u32 = raw.bindMemory(to: UInt32.self)
            for i in 0..<count {
                let bits = UInt32(littleEndian: u32[i])
                result.append(Float(bitPattern: bits))
            }
        }
        return result
    }
    
    private static func compressData(_ data: Data) throws -> Data {
        guard !data.isEmpty else {
            return Data()
        }
        return try data.withUnsafeBytes { (srcBuffer: UnsafeRawBufferPointer) -> Data in
            guard let srcBase = srcBuffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                throw FloatArrayCodecError.compressionFailed
            }
            let srcSize = data.count
            let dstSize = srcSize + srcSize / 16 + 64 + 3
            var dstData = Data(count: dstSize)
            let compressedSize: size_t = try dstData.withUnsafeMutableBytes { dstBuffer in
                guard let dstBase = dstBuffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    throw FloatArrayCodecError.compressionFailed
                }
                return compression_encode_buffer(
                    dstBase,
                    dstSize,
                    srcBase,
                    srcSize,
                    nil,
                    COMPRESSION_ZLIB
                )
            }
            if compressedSize == 0 {
                throw FloatArrayCodecError.compressionFailed
            }
            dstData.removeSubrange(compressedSize..<dstData.count)
            return dstData
        }
    }
    
    private static func decompressData(_ data: Data, decompressedSize: Int) throws -> Data {
        guard !data.isEmpty else {
            return Data()
        }
        guard decompressedSize > 0 else {
            return Data()
        }
        return try data.withUnsafeBytes { (srcBuffer: UnsafeRawBufferPointer) -> Data in
            guard let srcBase = srcBuffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                throw FloatArrayCodecError.decompressionFailed
            }
            var dstData = Data(count: decompressedSize)
            let decodedSize: size_t = dstData.withUnsafeMutableBytes { dstBuffer in
                guard let dstBase = dstBuffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return 0
                }
                return compression_decode_buffer(
                    dstBase,
                    decompressedSize,
                    srcBase,
                    data.count,
                    nil,
                    COMPRESSION_ZLIB
                )
            }
            guard decodedSize == decompressedSize else {
                throw FloatArrayCodecError.decompressionFailed
            }
            return dstData
        }
    }
}

struct FloatArrayCodecHeader {
    let magic: UInt32
    let version: UInt8
    let count: UInt32
}
