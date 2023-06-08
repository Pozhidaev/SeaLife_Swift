// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Colors {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal enum MainScreen {
    internal static let backgroundColor = ColorAsset(name: "MainScreen/BackgroundColor")
    internal enum ControlPanel {
      internal static let backgroundColor = ColorAsset(name: "MainScreen/ControlPanel/BackgroundColor")
      internal static let buttonsDisabledTitleColor = ColorAsset(name: "MainScreen/ControlPanel/ButtonsDisabledTitleColor")
      internal static let buttonsTitleColor = ColorAsset(name: "MainScreen/ControlPanel/ButtonsTitleColor")
      internal static let frameColor = ColorAsset(name: "MainScreen/ControlPanel/FrameColor")
      internal static let menuButtonColor = ColorAsset(name: "MainScreen/ControlPanel/MenuButtonColor")
      internal static let playButtonColor = ColorAsset(name: "MainScreen/ControlPanel/PlayButtonColor")
      internal static let resetButtonColor = ColorAsset(name: "MainScreen/ControlPanel/ResetButtonColor")
      internal static let sliderTintColor = ColorAsset(name: "MainScreen/ControlPanel/SliderTintColor")
      internal static let textColor = ColorAsset(name: "MainScreen/ControlPanel/TextColor")
    }
  }
  internal enum MenuView {
    internal static let backgroundColor = ColorAsset(name: "MenuView/BackgroundColor")
    internal static let frameColor = ColorAsset(name: "MenuView/FrameColor")
    internal static let startButtonColor = ColorAsset(name: "MenuView/StartButtonColor")
    internal static let startButtonTitleColor = ColorAsset(name: "MenuView/StartButtonTitleColor")
  }
  internal enum SliderView {
    internal static let backgroundColor = ColorAsset(name: "SliderView/BackgroundColor")
    internal static let textColor = ColorAsset(name: "SliderView/TextColor")
    internal static let tintColor = ColorAsset(name: "SliderView/TintColor")
  }
  internal enum WorldBackgroundView {
    internal static let backgroundColor = ColorAsset(name: "WorldBackgroundView/BackgroundColor")
    internal static let cellsFrameColor = ColorAsset(name: "WorldBackgroundView/CellsFrameColor")
    internal static let frameColor = ColorAsset(name: "WorldBackgroundView/FrameColor")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
