// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Button {
    /// Menu
    internal static let menu = Strings.tr("Localizable", "Button.Menu", fallback: "Menu")
    /// Ok
    internal static let ok = Strings.tr("Localizable", "Button.Ok", fallback: "Ok")
    /// Pause
    internal static let pause = Strings.tr("Localizable", "Button.Pause", fallback: "Pause")
    /// Play
    internal static let play = Strings.tr("Localizable", "Button.Play", fallback: "Play")
    /// Reset
    internal static let reset = Strings.tr("Localizable", "Button.Reset", fallback: "Reset")
  }
  internal enum MainScreen {
    /// Animation Speed
    internal static let animationSpeed = Strings.tr("Localizable", "MainScreen.AnimationSpeed", fallback: "Animation Speed")
    /// Creatures Speed
    internal static let creaturesSpeed = Strings.tr("Localizable", "MainScreen.CreaturesSpeed", fallback: "Creatures Speed")
  }
  internal enum Menu {
    internal enum Button {
      /// Cancel
      internal static let cancel = Strings.tr("Localizable", "Menu.Button.Cancel", fallback: "Cancel")
      /// Start
      internal static let start = Strings.tr("Localizable", "Menu.Button.Start", fallback: "Start")
    }
    internal enum FishCount {
      /// Fish count
      internal static let title = Strings.tr("Localizable", "Menu.FishCount.Title", fallback: "Fish count")
    }
    internal enum OrcaCount {
      /// Orca count
      internal static let title = Strings.tr("Localizable", "Menu.OrcaCount.Title", fallback: "Orca count")
    }
    internal enum XSize {
      /// Horizontal size
      internal static let title = Strings.tr("Localizable", "Menu.XSize.Title", fallback: "Horizontal size")
    }
    internal enum YSize {
      /// Vertical Size
      internal static let title = Strings.tr("Localizable", "Menu.YSize.Title", fallback: "Vertical Size")
    }
  }
  internal enum SliderView {
    internal enum Maximum {
      /// ?
      internal static let unknown = Strings.tr("Localizable", "SliderView.Maximum.Unknown", fallback: "?")
    }
    internal enum Minimum {
      /// ?
      internal static let unknown = Strings.tr("Localizable", "SliderView.Minimum.Unknown", fallback: "?")
    }
    internal enum Value {
      /// ?
      internal static let unknown = Strings.tr("Localizable", "SliderView.Value.Unknown", fallback: "?")
    }
  }
  internal enum World {
    internal enum Finish {
      /// Localizable.strings
      ///   SeaLife_Swift
      /// 
      ///   Created by Sergey Pozhidaev on 23.05.2023.
      internal static let empty = Strings.tr("Localizable", "World.Finish.Empty", fallback: "World become empty")
      /// World become full with no move
      internal static let full = Strings.tr("Localizable", "World.Finish.Full", fallback: "World become full with no move")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

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
// swiftlint:enable all
