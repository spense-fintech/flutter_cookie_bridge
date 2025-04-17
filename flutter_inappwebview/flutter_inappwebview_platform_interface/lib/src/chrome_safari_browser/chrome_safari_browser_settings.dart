import 'dart:ui';

import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../types/activity_button.dart';
import '../types/android_resource.dart';
import '../types/custom_tabs_share_state.dart';
import '../types/dismiss_button_style.dart';
import '../types/main.dart';
import '../types/modal_presentation_style.dart';
import '../types/modal_transition_style.dart';
import '../types/trusted_web_activity_display_mode.dart';
import '../types/trusted_web_activity_screen_orientation.dart';
import '../types/ui_event_attribution.dart';
import '../util.dart';
import 'android/chrome_custom_tabs_options.dart';
import 'apple/safari_options.dart';

part 'chrome_safari_browser_settings.g.dart';

TrustedWebActivityDisplayMode? _deserializeDisplayMode(
    Map<String, dynamic>? displayMode) {
  if (displayMode == null) {
    return null;
  }
  switch (displayMode["type"]) {
    case "IMMERSIVE_MODE":
      return TrustedWebActivityImmersiveDisplayMode.fromMap(displayMode);
    case "DEFAULT_MODE":
    default:
      return TrustedWebActivityDefaultDisplayMode();
  }
}

class ChromeSafariBrowserOptions {
  Map<String, dynamic> toMap() {
    return {};
  }

  static ChromeSafariBrowserOptions fromMap(Map<String, dynamic> map) {
    return new ChromeSafariBrowserOptions();
  }

  ChromeSafariBrowserOptions copy() {
    return ChromeSafariBrowserOptions.fromMap(this.toMap());
  }

  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

///Class that represents the settings that can be used for an [ChromeSafariBrowser] window.
@ExchangeableObject(copyMethod: true)
class ChromeSafariBrowserSettings_ implements ChromeSafariBrowserOptions {
  ///The share state that should be applied to the custom tab. The default value is [CustomTabsShareState.SHARE_STATE_DEFAULT].
  ///
  ///**NOTE**: Not available in a Trusted Web Activity.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  CustomTabsShareState_? shareState;

  ///Set to `false` if the title shouldn't be shown in the custom tab. The default value is `true`.
  ///
  ///**NOTE**: Not available in a Trusted Web Activity.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  bool? showTitle;

  ///Set the custom background color of the toolbar.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  Color_? toolbarBackgroundColor;

  ///Sets the navigation bar color. Has no effect on Android API versions below L.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  Color_? navigationBarColor;

  ///Sets the navigation bar divider color. Has no effect on Android API versions below P.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  Color_? navigationBarDividerColor;

  ///Sets the color of the secondary toolbar.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  Color_? secondaryToolbarColor;

  ///Set to `true` to enable the url bar to hide as the user scrolls down on the page. The default value is `false`.
  ///
  ///**NOTE**: Not available in a Trusted Web Activity.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  bool? enableUrlBarHiding;

  ///Set to `true` to enable Instant Apps. The default value is `false`.
  ///
  ///**NOTE**: Not available in a Trusted Web Activity.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  bool? instantAppsEnabled;

  ///Set an explicit application package name that limits
  ///the components this Intent will resolve to.  If left to the default
  ///value of null, all components in all applications will considered.
  ///If non-null, the Intent can only match the components in the given
  ///application package.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  String? packageName;

  ///Set to `true` to enable Keep Alive. The default value is `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  bool? keepAliveEnabled;

  ///Set to `true` to launch the Android activity in `singleInstance` mode. The default value is `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  bool? isSingleInstance;

  ///Set to `true` to launch the Android intent with the flag `FLAG_ACTIVITY_NO_HISTORY`. The default value is `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  bool? noHistory;

  ///Set to `true` to launch the Custom Tab as a Trusted Web Activity. The default value is `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  bool? isTrustedWebActivity;

  ///Sets a list of additional trusted origins that the user may navigate or be redirected to from the starting uri.
  ///
  ///**NOTE**: Available only in a Trusted Web Activity.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  List<String>? additionalTrustedOrigins;

  ///Sets a display mode of a Trusted Web Activity.
  ///
  ///**NOTE**: Available only in a Trusted Web Activity.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  @ExchangeableObjectProperty(deserializer: _deserializeDisplayMode)
  TrustedWebActivityDisplayMode_? displayMode;

  ///Sets a screen orientation. This can be used e.g. to enable the locking of an orientation lock type.
  ///
  ///**NOTE**: Available only in a Trusted Web Activity.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  TrustedWebActivityScreenOrientation_? screenOrientation;

  ///Sets the start animations.
  ///It must contain 2 [AndroidResource], where the first one represents the "enter" animation for the browser
  ///and the second one represents the "exit" animation for the application.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  List<AndroidResource_>? startAnimations;

  ///Sets the exit animations.
  ///It must contain 2 [AndroidResource], where the first one represents the "enter" animation for the application
  ///and the second one represents the "exit" animation for the browser.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  List<AndroidResource_>? exitAnimations;

  ///Adds the necessary flags and extras to signal any browser supporting custom tabs to use the browser UI
  ///at all times and avoid showing custom tab like UI.
  ///Calling this with an intent will override any custom tabs related customizations.
  ///The default value is `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android
  bool? alwaysUseBrowserUI;

  ///Set to `true` if Reader mode should be entered automatically when it is available for the webpage. The default value is `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  bool? entersReaderIfAvailable;

  ///Set to `true` to enable bar collapsing. The default value is `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  bool? barCollapsingEnabled;

  ///Set the custom style for the dismiss button. The default value is [DismissButtonStyle.DONE].
  ///
  ///**NOTE**: available on iOS 11.0+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  DismissButtonStyle_? dismissButtonStyle;

  ///Set the custom background color of the navigation bar and the toolbar.
  ///
  ///**NOTE**: available on iOS 10.0+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  Color_? preferredBarTintColor;

  ///Set the custom color of the control buttons on the navigation bar and the toolbar.
  ///
  ///**NOTE**: available on iOS 10.0+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  Color_? preferredControlTintColor;

  ///Set the custom modal presentation style when presenting the WebView. The default value is [ModalPresentationStyle.FULL_SCREEN].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ModalPresentationStyle_? presentationStyle;

  ///Set to the custom transition style when presenting the WebView. The default value is [ModalTransitionStyle.COVER_VERTICAL].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ModalTransitionStyle_? transitionStyle;

  ///An additional button to be shown in `SFSafariViewController`'s toolbar.
  ///This allows the user to access powerful functionality from your extension without needing to first show the `UIActivityViewController`.
  ///
  ///**NOTE**: available on iOS 15.0+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ActivityButton_? activityButton;

  ///An event attribution associated with a click that caused this `SFSafariViewController` to be opened.
  ///This attribute is ignored if the `SFSafariViewController` url has a scheme of 'http'.
  ///
  ///**NOTE**: available on iOS 15.2+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  UIEventAttribution_? eventAttribution;

  @ExchangeableObjectConstructor()
  ChromeSafariBrowserSettings_(
      {this.shareState = CustomTabsShareState_.SHARE_STATE_DEFAULT,
      this.showTitle = true,
      this.toolbarBackgroundColor,
      this.navigationBarColor,
      this.navigationBarDividerColor,
      this.secondaryToolbarColor,
      this.enableUrlBarHiding = false,
      this.instantAppsEnabled = false,
      this.packageName,
      this.keepAliveEnabled = false,
      this.isSingleInstance = false,
      this.noHistory = false,
      this.isTrustedWebActivity = false,
      this.additionalTrustedOrigins = const [],
      this.displayMode,
      this.screenOrientation = TrustedWebActivityScreenOrientation_.DEFAULT,
      this.startAnimations,
      this.exitAnimations,
      this.alwaysUseBrowserUI = false,
      this.entersReaderIfAvailable = false,
      this.barCollapsingEnabled = false,
      this.dismissButtonStyle = DismissButtonStyle_.DONE,
      this.preferredBarTintColor,
      this.preferredControlTintColor,
      this.presentationStyle = ModalPresentationStyle_.FULL_SCREEN,
      this.transitionStyle = ModalTransitionStyle_.COVER_VERTICAL,
      this.activityButton,
      this.eventAttribution}) {
    if (startAnimations != null) {
      assert(startAnimations!.length == 2,
          "start animations must be have 2 android resources");
    }
    if (exitAnimations != null) {
      assert(exitAnimations!.length == 2,
          "exit animations must be have 2 android resources");
    }
  }

  @override
  @ExchangeableObjectMethod(ignore: true)
  ChromeSafariBrowserSettings_ copy() {
    throw UnimplementedError();
  }

  @override
  @ExchangeableObjectMethod(ignore: true)
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  @ExchangeableObjectMethod(ignore: true)
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}

///Class that represents the options that can be used for an [ChromeSafariBrowser] window.
///Use [ChromeSafariBrowserSettings] instead.
@Deprecated('Use ChromeSafariBrowserSettings instead')
class ChromeSafariBrowserClassOptions {
  ///Android-specific options.
  AndroidChromeCustomTabsOptions? android;

  ///iOS-specific options.
  IOSSafariOptions? ios;

  ChromeSafariBrowserClassOptions({this.android, this.ios}) {
    this.android = this.android ?? AndroidChromeCustomTabsOptions();
    this.ios = this.ios ?? IOSSafariOptions();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> options = {};
    if (Util.isAndroid)
      options.addAll(this.android?.toMap() ?? {});
    else if (Util.isIOS) options.addAll(this.ios?.toMap() ?? {});

    return options;
  }

  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
