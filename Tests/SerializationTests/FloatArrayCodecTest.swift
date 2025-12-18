//
//  FloatArrayCodecTest.swift
//  Serialization
//
//  Created by Jakub Dolejs on 04/12/2025.
//

import Testing
import Foundation
@testable import Serialization

struct FloatArrayCodecTest {
    
    @Test func testEncodeDecodeFloatArray() throws {
        var array = [Float](repeating: 1.0, count: 256)
        for i in 0..<array.count {
            array[i] = Float.random(in: -1.0...1.0)
        }
        let encoded = try FloatArrayCodec.encode(array)
        let decoded = try FloatArrayCodec.decode(encoded)
        #expect(array == decoded)
    }

    @Test func attachEncodedFloatArray() throws {
        var array = [Float](repeating: 1.0, count: 256)
        for i in 0..<array.count {
            array[i] = Float.random(in: -1.0...1.0)
        }
        let json = try JSONEncoder().encode(array)
        Attachment.record(json, named: "Raw.json")
        let encoded = try FloatArrayCodec.encode(array)
        Attachment.record(encoded, named: "Template.bin")
        let string = encoded.base64EncodedString()
        Attachment.record(string, named: "Encoded.txt")
    }
}

