#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
s.name             = 'flutter_braintree'
s.version          = '0.0.1'
s.summary          = 'Braintree DropIn UI plugin for Flutter.'
s.description      = <<-DESC
Braintree DropIn UI plugin for Flutter.
DESC
s.homepage         = 'http://www.keepinmind.info'
s.license          = { :file => '../LICENSE' }
s.author           = { 'KIM Keep In Mind' => 'info@keepinmind.info' }
s.source           = { :path => '.' }
s.source_files = 'Classes/**/*'
s.public_header_files = 'Classes/**/*.h'
s.dependency 'Flutter'
s.dependency 'BraintreeDropIn'
s.dependency 'Braintree/PayPal'
s.ios.deployment_target = '10.0'
s.static_framework = true

end
