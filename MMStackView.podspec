#
# Be sure to run `pod lib lint MMStackView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MMStackView"
  s.version          = "0.1.0"
  s.summary          = "MMStackView like cards list view in wallet app."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
MMStackView 实现了ApplePay中卡片展示的效果，而且还支持自动分页，每页的卡片数量根据View的高度自动计算。使用MMStackView跟使用UITableView一样简单，MMStackView提供了MMStackCell，可以继承MMStackCell来自定义。
                       DESC

  s.homepage         = "https://github.com/mmy812/MMStackView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "mmy" => "ymm.812@gmail.com" }
  s.source           = { :git => "https://github.com/mmy812/MMStackView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/mmy812'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MMStackView' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
