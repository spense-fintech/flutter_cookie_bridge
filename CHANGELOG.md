# CHANGELOG

## 1.0.0 - 2024-10-10

- Initial release of flutter_cookie_bridge.

## 1.0.1 - 2024-10-29

- Added whitelisting of URLs from parameters.
- Fixed cookie synchronization issue.
- Implemented callback functionality.
- Added back navigation

## 1.0.2 - 2025-01-07

- Fixed non whitelisted url blocking issue
- Fixed the redirect looping issue

## 1.0.3 - 2025-01-07

- Fixed the static Global Key in WebView

## 1.0.4 - 2025-01-07

- Fixed the WebView SafeArea issue

## 1.0.5 - 2025-02-04

- Added support for Flutter 3.1.0 and above instead of 3.3.0 and above

## 1.0.6 - 2025-02-07

- Added error response in case of request failures

## 1.0.7 - 2025-02-13

- Added support for accessing permissions in WebView and some minor fixes

## 1.0.8 - 2025-02-17

- Fixed Flutter Downloader initialization issue
- Minor fixes

## 1.0.9 - 2025-02-17

- Redirect issue fixed

## 1.0.10 - 2025-02-18

- Flutter downloader removed

## 1.0.11 - 2025-02-18

- Flutter downloader provider removed from Manifest

## 1.0.12 - 2025-02-18

- Added mounted check in the setState

## 1.0.13 - 2025-02-18

- Fixed the navigation issue

## 1.0.14 - 2025-02-18

- Removed mounted check in the setState

## 1.0.15 - 2025-02-18

- Removed logout

## 1.0.16 - 2025-02-19

- Removed redundant set state

## 1.0.18 - 2025-02-19

- Fixed multiple redirects

## 1.0.19 - 2025-02-19

- Remove double sync of cookies

## 1.0.20 - 2025-02-19

- Added webview support for kyc

## 1.0.21 - 2025-02-20

- Fixed camera and microphone permission issue in webview for ios

## 1.0.22 - 2025-02-24

- Added download functionality in webview 

## 1.0.23 - 2025-02-24

- Added force clear session functionality

## 1.0.24 - 2025-02-26

- Added iOsBrowserRedirectDomains in webview

## 1.1.0 - 2025-02-27

- Added cookie handling in webview
- Added cookie sync functionality
- Added fixes for webview

## 1.1.1 - 2025-02-27

- Added custom toast message

## 1.1.2 - 2025-03-01

- Fixed Intent Handling issues

## 1.1.3 - 2025-03-03

- Fixed user agent issue
- Fixed deep link logic

## 1.1.4 - 2025-03-03

- Minor changes

## 1.1.5 - 2025-03-04

- Dynamic user agent handling

## 1.1.6 - 2025-03-04

- Fixed the error message

## 1.1.7 - 2025-03-04

- Added loader callback

## 1.1.8 - 2025-03-06

- Whitelisted URLs added

## 1.1.9 - 2025-03-06

- Fixed the unnecessary permissions issue

## 1.1.10 - 2025-03-06

- Removed permissions from iOS webview

## 1.1.11 - 2025-03-07

- Fixed keyboard layout issue in iOS

## 1.1.12 - 2025-03-07

- Added callback in dispose function

## 1.1.13 -2025-03-12

- Minor change for keyboard layout

## 1.1.14 -2025-04-07

- Configuration testing

## 1.1.15 -2025-04-09

- Email url open fix

## 1.1.161 -2025-04-15

- AppBoundDomains fix

## 1.1.162 -2025-04-15

- UI fix

## 1.1.163 -2025-04-17

- Used fork webview package