# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'
target 'CheeseCounter' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
# NetWork
pod 'Alamofire'
pod 'Moya/RxSwift'
# UI
pod 'XLActionController'
pod 'XLActionController/Twitter'
pod 'SnapKit'
pod "UPCarouselFlowLayout"  
pod 'AAFragmentManager'
pod 'CircleProgressView'
pod 'NVActivityIndicatorView'
pod 'NextGrowingTextView'
pod 'DZNEmptyDataSet'
pod 'ALCameraViewController'
pod 'Charts'
pod 'lottie-ios'
pod "WSTagsField"
pod 'Eureka'
pod 'TTTAttributedLabel'
pod 'XLPagerTabStrip'
pod 'FlexibleImage', '~> 1.8'
pod 'Toaster'
pod 'BetterSegmentedControl'
# Etc
pod 'FBSDKShareKit'
pod 'FBSDKCoreKit'
pod 'SwiftyJSON'
pod 'KakaoOpenSDK'
pod 'ObjectMapper'
pod 'Kingfisher'
pod 'Firebase/Core' 
pod 'Firebase/Messaging'
pod 'Firebase/DynamicLinks'
pod 'SwiftyImage'
pod 'Fabric'
pod 'Crashlytics'
pod 'SwiftyBeaver'
pod 'URLNavigator'
pod 'AnyDate'
pod 'Hero'
pod 'PMAlertController'
pod 'iCarousel'
pod 'Carte'
# RX
pod 'RxSwift'
pod 'RxCocoa'
pod 'RxDataSources'
pod 'RxGesture'
pod 'RxOptional'
pod 'RxKeyboard'
#Animation
pod 'YLGIFImage'
pod 'Spring', :git => 'https://github.com/MengTo/Spring.git'

#Color
pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git', :branch => 'wip/swift4'
# Pods for CheeseCounter

 target "CheeseCounterTests" do
    inherit! :search_paths
    pod 'Quick'
    pod 'Stubber'
    pod 'Nimble'
    # Pods for testing
  end
end
post_install do |installer|
  pods_dir = File.dirname(installer.pods_project.path)
  at_exit { `ruby #{pods_dir}/Carte/Sources/Carte/carte.rb configure` }
end
