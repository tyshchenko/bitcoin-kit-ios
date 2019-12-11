Pod::Spec.new do |spec|
  spec.name = 'LitecoinKit.swift'
  spec.module_name = 'LitecoinKit'
  spec.version = '0.9.0'
  spec.summary = 'Litecoiin library for Swift'
  spec.description = <<-DESC
                       LitecoinKit implements Litecoin protocol in Swift.
                       ```
                    DESC
  spec.homepage = 'https://github.com/tyshchenko/bitcoin-kit-ios'
  spec.license = { :type => 'Apache 2.0', :file => 'LICENSE' }
  spec.author = { 'AnkerPay' => 'info@ankerpay.com' }
  spec.social_media_url = 'https://ankerpay.com/'

  spec.requires_arc = true
  spec.source = { git: 'https://github.com/tyshchenko/bitcoin-kit-ios.git', tag: "#{spec.version}" }
  spec.source_files = 'LitecoinKit/LitecoinKit/**/*.{h,m,mm,swift}'
  spec.ios.deployment_target = '11.0'
  spec.swift_version = '5'

  spec.dependency 'BitcoinCore.swift', '~> 0.9.0'
  spec.dependency 'HSCryptoKit', '~> 1.4'
  spec.dependency 'HSHDWalletKit', '~> 1.2'
  spec.dependency 'CryptoBLS.swift', '~> 1.1'
  spec.dependency 'CryptoX11.swift', '~> 1.1'
  spec.dependency 'Alamofire', '~> 4.0'
  spec.dependency 'ObjectMapper', '~> 3.0'
  spec.dependency 'RxSwift', '~> 5.0'
  spec.dependency 'BigInt', '~> 4.0'
  spec.dependency 'GRDB.swift', '~> 4.0'
end
