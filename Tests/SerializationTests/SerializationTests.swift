import XCTest
import VerIDCommonTypes
@testable import Serialization

final class SerializationTests: XCTestCase {
    
    let face = Face(bounds: CGRect(x: 25, y: 20, width: 345, height: 431), angle: EulerAngle(yaw: 1.3, pitch: 0.5, roll: 0.1), quality: 9.9, landmarks: [CGPoint(x: 10, y: 12)], leftEye: CGPoint(x: 51, y: 72), rightEye: CGPoint(x: 89, y: 73), noseTip: CGPoint(x: 65, y: 92), mouthCentre: CGPoint(x: 66, y: 123))
    
    func testDeserializeImage() throws {
        guard let url = Bundle.module.url(forResource: "image", withExtension: "bin", subdirectory: nil) else {
            XCTFail()
            return
        }
        let data = try Data(contentsOf: url)
        let image = try Image.deserialize(data)
        XCTAssertEqual(image.width, 1080)
        XCTAssertEqual(image.height, 1920)
    }
    
    func testSerializeImage() throws {
        guard let url = Bundle.module.url(forResource: "image", withExtension: "bin", subdirectory: nil) else {
            XCTFail()
            return
        }
        let data = try Data(contentsOf: url)
        let image = try Image.deserialize(data)
        XCTAssertNoThrow(try image.serialized())
    }
    
    func testSerializeFace() throws {
        XCTAssertNoThrow(try face.serialized())
    }
    
    func testDeserializeFace() throws {
        let data = try face.serialized()
        let deserializedFace = try Face.deserialize(data)
        XCTAssertEqual(face, deserializedFace)
    }
    
    func testSerializeImagePackage() throws {
        guard let url = Bundle.module.url(forResource: "image", withExtension: "bin", subdirectory: nil) else {
            XCTFail()
            return
        }
        let data = try Data(contentsOf: url)
        let image = try Image.deserialize(data)
        let package = ImagePackage(image: image, face: self.face)
        XCTAssertNoThrow(try package.serialized())
    }
}
