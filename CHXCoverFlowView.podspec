Pod::Spec.new do |s|
  s.name = "CHXCoverFlowView"
  s.version = "0.1"
  s.license = "MIT"
  s.summary = "Coverflow for view images like the macOS's finder."
  s.homepage = "https://github.com/cuzv/CHXCoverFlowView"
  s.author = { "Moch Xiao" => "cuzval@gmail.com" }
  s.source = { :git => "https://github.com/cuzv/CHXCoverFlowView.git", :tag => s.version }

  s.ios.deployment_target = "7.0"
  s.source_files = "Sources/*.{h,m}"
  s.requires_arc = true
end
