#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ucw_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ucw_sdk'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  s.vendored_framework = "Frameworks/TSSSDK.xcframework"
  
  tsssdk_url = 'https://cobo-tss-node.s3.amazonaws.com/sdk/v0.10.0/cobo-tss-sdk-v2-ios-v0.10.0.zip'
  s.prepare_command = <<-CMD
    rm -rf Frameworks
    mkdir -p Frameworks && cd Frameworks
    curl -L #{tsssdk_url} -o tsssdk.zip
    unzip -o tsssdk.zip
    mv cobo-tss-sdk-v2-ios/* .
    rm -rf cobo-tss-sdk-v2-ios
    rm tsssdk.zip
  CMD

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
