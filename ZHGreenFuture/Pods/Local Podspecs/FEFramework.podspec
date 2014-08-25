Pod::Spec.new do |s|

  s.name         = "FEFramework"
  s.version      = "0.0.1"
  s.summary      = "FEFramework source ."

  s.description  = <<-DESC
                   FEFramework description
                   DESC
                   
  s.homepage     = "xxx"
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
           FEFramework-INC copyright
    LICENSE
  }
  
  s.author       = { "zzzfly121" => "zzzfly121@gmail.com" }

  s.platform     = :ios
  s.ios.deployment_target = '5.0'
  
  #s.source = {:git=> 'git@github.com:FerrariXX/FEFramework.git',:tag => "0.1.0" }
  s.source = {:git=> 'git@github.com:FerrariXX/FEFramework.git',:commit => 'aebb98d' }
  s.source_files = 'Source/**/*.{h,c,m,mm}'
  s.resources = 'Resources/**/*.{png,xib,wav,plist}', 'Source/**/*.{png,xib,wav,plist}'
  s.requires_arc = true
  s.prefix_header_file = 'FEFramework/FEFramework-Prefix.pch'
  
  #s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => "'' " }
  
  #s.dependency   'xx'
  #s.libraries = 'xx'
 
end

