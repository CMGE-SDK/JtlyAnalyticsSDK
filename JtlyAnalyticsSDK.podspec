#
# Be sure to run `pod lib lint JtlyAnalyticsSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JtlyAnalyticsSDK'
  s.version          = '1.5.0'
  s.summary          = 'A short description of JtlyAnalyticsSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/WakeyWoo/JtlyAnalyticsSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WakeyWoo' => 'hjw728uow@gmail.com' }
  s.source           = { :git => 'https://github.com/WakeyWoo/JtlyAnalyticsSDK.git', :tag => "1.5.1" }
  #s.ios.deployment_target = "9.0"
  s.libraries        = 'sqlite3'
  s.requires_arc  = true
  #s.default_subspecs = 'JtlyAnalyticsSDK'
  s.platform     = :ios, "9.0"
  # s.dependency 'ThinkingSDK','= 2.7.4'
  # s.social_media_url = 'https://twitter.com/WakeyWoo'
  
  #s.default_subspec = 'JtlyAnalyticsKit'
  s.pod_target_xcconfig = {
    'VALID_ARCHS' => 'arm64'
  }
  
  s.subspec 'JtlyAnalyticsSDK' do |c|
    c.ios.deployment_target = '9.0'
    #c.public_header_files = 'JtlyAnalyticsSDK/Frameworks/includes/*.h'
    c.vendored_frameworks = 'JtlyAnalyticsSDK/Frameworks/JtlyAnalyticsKit.xcframework'
  
    c.ios.pod_target_xcconfig = {
      'OTHER_LDFLAGS' => '-ObjC'
    }
    
    #'LD_RUNPATH_SEARCH_PATHS' => ['/usr/lib/swift', '@executable_path/Frameworks']
    #c.source_files = 'Sources/Producer/**/*.{h,m}', 'Sources/aliyun-log-c-sdk/**/*.{c,h}'
    
  end
  
  s.subspec 'ThinkingSDK' do |c|
      c.ios.deployment_target = '9.0'
      c.vendored_frameworks = 'JtlyAnalyticsSDK/Frameworks/ThinkingSDK/ThinkingDataCore.xcframework', 'JtlyAnalyticsSDK/Frameworks/ThinkingSDK/ThinkingSDK.xcframework'
      c.ios.pod_target_xcconfig = {
          'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
      }
      
      c.user_target_xcconfig = {
        'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
      }
  end
  
end
