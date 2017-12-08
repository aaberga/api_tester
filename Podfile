#
# Podfile
#

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!


# Pod definitions

def basic_pods

    #pod 'couchbase-lite-ios'            #, '~> 1.3.1'
    pod 'CrossroadRegex'            #, '~> 1.0.0-alpha.1'
    pod 'SwiftyJSON', '~> 3.1.4'
    
end

def test_pods

    #pod 'couchbase-lite-ios'            #, '~> 1.3.1'
    pod 'CrossroadRegex'            #, '~> 1.0.0-alpha.1'
    pod 'SwiftyJSON', '~> 3.1.4'
    
end


# Target Definitions

target 'TeamWork' do
	basic_pods
end

target 'TeamWorkTests' do
    test_pods
end



post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

