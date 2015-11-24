#
Pod::Spec.new do |s|

  s.name         = "NKSwitch"
  s.version      = "0.0.1"
  s.summary      = "A simple switch inspired by https://dribbble.com/shots/2309834-Yet-another-toggle-animation."
  s.description  = <<-DESC
                   A simple switch control inspired by https://dribbble.com/shots/2309834-Yet-another-toggle-animation.

                   DESC

  s.homepage     = "https://github.com/NilStack/NKSwitch"
  s.screenshots  = "https://db.tt/H0ZclkeB"
  s.license      = "MIT"

  s.author       = { "Peng Guo" => "guoleii@gmail.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/NilStack/NKSwitch.git", :tag => "0.0.1" }
  s.source_files  = "NKSwitch/*.swift"
  s.requires_arc = true

end
