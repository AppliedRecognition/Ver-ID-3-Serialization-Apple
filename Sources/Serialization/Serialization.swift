import Foundation
import UIKit
import AVFoundation
import VerIDCommonTypes
import JxlCoder

public extension VerIDCommonTypes.Image {
    
    /// Serializes image into protocol buffer
    /// - Returns: Serialized image
    /// - Since: 1.0.0
    func serialized() throws -> Data {
        try self.toImage3D().serializedData()
    }
    
    /// Creates an image from protocol buffer serialized data
    ///
    /// This function only deserializes the colour image, not the depth map.
    /// - Parameter data: Serialized image
    /// - Returns: Deserialized `Image` struct
    /// - Since: 1.0.0
    static func deserialize(_ data: Data) throws -> VerIDCommonTypes.Image {
        let image3d = try Image3D(serializedBytes: data)
        let jxlImage = try JXLCoder.decode(data: image3d.jxl)
        guard let cgImage = jxlImage.cgImage else {
            throw ImageError.imageConversionFailed
        }
        let orientation: CGImagePropertyOrientation
        switch jxlImage.imageOrientation {
        case .up:
            orientation = .up
        case .upMirrored:
            orientation = .upMirrored
        case .down:
            orientation = .down
        case .downMirrored:
            orientation = .downMirrored
        case .left:
            orientation = .left
        case .leftMirrored:
            orientation = .leftMirrored
        case .right:
            orientation = .right
        case .rightMirrored:
            orientation = .rightMirrored
        default:
            orientation = .up
        }
        guard let image = VerIDCommonTypes.Image(cgImage: cgImage, orientation: orientation, depthData: nil) else {
            throw ImageError.imageConversionFailed
        }
        return image
    }
    
    private static func depthMapFromDepthData(_ depthData: AVDepthData) -> DepthMap {
        var depthMap = DepthMap()
        if depthData.depthDataType != kCVPixelFormatType_DepthFloat32 && depthData.depthDataType != kCVPixelFormatType_DepthFloat16 {
            return depthMap
        }
        let depthMapBuffer = depthData.depthDataMap
        depthMap.width = Int32(CVPixelBufferGetWidth(depthMapBuffer))
        depthMap.height = Int32(CVPixelBufferGetHeight(depthMapBuffer))
        depthMap.bytesPerRow = Int32(CVPixelBufferGetBytesPerRow(depthMapBuffer))
        depthMap.bitsPerElement = depthData.depthDataType == kCVPixelFormatType_DepthFloat32 ? 32 : 16
        do {
            CVPixelBufferLockBaseAddress(depthMapBuffer, .readOnly)
            defer {
                CVPixelBufferUnlockBaseAddress(depthMapBuffer, .readOnly)
            }
            guard let baseAddress = CVPixelBufferGetBaseAddress(depthMapBuffer) else {
                return depthMap
            }
            depthMap.data = Data(bytes: baseAddress, count: Int(depthMap.bytesPerRow) * Int(depthMap.height))
        }
        guard let calibrationData = depthData.cameraCalibrationData else {
            return depthMap
        }
        guard let lookupTable = calibrationData.lensDistortionLookupTable else {
            return depthMap
        }
        depthMap.lensDistortionLookupTable = floatArrayFromData(lookupTable) ?? []
        let referenceSize = calibrationData.intrinsicMatrixReferenceDimensions
        let scaleX = Float(depthMap.width) / Float(referenceSize.width)
        let scaleY = Float(depthMap.height) / Float(referenceSize.height)
        depthMap.principalPoint = PointF.with { pt in
            pt.x = calibrationData.intrinsicMatrix[2][0] * scaleX
            pt.y = calibrationData.intrinsicMatrix[2][1] * scaleY
        }
        depthMap.focalLength = PointF.with { pt in
            pt.x = calibrationData.intrinsicMatrix[0][0] * scaleX
            pt.y = calibrationData.intrinsicMatrix[1][1] * scaleY
        }
        depthMap.lensDistortionCenter = PointF.with { pt in
            pt.x = Float(calibrationData.lensDistortionCenter.x) * scaleX
            pt.y = Float(calibrationData.lensDistortionCenter.y) * scaleY
        }
        return depthMap
    }
}

extension VerIDCommonTypes.Image {
    
    func toImage3D() throws -> Image3D {
        guard let cgImage = self.toCGImage() else {
            throw ImageError.imageConversionFailed
        }
        let jxl = try JXLCoder.encode(image: UIImage(cgImage: cgImage), colorSpace: .rgb, compressionOption: .loseless)
        return Image3D.with { image in
            image.jxl = jxl
            if let depthData = self.depthData {
                image.depthMap = Image.depthMapFromDepthData(depthData)
            }
        }
    }
}

public extension VerIDCommonTypes.Face {
    
    /// Serializes face into protocol buffer
    /// - Returns: Serialized face
    /// - Since: 1.0.0
    func serialized() throws -> Data {
        try Face.with { face in
            face.x = Float(self.bounds.minX)
            face.y = Float(self.bounds.minY)
            face.width = Float(self.bounds.width)
            face.height = Float(self.bounds.height)
            face.yaw = self.angle.yaw
            face.pitch = self.angle.pitch
            face.roll = self.angle.roll
            face.quality = self.quality
            face.leftEye = PointF.with { 
                $0.x = Float(self.leftEye.x)
                $0.y = Float(self.leftEye.y)
            }
            face.rightEye = PointF.with {
                $0.x = Float(self.rightEye.x)
                $0.y = Float(self.rightEye.y)
            }
            if let noseTip = self.noseTip {
                face.noseTip = PointF.with {
                    $0.x = Float(noseTip.x)
                    $0.y = Float(noseTip.y)
                }
            }
            if let mouthCentre = self.mouthCentre {
                face.mouthCentre = PointF.with {
                    $0.x = Float(mouthCentre.x)
                    $0.y = Float(mouthCentre.y)
                }
            }
            face.landmarks = self.landmarks.map { landmark in
                PointF.with {
                    $0.x = Float(landmark.x)
                    $0.y = Float(landmark.y)
                }
            }
        }.serializedData()
    }
    
    /// Creates a face object from protocol buffer serialized data
    /// - Parameter data: Serialized face
    /// - Returns: Deserialized `Face` struct
    /// - Since: 1.0.0
    static func deserialize(_ data: Data) throws -> VerIDCommonTypes.Face {
        let face = try Face(serializedBytes: data)
        let bounds = CGRect(x: CGFloat(face.x), y: CGFloat(face.y), width: CGFloat(face.width), height: CGFloat(face.height))
        let angle = EulerAngle(yaw: face.yaw, pitch: face.pitch, roll: face.roll)
        let landmarks = face.landmarks.map {
            CGPoint(x: CGFloat($0.x), y: CGFloat($0.y))
        }
        let leftEye = CGPoint(x: CGFloat(face.leftEye.x), y: CGFloat(face.leftEye.y))
        let rightEye = CGPoint(x: CGFloat(face.rightEye.x), y: CGFloat(face.rightEye.y))
        let noseTip = face.hasNoseTip ? CGPoint(x: CGFloat(face.noseTip.x), y: CGFloat(face.noseTip.y)) : nil
        let mouthCentre = face.hasMouthCentre ? CGPoint(x: CGFloat(face.mouthCentre.x), y: CGFloat(face.mouthCentre.y)) : nil
        return VerIDCommonTypes.Face(bounds: bounds, angle: angle, quality: face.quality, landmarks: landmarks, leftEye: leftEye, rightEye: rightEye, noseTip: noseTip, mouthCentre: mouthCentre)
    }
}


fileprivate func floatArrayFromData(_ data: Data) -> [Float]? {
    guard data.count % MemoryLayout<Float>.size == 0 else {
        // The data size is not a multiple of Float size
        return nil
    }
    
    let floatArray = data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> [Float] in
        let floatPointer = pointer.bindMemory(to: Float.self)
        return Array(floatPointer)
    }
    
    return floatArray
}
