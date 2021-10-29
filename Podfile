# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
flutter_application_path = 'hello_flutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'WLIOSFlutterDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for wltest
  pod 'Masonry', '~> 1.1'
  pod 'SnapKit', '~> 4.0.0'

  install_all_flutter_pods(flutter_application_path)


end
