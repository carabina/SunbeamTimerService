Pod::Spec.new do |s|
  s.name             = 'SunbeamTimerService'
  s.version          = '0.1.0'
  s.summary          = 'A simple NSTimer service for iOS develop.'

  s.homepage         = 'https://github.com/sunbeamChen/SunbeamTimerService'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunbeamChen' => 'chenxun1990@126.com' }
  s.source           = { :git => 'https://github.com/sunbeamChen/SunbeamTimerService.git', :tag => s.version.to_s }
  s.social_media_url = 'http://sunbeamchen.github.io/'

  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'SunbeamTimerService/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SunbeamTimerService' => ['SunbeamTimerService/Assets/*.png']
  # }

  s.public_header_files = 'SunbeamTimerService/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
