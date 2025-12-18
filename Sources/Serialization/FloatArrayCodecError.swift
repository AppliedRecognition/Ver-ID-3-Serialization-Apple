//
//  FloatArrayCodecError.swift
//  Serialization
//
//  Created by Jakub Dolejs on 04/12/2025.
//


import Foundation
import Compression

public enum FloatArrayCodecError: Error {
    case tooShort
    case badHeader
    case sizeMismatch
    case unsupportedVersion(UInt8)

    case compressionFailed
    case decompressionFailed
}