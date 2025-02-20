Pod::Spec.new do |spec|

  spec.name         = "Ver-ID-3-Serialization"
  spec.version      = "1.1.0"
  spec.summary      = "Protocol buffer serialization of common Ver-ID 3 types"
  spec.homepage     = "https://github.com/AppliedRecognition/Ver-ID-3-Serialization-Apple"
  spec.license      = { :type => "Commercial", :file => "LICENCE.txt" }
  spec.author    = "Jakub Dolejs"
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/AppliedRecognition/Ver-ID-3-Serialization-Apple.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/Serialization/**/*.swift"
  spec.dependency "SwiftProtobuf", ">= 1.28.2", "< 2.0.0"
  spec.dependency "JxlCoder", ">= 1.7.3", "< 2.0.0"
  spec.dependency "VerIDCommonTypes", "~> 1.0"

end
