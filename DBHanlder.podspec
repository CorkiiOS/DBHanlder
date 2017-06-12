#
# Be sure to run `pod lib lint DBHanlder.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DBHanlder'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DBHanlder.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/corkiios/DBHanlder'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'corkiios' => '453664988@qq.com' }
  s.source           = { :git => 'https://github.com/corkiios/DBHanlder.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DBHanlder/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DBHanlder' => ['DBHanlder/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'FMDB'

  s.subspec 'standard' do |ss|
  ss.library = 'sqlite3'
end

end
