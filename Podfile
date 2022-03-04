# Uncomment the next line to define a global platform for your project
platform :ios, '14.4'

target 'Tinder' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for Tinder
	pod 'Firebase/Auth'
	pod 'Firebase/Firestore'
	pod 'Firebase/Storage'
	pod 'SDWebImage', '~> 5.0'
	pod 'JGProgressHUD'
  pod 'MessageKit', '~> 3.3.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.4'
    end
  end
end
