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
    internal static let mainScreenBackgroundColor = ColorAsset(name: "MainScreenBackgroundColor")
    internal static let mainScreenControlPanelBackgroundColor = ColorAsset(name: "MainScreenControlPanelBackgroundColor")
    internal static let mainScreenControlPanelFrameColor = ColorAsset(name: "MainScreenControlPanelFrameColor")
    internal static let mainScreenMenuButtonColor = ColorAsset(name: "MainScreenMenuButtonColor")
    internal static let mainScreenPlayButtonColor = ColorAsset(name: "MainScreenPlayButtonColor")
    internal static let mainScreenResetButtonColor = ColorAsset(name: "MainScreenResetButtonColor")
    internal static let mainScreenSliderTintColor = ColorAsset(name: "MainScreenSliderTintColor")
  }
  internal enum MenuView {
    internal static let menuBackgroundColor = ColorAsset(name: "MenuBackgroundColor")
    internal static let menuFrameColor = ColorAsset(name: "MenuFrameColor")
    internal static let menuStartButtonColor = ColorAsset(name: "MenuStartButtonColor")
    internal static let menuStartButtonTitle = ColorAsset(name: "MenuStartButtonTitle")
  }
  internal enum SliderView {
    internal static let sliderViewBackgroundColor = ColorAsset(name: "SliderViewBackgroundColor")
    internal static let sliderViewSliderTintColor = ColorAsset(name: "SliderViewSliderTintColor")
    internal static let sliderViewTextColor = ColorAsset(name: "SliderViewTextColor")
  }
  internal enum WorldBackgroundView {
    internal static let worldBackgroundColor = ColorAsset(name: "WorldBackgroundColor")
    internal static let worldCellsColor = ColorAsset(name: "WorldCellsColor")
    internal static let worldFrameColor = ColorAsset(name: "WorldFrameColor")
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
