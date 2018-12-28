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
  pod 'Reveal-SDK', '~> 13', configuration:'Debug'

  target 'Code Test Oluwatoni FuwapeTests' do
    use_frameworks!
    podsForRuntime
    podsForTesting
  end

end
