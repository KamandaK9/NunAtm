source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
target 'NoneAttm' do

  
pod 'GooglePlaces'
pod 'GoogleMaps'
pod 'SwiftyJSON'
pod 'Panels'
pod 'ReachabilitySwift'
pod 'RevealingSplashView'
pod 'Firebase/Database'
pod 'GeoFire', :git => 'https://github.com/firebase/geofire-objc.git'
pod 'LayoutHelper'





end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    next unless config.name == 'Debug'
    config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = [
      '$(FRAMEWORK_SEARCH_PATHS)'
    ]
  end
end


