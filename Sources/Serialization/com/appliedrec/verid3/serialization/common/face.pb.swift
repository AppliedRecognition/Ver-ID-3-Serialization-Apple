// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: com/appliedrec/verid3/serialization/common/face.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Face {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var x: Float {
    get {return _storage._x}
    set {_uniqueStorage()._x = newValue}
  }

  var y: Float {
    get {return _storage._y}
    set {_uniqueStorage()._y = newValue}
  }

  var width: Float {
    get {return _storage._width}
    set {_uniqueStorage()._width = newValue}
  }

  var height: Float {
    get {return _storage._height}
    set {_uniqueStorage()._height = newValue}
  }

  var yaw: Float {
    get {return _storage._yaw}
    set {_uniqueStorage()._yaw = newValue}
  }

  var pitch: Float {
    get {return _storage._pitch}
    set {_uniqueStorage()._pitch = newValue}
  }

  var roll: Float {
    get {return _storage._roll}
    set {_uniqueStorage()._roll = newValue}
  }

  var quality: Float {
    get {return _storage._quality}
    set {_uniqueStorage()._quality = newValue}
  }

  var landmarks: [PointF] {
    get {return _storage._landmarks}
    set {_uniqueStorage()._landmarks = newValue}
  }

  var leftEye: PointF {
    get {return _storage._leftEye ?? PointF()}
    set {_uniqueStorage()._leftEye = newValue}
  }
  /// Returns true if `leftEye` has been explicitly set.
  var hasLeftEye: Bool {return _storage._leftEye != nil}
  /// Clears the value of `leftEye`. Subsequent reads from it will return its default value.
  mutating func clearLeftEye() {_uniqueStorage()._leftEye = nil}

  var rightEye: PointF {
    get {return _storage._rightEye ?? PointF()}
    set {_uniqueStorage()._rightEye = newValue}
  }
  /// Returns true if `rightEye` has been explicitly set.
  var hasRightEye: Bool {return _storage._rightEye != nil}
  /// Clears the value of `rightEye`. Subsequent reads from it will return its default value.
  mutating func clearRightEye() {_uniqueStorage()._rightEye = nil}

  var noseTip: PointF {
    get {return _storage._noseTip ?? PointF()}
    set {_uniqueStorage()._noseTip = newValue}
  }
  /// Returns true if `noseTip` has been explicitly set.
  var hasNoseTip: Bool {return _storage._noseTip != nil}
  /// Clears the value of `noseTip`. Subsequent reads from it will return its default value.
  mutating func clearNoseTip() {_uniqueStorage()._noseTip = nil}

  var mouthCentre: PointF {
    get {return _storage._mouthCentre ?? PointF()}
    set {_uniqueStorage()._mouthCentre = newValue}
  }
  /// Returns true if `mouthCentre` has been explicitly set.
  var hasMouthCentre: Bool {return _storage._mouthCentre != nil}
  /// Clears the value of `mouthCentre`. Subsequent reads from it will return its default value.
  mutating func clearMouthCentre() {_uniqueStorage()._mouthCentre = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Face: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "com.appliedrec.verid3.serialization.common"

extension Face: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Face"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "x"),
    2: .same(proto: "y"),
    3: .same(proto: "width"),
    4: .same(proto: "height"),
    5: .same(proto: "yaw"),
    6: .same(proto: "pitch"),
    7: .same(proto: "roll"),
    8: .same(proto: "quality"),
    9: .same(proto: "landmarks"),
    10: .standard(proto: "left_eye"),
    11: .standard(proto: "right_eye"),
    12: .standard(proto: "nose_tip"),
    13: .standard(proto: "mouth_centre"),
  ]

  fileprivate class _StorageClass {
    var _x: Float = 0
    var _y: Float = 0
    var _width: Float = 0
    var _height: Float = 0
    var _yaw: Float = 0
    var _pitch: Float = 0
    var _roll: Float = 0
    var _quality: Float = 0
    var _landmarks: [PointF] = []
    var _leftEye: PointF? = nil
    var _rightEye: PointF? = nil
    var _noseTip: PointF? = nil
    var _mouthCentre: PointF? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _x = source._x
      _y = source._y
      _width = source._width
      _height = source._height
      _yaw = source._yaw
      _pitch = source._pitch
      _roll = source._roll
      _quality = source._quality
      _landmarks = source._landmarks
      _leftEye = source._leftEye
      _rightEye = source._rightEye
      _noseTip = source._noseTip
      _mouthCentre = source._mouthCentre
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every case branch when no optimizations are
        // enabled. https://github.com/apple/swift-protobuf/issues/1034
        switch fieldNumber {
        case 1: try { try decoder.decodeSingularFloatField(value: &_storage._x) }()
        case 2: try { try decoder.decodeSingularFloatField(value: &_storage._y) }()
        case 3: try { try decoder.decodeSingularFloatField(value: &_storage._width) }()
        case 4: try { try decoder.decodeSingularFloatField(value: &_storage._height) }()
        case 5: try { try decoder.decodeSingularFloatField(value: &_storage._yaw) }()
        case 6: try { try decoder.decodeSingularFloatField(value: &_storage._pitch) }()
        case 7: try { try decoder.decodeSingularFloatField(value: &_storage._roll) }()
        case 8: try { try decoder.decodeSingularFloatField(value: &_storage._quality) }()
        case 9: try { try decoder.decodeRepeatedMessageField(value: &_storage._landmarks) }()
        case 10: try { try decoder.decodeSingularMessageField(value: &_storage._leftEye) }()
        case 11: try { try decoder.decodeSingularMessageField(value: &_storage._rightEye) }()
        case 12: try { try decoder.decodeSingularMessageField(value: &_storage._noseTip) }()
        case 13: try { try decoder.decodeSingularMessageField(value: &_storage._mouthCentre) }()
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every if/case branch local when no optimizations
      // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
      // https://github.com/apple/swift-protobuf/issues/1182
      if _storage._x != 0 {
        try visitor.visitSingularFloatField(value: _storage._x, fieldNumber: 1)
      }
      if _storage._y != 0 {
        try visitor.visitSingularFloatField(value: _storage._y, fieldNumber: 2)
      }
      if _storage._width != 0 {
        try visitor.visitSingularFloatField(value: _storage._width, fieldNumber: 3)
      }
      if _storage._height != 0 {
        try visitor.visitSingularFloatField(value: _storage._height, fieldNumber: 4)
      }
      if _storage._yaw != 0 {
        try visitor.visitSingularFloatField(value: _storage._yaw, fieldNumber: 5)
      }
      if _storage._pitch != 0 {
        try visitor.visitSingularFloatField(value: _storage._pitch, fieldNumber: 6)
      }
      if _storage._roll != 0 {
        try visitor.visitSingularFloatField(value: _storage._roll, fieldNumber: 7)
      }
      if _storage._quality != 0 {
        try visitor.visitSingularFloatField(value: _storage._quality, fieldNumber: 8)
      }
      if !_storage._landmarks.isEmpty {
        try visitor.visitRepeatedMessageField(value: _storage._landmarks, fieldNumber: 9)
      }
      try { if let v = _storage._leftEye {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 10)
      } }()
      try { if let v = _storage._rightEye {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 11)
      } }()
      try { if let v = _storage._noseTip {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 12)
      } }()
      try { if let v = _storage._mouthCentre {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 13)
      } }()
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Face, rhs: Face) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._x != rhs_storage._x {return false}
        if _storage._y != rhs_storage._y {return false}
        if _storage._width != rhs_storage._width {return false}
        if _storage._height != rhs_storage._height {return false}
        if _storage._yaw != rhs_storage._yaw {return false}
        if _storage._pitch != rhs_storage._pitch {return false}
        if _storage._roll != rhs_storage._roll {return false}
        if _storage._quality != rhs_storage._quality {return false}
        if _storage._landmarks != rhs_storage._landmarks {return false}
        if _storage._leftEye != rhs_storage._leftEye {return false}
        if _storage._rightEye != rhs_storage._rightEye {return false}
        if _storage._noseTip != rhs_storage._noseTip {return false}
        if _storage._mouthCentre != rhs_storage._mouthCentre {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
