Pod::Spec.new do |s|
  s.name             = 'KTSwiftAlert'
  s.version          = '1.0'
  s.summary          = 'A simple configurable alert in Swift.'


  s.homepage         = 'https://github.com/kvtaniguchi/KTSwiftAlert'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kvtaniguchi' => 'ktaniguchi@urbn.com' }
  s.source           = { :git => 'https://github.com/kvtaniguchi/KTSwiftAlert.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'KTSwiftAlert/Classes/**/*'

  s.dependency 'URBNSwiftyConvenience'
end
