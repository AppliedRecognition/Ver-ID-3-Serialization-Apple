//
//  ImagePackage.swift
//
//
//  Created by Jakub Dolejs on 20/02/2025.
//

import Foundation
import UIKit
import AVFoundation
import VerIDCommonTypes

public struct ImagePackage {
    
    public let image: VerIDCommonTypes.Image
    public let face: VerIDCommonTypes.Face
    
    public init(image: VerIDCommonTypes.Image, face: VerIDCommonTypes.Face) {
        self.image = image
        self.face = face
    }
    
    public func serialized() throws -> Data {
        let image3d = try self.image.toImage3D()
        let face = Face.with { face in
            face.x = Float(self.face.bounds.minX)
            face.y = Float(self.face.bounds.minY)
            face.width = Float(self.face.bounds.width)
            face.height = Float(self.face.bounds.height)
            face.yaw = self.face.angle.yaw
            face.pitch = self.face.angle.pitch
            face.roll = self.face.angle.roll
            face.quality = self.face.quality
            face.leftEye = PointF.with {
                $0.x = Float(self.face.leftEye.x)
                $0.y = Float(self.face.leftEye.y)
            }
            face.rightEye = PointF.with {
                $0.x = Float(self.face.rightEye.x)
                $0.y = Float(self.face.rightEye.y)
            }
            if let noseTip = self.face.noseTip {
                face.noseTip = PointF.with {
                    $0.x = Float(noseTip.x)
                    $0.y = Float(noseTip.y)
                }
            }
            if let mouthCentre = self.face.mouthCentre {
                face.mouthCentre = PointF.with {
                    $0.x = Float(mouthCentre.x)
                    $0.y = Float(mouthCentre.y)
                }
            }
            face.landmarks = self.face.landmarks.map { landmark in
                PointF.with {
                    $0.x = Float(landmark.x)
                    $0.y = Float(landmark.y)
                }
            }
        }
        return try ImageFacePackage.with { pack in
            pack.image = image3d
            pack.face = face
        }.serializedData()
    }
}
