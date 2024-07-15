<br>

<p align="center">
  <picture> 
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/Mijick/Assets/blob/main/CameraView/Logotype/On%20Dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/Mijick/Assets/blob/main/CameraView/Logotype/On%20Light.svg">
    <img alt="CameraView Logo" src="https://github.com/Mijick/Assets/blob/main/CameraView/Logotype/On%20Dark.svg" width="76%"">
  </picture>
</p>

<h3 style="font-size: 5em" align="center">
    Camera made simple
</h3>

<p align="center">
    Create fully customisable camera view in no time. Keep your code clean
</p>

<p align="center">
    <a href="https://github.com/Mijick/CameraView-Demo" rel="nofollow">Try demo we prepared</a>
    |
    <a href="https://mijick.notion.site/ed227d35caa249e4a04e3a1e93129576?v=013c9f8962744b9f84bf4b3a544196db" rel="nofollow">Roadmap</a>
    |
    <a href="https://github.com/Mijick/CameraView/issues/new" rel="nofollow">Propose a new feature</a>
</p>

<br>

<p align="center">
    <img alt="SwiftUI logo" src="https://github.com/Mijick/Assets/blob/main/CameraView/Labels/Language.svg"/>
    <img alt="Platforms: iOS, iPadOS, macOS, tvOS" src="https://github.com/Mijick/Assets/blob/main/CameraView/Labels/Platforms.svg"/>
    <img alt="Current Version" src="https://github.com/Mijick/Assets/blob/main/CameraView/Labels/Version.svg"/>
    <img alt="License: MIT" src="https://github.com/Mijick/Assets/blob/main/CameraView/Labels/License.svg"/>
</p>

<p align="center">
    <img alt="Made in Kraków" src="https://github.com/Mijick/Assets/blob/main/CameraView/Labels/Origin.svg"/>
    <a href="https://twitter.com/MijickTeam">
        <img alt="Follow us on X" src="https://github.com/Mijick/Assets/blob/main/CameraView/Labels/X.svg"/>
    </a>
    <a href=mailto:team@mijick.com?subject=Hello>
        <img alt="Let's work together" src="https://github.com/Mijick/Assets/blob/main/CameraView/Labels/Work%20with%20us.svg"/>
    </a>  
    <a href="https://github.com/Mijick/CameraView/stargazers">
        <img alt="Stargazers" src="https://github.com/Mijick/Assets/blob/main/CameraView/Labels/Stars.svg"/>
    </a>                                                                                                               
</p>

<p align="center">
    <img alt="Popup Examples" src="https://github.com/Mijick/Assets/blob/main/CameraView/GIFs/CameraView-1.gif" width="24.5%"/>
    <img alt="Popup Examples" src="https://github.com/Mijick/Assets/blob/main/CameraView/GIFs/CameraView-2.gif" width="24.5%"/>
    <img alt="Popup Examples" src="https://github.com/Mijick/Assets/blob/main/CameraView/GIFs/CameraView-3.gif" width="24.5%"/>
    <img alt="Popup Examples" src="https://github.com/Mijick/Assets/blob/main/CameraView/GIFs/CameraView-4.gif" width="24.5%"/>
</p>

<br>


CameraView by Mijick is a powerful, open-source library that simplifies the camera presentation process, making it super fast and totally customisable, allowing you to focus on the important elements of your project while hiding the technical complexities.
* **Customise your UI completely.** Use a clean and modern UI we designed or change it completely within minutes!
* **Covers the entire process.** Our library both presents the camera controller, asks for permissions, displays an error view if permissions are not granted, and shows the result of the capture in a separate view (if you wish, of course).
* **Improves code quality.** Allows you to focus on the most important things, hiding implementation details inside this powerful library.
* **Designed for SwiftUI.** As we developed the library, we utilized SwiftUI's capabilities to offer you a powerful tool for streamlining your implementation process.


<br>

# Getting Started
### ✋ Requirements

| **Platforms** | **Minimum Swift Version** |
|:----------|:----------|
| iOS 14+ | 5.10 |

### ⏳ Installation

#### [Swift Package Manager][spm]
Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the Swift compiler.

Once you have your Swift package set up, adding CameraView as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Mijick/CameraView.git", branch(“main”))
]
```

#### [Cocoapods][cocoapods]   
Cocoapods is a dependency manager for Swift and Objective-C Cocoa projects that helps to scale them elegantly.

Installation steps:
- Install CocoaPods 1.10.0 (or later)
- [Generate CocoaPods][generate_cocoapods] for your project
```Swift
    pod init
```
- Add CocoaPods dependency into your `Podfile`   
```Swift
    pod 'MijickCameraView'
```
- Install dependency and generate `.xcworkspace` file
```Swift
    pod install
```
- Use new XCode project file `.xcworkspace`
<br>


# Usage
### 1. Modify the info.plist file
Open the info.plist file of your project. Add two new keys: `Privacy - Microphone Usage Description` and `Privacy - Camera Usage Description`. Value will be displayed by default in the error screen when the user denies access to one of the above permissions.

![CleanShot 2024-05-06 at 13 41 25](https://github.com/Mijick/CameraView/assets/23524947/5da706bd-1d16-49f9-8e58-3a416872bb68)


### 2. Create a new CameraManager object
Create a camera manager object in the view structure to contain MCameraController. It can be initialized with attributes, with which you will start an instance of your camera.
```Swift
struct CameraView: View {
    @ObservedObject private var manager: CameraManager = .init(
        outputType: .photo,
        cameraPosition: .back,
        cameraFilters: [.init(name: "CISepiaTone")!],
        flashMode: .off,
        isGridVisible: true,
        focusImageColor: .blue,
        focusImageSize: 100
    )

    (...)
   
    var body: some View {
        (...)
    }

    (...)
}
```


### 3. Insert MCameraController into the selected view
MCameraController contains three screens - `CameraView`, `CameraPreview` (which can be turned off) and `CameraErrorView`. Therefore, we advise that there should be no other elements in the view where you declare `MCameraController`. We’ve designed this system around the experience and needs of ourselves and the developers we know. However, if your preferences are different, we are happy to meet your expectations and adapt our library. Share them with us by creating an [issue][AddIssue] for this project.
```Swift
struct CameraView: View {
    @ObservedObject private var manager: CameraManager = (...)

    (...)
   
    var body: some View {
        MCameraController(manager: manager)
    }

    (...)
}
```


### 4. Declare `onImageCaptured`, `onVideoCaptured`, `afterMediaCaptured` and `onCloseController`
The above functions define what happens after a given action and are optional; for example, if your application only captures images, you don't need to declare onVideoCaptured and so on.
```Swift
struct CameraView: View {

    (...)
   
    var body: some View {
        MCameraController(manager: manager)
            .onImageCaptured { data in
                print("IMAGE CAPTURED")
            }
            .onVideoCaptured { url in
                print("VIDEO CAPTURED")
            }
            .afterMediaCaptured {
                print("IMAGE OR VIDEO WAS PROCESSED. WHAT'S NEXT?")
            }
            .onCloseController {
                print("CLOSE THE CONTROLLER")
            }
    }

    (...)
}
```


### 5. (Optional) Block screen rotation for MCameraController
CameraView library by Mijick, allows you to lock the screen rotation for `MCameraController`, even if a **device rotation is unlocked**.
To achieve it, create an AppDelegate class conforming to `MApplicationDelegate`, declare `@UIApplicationDelegateAdaptor` in `@main struct` and set `lockOrientation(AppDelegate.self)` for `MCameraController`.
```Swift
class AppDelegate: NSObject, MApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask { AppDelegate.orientationLock }
}
```

```Swift
@main struct CameraView_DemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup(content: CameraView.init)
    }
}
```

```Swift
struct CameraView: View {

    (...)
   
    var body: some View {
        MCameraController(manager: manager)
            .lockOrientation(AppDelegate.self)
    }

    (...)
}
```

### 6. (Optional) Change CameraView UI
You can change the appearance of the `CameraView` by creating a new structure, conforming to `MCameraView` and using the `cameraScreen` modifier.
```Swift
struct CustomCameraView: MCameraView {
    @ObservedObject var cameraManager: MijickCameraView.CameraManager
    let namespace: Namespace.ID
    let closeControllerAction: () -> ()


    var body: some View {
        VStack(spacing: 0) {
            createNavigationBar()
            createCameraView()
            createCaptureButton()
        }
    }
}
private extension CustomCameraView {
    func createNavigationBar() -> some View {
        Text("This is a Custom Camera View")
            .padding(.top, 12)
            .padding(.bottom, 12)
    }
    func createCaptureButton() -> some View {
        Button(action: captureOutput) { Text("Click to capture") }
            .padding(.top, 12)
            .padding(.bottom, 12)
    }
}
```

```Swift
struct CameraView: View {

    (...)
   
    var body: some View {
        MCameraController(manager: manager)
            .cameraScreen(CustomCameraView.init)
    }

    (...)
}
```


### 7. (Optional) Change (or disable) CameraPreview UI
You can change the appearance of the `CameraPreview` by creating a new structure, conforming to `MCameraPreview` and using the `mediaPreviewScreen` modifier.
<br>
**Note:** To disable the preview of captured media, use the mediaPreviewScreen modifier with nil as the argument.
```Swift
struct CustomCameraPreview: MCameraPreview {
    let capturedMedia: MijickCameraView.MCameraMedia
    let namespace: Namespace.ID
    let retakeAction: () -> ()
    let acceptMediaAction: () -> ()


    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            createContentView()
            Spacer()
            createButtons()
        }
    }
}
private extension CustomCameraPreview {
    func createContentView() -> some View { ZStack {
        if let image = capturedMedia.image { createImageView(image) }
        else { EmptyView() }
    }}
    func createButtons() -> some View {
        HStack(spacing: 24) {
            createRetakeButton()
            createSaveButton()
        }
    }
}
private extension CustomCameraPreview {
    func createImageView(_ image: Data) -> some View {
        Image(uiImage: .init(data: image) ?? .init())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .ignoresSafeArea()
    }
    func createRetakeButton() -> some View {
        Button(action: retakeAction) { Text("Retake") }
    }
    func createSaveButton() -> some View {
        Button(action: acceptMediaAction) { Text("Save") }
    }
}
```

```Swift
struct CameraView: View {

    (...)
   
    var body: some View {
        MCameraController(manager: manager)
            .mediaPreviewScreen(CustomCameraPreview.init)
    }

    (...)
}
```


### 8. (Optional) Change CameraErrorView UI
You can change the appearance of the `CameraErrorView` by creating a new structure, conforming to `MCameraErrorView` and using the `errorScreen` modifier.
```Swift
struct CustomCameraErrorView: MCameraErrorView {
    let error: CameraManager.Error
    let closeControllerAction: () -> ()


    var body: some View {
        Button(action: openAppSettings) { Text("Open Settings") }
    }
}
```

```Swift
struct CameraView: View {

    (...)
   
    var body: some View {
        MCameraController(manager: manager)
            .errorScreen(CustomCameraErrorView.init)
    }

    (...)
}
```


<br>

# Try our demo
See for yourself how does it work by cloning [project][Demo] we created

# License
CameraView is released under the MIT license. See [LICENSE][License] for details.

<br><br>

# Our other open source SwiftUI libraries
[PopupView] - The most powerful popup library that allows you to present any popup
<br>
[NavigationView] - Easier and cleaner way of navigating through your app
<br>
[CalendarView] - Create your own calendar object in no time
<br>
[GridView] - Lay out your data with no effort
<br>
[Timer] - Modern API for Timer




[MIT]: https://en.wikipedia.org/wiki/MIT_License
[SPM]: https://www.swift.org/package-manager

[Demo]: https://github.com/Mijick/CameraView-Demo
[AddIssue]: https://github.com/Mijick/CameraView/issues/new
[License]: https://github.com/Mijick/CameraView/blob/main/LICENSE

[spm]: https://www.swift.org/package-manager/
[cocoapods]: https://cocoapods.org/
[generate_cocoapods]: https://github.com/square/cocoapods-generate

[PopupView]: https://github.com/Mijick/PopupView
[NavigationView]: https://github.com/Mijick/NavigationView
[CalendarView]: https://github.com/Mijick/CalendarView 
[GridView]: https://github.com/Mijick/GridView
[Timer]: https://github.com/Mijick/Timer
