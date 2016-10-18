Pod::Spec.new do |s|

  s.name         = "NFTabControlView"
  s.version      = "0.0.2"
  s.summary      = "Tab control for iOS like UISegmentedControl only with more pizazz."
  s.description  = "This flexible control works a lot like UISegmentedControl, only with nice delegate methods for selecting tabs, a fun animation, and configurable colors."
  s.homepage     = "https://github.com/nickfedoroff/NFTabControlView"
  s.license      = { :type => 'MIT' }
  s.author             = { "Nick Fedoroff" => "nick@nickfedoroff.com" }
  s.social_media_url   = "http://twitter.com/nfedoroff"
  s.platform     = :ios, "9.3"
  s.source       = { :git => "https://github.com/nickfedoroff/NFTabControlView.git", :tag => "#{s.version}" }
  s.source_files  = "NFTabControlView", "NFTabControlView/**/*.{h,m}"

end
