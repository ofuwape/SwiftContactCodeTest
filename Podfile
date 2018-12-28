source "https://github.com/cocoapods/Specs.git"

use_frameworks!
platform :ios, '9.0'

def podsForRuntime
  pod 'RealmSwift'
  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa',    '~> 4.0'
end

def podsForTesting
  pod 'RxBlocking', '~> 4.0'
  pod 'RxTest',     '~> 4.0'
end

target 'Code Test Oluwatoni Fuwape' do
  use_frameworks!
  podsForRuntime

  target 'Code Test Oluwatoni FuwapeTests' do
    use_frameworks!
    podsForRuntime
    podsForTesting
  end

#  target 'Code Test Oluwatoni FuwapeUITests' do
#    use_frameworks!
#    podsForRuntime
#    podsForTesting
#    inherit! :search_paths
#  end

end
