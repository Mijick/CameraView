Pod::Spec.new do |s|
    s.name                  = 'MijickCameraView'
    s.summary               = 'Camera made simple'
    s.description           = <<-DESC
    CameraView is a free and open-source library dedicated for SwiftUI that allows you to create fully customisable camera view in no time. Keep your code clean.
                            DESC

    s.version               = '2.0.0'
    s.ios.deployment_target = '14.0'
    s.swift_version         = '5.10'

    s.source_files          = 'Sources/**/*.{swift}'
    s.resources             = 'Sources/Internal/Assets/*.{xcassets, json}'
    s.dependency            'MijickTimer'
    s.frameworks            = 'SwiftUI', 'Foundation', 'AVKit', 'AVFoundation', 'MijickTimer'

    s.homepage              = 'https://github.com/Mijick/CameraView.git'
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.author                = { 'Tomasz Kurylik' => 'tomasz.kurylik@mijick.com' }
    s.source                = { :git => 'https://github.com/Mijick/CameraView.git', :tag => s.version.to_s }
end
