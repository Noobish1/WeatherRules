source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Noobish1/WhatToWearSpecs.git'

use_frameworks!
platform :ios, '10.0'

# Definitions
def testing_pods
    # I need this because its used in Core
    # It doesn't make a lot of sense
    pod 'Then', '2.6.0'
    
    pod 'Quick', '2.2.0'
    pod 'Nimble', '8.0.4'
    pod 'R.swift', '5.0.3'
end

# Targets
target 'ErrorRecorder' do
    pod 'AppCenter/Analytics', '2.5.0'
    pod 'AppCenter/Crashes', '2.5.0'
end

target 'WhatToWearAssets' do
    pod 'R.swift', '5.0.3'
end

target 'WhatToWearCore' do
    pod 'Then', '2.6.0'
    pod 'WhatToWearCommonCore', '2.0.0'
    
    target 'WhatToWearCoreTests' do
        inherit! :search_paths
    
        pod 'WhatToWearCommonCore', '2.0.0'
        testing_pods
    end
end

target 'WhatToWearCharts' do
    pod 'Then', '2.6.0'
    pod 'Tagged', '0.4.0'
    pod 'WhatToWearCommonCore', '2.0.0'
    pod 'WhatToWearCommonModels', '2.2.0'
end

target 'WhatToWearModels' do
    pod 'KeyedAPIParameters', '1.1.0'
    pod 'Tagged', '0.4.0'
    pod 'WhatToWearCommonModels', '2.2.0'
    
    target 'WhatToWearModelsTesting' do
        inherit! :search_paths
        
        pod 'R.swift', '5.0.3'
        pod 'WhatToWearCommonCore', '2.0.0'
        pod 'WhatToWearCommonTesting', '2.0.0'
    end
    
    target 'WhatToWearModelsTests' do
        inherit! :search_paths
        
        # Have to do this so the tests run, I don't know why
        pod 'TaggedTime', '0.4.0'
        pod 'KeyedAPIParameters', '1.1.0'
        pod 'WhatToWearCommonModels', '2.2.0'
        testing_pods
    end
end

target 'WhatToWearNetworking' do
    pod 'KeyedAPIParameters', '1.1.0'
    pod 'Moya/RxSwift', '14.0.0-beta.2'
    pod 'RxSwift' , '5.0.0'
    pod 'WhatToWearCommonModels', '2.2.0'
    
    target 'WhatToWearNetworkingTests' do
        inherit! :search_paths
        
        testing_pods
    end
end

target 'WhatToWearCoreComponents' do
    pod 'RxSwift' , '5.0.0'
    pod 'RxRelay' , '5.0.0'
    pod 'Tagged', '0.4.0'
    pod 'WhatToWearCommonCore', '2.0.0'
    pod 'WhatToWearCommonModels', '2.2.0'
    
    target 'WhatToWearCoreComponentsTests' do
        inherit! :search_paths
        
        pod 'KeyedAPIParameters', '1.1.0'
        pod 'RxSwift' , '5.0.0'
        pod 'Tagged', '0.4.0'
        pod 'RxRelay' , '5.0.0'
        pod 'WhatToWearCommonModels', '2.2.0'
        testing_pods
    end
end

target 'WhatToWearCoreUI' do
    pod 'SnapKit', :git => 'https://github.com/Noobish1/SnapKit.git', :branch => 'feature/superview-or-safearealayoutguide'
    pod 'Then', '2.6.0'
    pod 'RxSwift' , '5.0.0'
    pod 'RxRelay' , '5.0.0'
    pod 'RxCocoa' , '5.0.0'
    pod 'Moya/RxSwift', '14.0.0-beta.2'
    pod 'Tagged', '0.4.0'
    pod 'WhatToWearCommonCore', '2.0.0'
    pod 'WhatToWearCommonModels', '2.2.0'
    
    target 'WhatToWearCoreUITests' do
        inherit! :search_paths
    
        pod 'RxCocoa' , '5.0.0'
        pod 'Moya/RxSwift', '14.0.0-beta.2'
        pod 'SnapKit', :git => 'https://github.com/Noobish1/SnapKit.git', :branch => 'feature/superview-or-safearealayoutguide'
        pod 'Tagged', '0.4.0'
        pod 'KeyedAPIParameters', '1.1.0'
        pod 'WhatToWearCommonCore', '2.0.0'
        pod 'WhatToWearCommonModels', '2.2.0'
        testing_pods
    end
end

target 'WhatToWearExtensionCore' do
    pod 'Then', '2.6.0'
    pod 'SnapKit', :git => 'https://github.com/Noobish1/SnapKit.git', :branch => 'feature/superview-or-safearealayoutguide'
    pod 'Moya/RxSwift', '14.0.0-beta.2'
    pod 'WhatToWearCommonCore', '2.0.0'
    pod 'WhatToWearCommonModels', '2.2.0'
end

target 'ForecastTodayExtension' do
    pod 'Then', '2.6.0'
    pod 'SnapKit', :git => 'https://github.com/Noobish1/SnapKit.git', :branch => 'feature/superview-or-safearealayoutguide'
    pod 'Moya/RxSwift', '14.0.0-beta.2'
    pod 'RxSwift' , '5.0.0'
    pod 'WhatToWearCommonCore', '2.0.0'
    pod 'WhatToWearCommonModels', '2.2.0'
    
    pod 'Reveal-SDK', '24', :configurations => ['Dev-Debug', 'Prod-Debug']
end

target 'MetRulesTodayExtension' do
    pod 'Then', '2.6.0'
    pod 'SnapKit', :git => 'https://github.com/Noobish1/SnapKit.git', :branch => 'feature/superview-or-safearealayoutguide'
    pod 'Moya/RxSwift', '14.0.0-beta.2'
    pod 'RxSwift' , '5.0.0'
    pod 'WhatToWearCommonCore', '2.0.0'
    pod 'WhatToWearCommonModels', '2.2.0'
    
    pod 'Reveal-SDK', '24', :configurations => ['Dev-Debug', 'Prod-Debug']
end

target 'CombinedTodayExtension' do
    pod 'Then', '2.6.0'
    pod 'SnapKit', :git => 'https://github.com/Noobish1/SnapKit.git', :branch => 'feature/superview-or-safearealayoutguide'
    pod 'Moya/RxSwift', '14.0.0-beta.2'
    pod 'RxSwift' , '5.0.0'
    pod 'RxCocoa' , '5.0.0'
    pod 'WhatToWearCommonCore', '2.0.0'
    pod 'WhatToWearCommonModels', '2.2.0'
    
    pod 'Reveal-SDK', '24', :configurations => ['Dev-Debug', 'Prod-Debug']
end

target 'WhatToWear' do
    pod 'Then', '2.6.0'
    pod 'RxSwift' , '5.0.0'
    pod 'RxCocoa', '5.0.0'
    pod 'SnapKit', :git => 'https://github.com/Noobish1/SnapKit.git', :branch => 'feature/superview-or-safearealayoutguide'
    pod 'KeyboardObserver', '2.1.0'
    pod 'Moya/RxSwift', '14.0.0-beta.2'
    pod 'KeyedAPIParameters', '1.1.0'
    pod 'R.swift', '5.0.3'
    pod 'Tagged', '0.4.0'
    pod 'WhatToWearCommonCore', '2.0.0'
    pod 'WhatToWearCommonModels', '2.2.0'
    
    # Debug pods
    pod 'SwiftLint', '0.37.0', :configurations => ['Dev-Debug', 'Prod-Debug']
    pod 'Reveal-SDK', '24', :configurations => ['Dev-Debug', 'Prod-Debug']
    
    target 'WhatToWearTests' do
        inherit! :search_paths
        
        testing_pods
    end
end

post_install do | installer |
    # Update acknowledgements file
    require 'fileutils'
    
    plist_path = 'Pods/Target Support Files/Pods-WhatToWear/Pods-WhatToWear-Acknowledgements.plist'
    bundle_path = 'Settings.bundle/Acknowledgements.plist'
    
    FileUtils.cp_r(plist_path, bundle_path, :remove_destination => true)
    
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
end
