# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BusTransit_IOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BusTransit_IOS

    pod 'SwiftyGif'

  # 2. Frameworks to be imported  
    pod 'lottie-ios'

  # 3. For drop down
    pod 'DropDown'

  # 4. UIMultiPicker
    pod 'UIMultiPicker'

    pod "Kingfisher"
  # 5. For firebase
    pod "Firebase/Core"
    pod "Firebase/Auth"
    pod "Firebase/Firestore"
    pod "Firebase/Storage"

  # 6. Google Places
    pod 'GooglePlaces', '7.0.0'

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
      end
    end
 end
