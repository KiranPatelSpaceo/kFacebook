Pod::Spec.new do |s|

  s.name         = "kFacebook"
  s.version      = "1.0"
  s.summary      = "Facebook all methods are integratedlogin,logout,Fetch Friends list,Post Text and Image on FBWallPost Text and image to FB’ Friends’s wall,Twitter Login,Fetch Twitter friends's List"


  s.homepage     = "https://github.com/kiran5232/kFacebook"


 s.license      = { :type =>"MIT", :file => "LICENCE" }

  s.author             = { "kiran5232" => "kiran.spaceo@gmail.com" }

  s.source       = { :git => "https://github.com/kiran5232/kFacebook.git", :tag => "1.0" }

 s.source_files  = "kFacebook/*.{h,m}"
  s.platform     = "ios"
  s.platform     = "ios", "6.0"
   s.framework  = "UIKit"

end
