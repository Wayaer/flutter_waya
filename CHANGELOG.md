## 1.11.7
  * fix buf for `Progress`
## 1.11.6
  * fix bug for `DateTimePicker`
  * `PinBox` add `spaces`,and remove `width` `boxSpacing`
## 1.11.3
  * fix some bug
## 1.11.2
  * DioTools add `useLog`
  * add `ExtensionFunction` including debounce function and throttle function
## 1.11.1
  * remove `DottedLine`
  * add `DottedLinePainter`
## 1.11.0
  * change `PopupBase` to `PopupOptions` 
  * change `GlobalWidgetsApp` to `ExtendedWidgetsApp` 
  * change `OverlayScaffold` to `ExtendedScaffold` 
  * change `SliverAutoAppBar` to `ExtendedSliverAppBar` 
  * change `PickerSub` to `PickerOptions` and change pickerSub to options
  , change pickerWheel to wheel
  * change `FlexibleSpaceAutoBar` to `ExtendedFlexibleSpaceBar` 
  * change `SliverAutoPersistentHeader` to `ExtendedSliverPersistentHeader` 
  * change `ScrollViewAuto` to `ExtendedScrollView` 
  * change `OverlayEntryAuto` to `ExtendedOverlayEntry` 
  * add `onDispose` and `onUpdate` on `ValueListenBuilder`
  * add `didUpdateWidget` on `ValueBuilder`
## 1.10.5
  * change `RichTextSpan` to `RText`
  * change `BasisText` to `BText`
  * change `BasisTextStyle` to `BTextStyle`
  * remove `InputField`
  * add `WidgetPendant` for all widgets, add header, footer, extraPrefix
  , extraSuffix, prefix, suffix. you can use it with `CupertinoTextField` or `TextField`
  * add `inputTextTypeToTextInputFormatter()`  
## 1.10.3
  * optimize import
  * `OverlayEntryAuto` add `removeEntry()`,When autoOff is true, the `ExtendedScaffold` call `onWillPop` will filter the
   `OverlayEntryAuto`
## 1.10.1
  * fix the `remove` error of `Eventbus` when the project supports null-safety
## 1.10.0
  * optimize the return data of network request error
  * fix the cancel network request bug and return the error message
## 1.9.17
  * fix `PinBox` bugs
  * showToast add `ignoring`
  * add `setAllToastIgnoringBackground()`,if it is true, the background
   responds to the click event
## 1.9.15
  * `PopupOptions` add onWillPop and filter for `WillPopScope` And `BackdropFilter`
## 1.9.13
  * `Universal` add useSingleChildScrollView property，The default is true, If
   useSingleChildScrollView is false, the scrolling component will be created using `Scrollview`
  * `Universal` add `Wrap`,
  * `Universal` adds `StatefulBuilder`、`Builder` and `LayoutBuilder`，and uses them through builder properties
  * fix bugs for `TabBarMerge`
  * fix `ListWheel` controller auto destroy problem
## 1.9.12
  * fix bug for popBack
  * logTools add `RequestOptions`
  * add example for `ScrollViewAuto.nested`
## 1.9.11
  * `Universal` add `ImageFilter`
  * split `ScrollList`
  * add `RefreshScrollView`
  * add `SliverListGrid`
## 1.9.10
  * add `ValueListenBuilder` and Example
  * `ValueBuilder` add BuildContext for builder and add Example
  * `ScrollList` add `Header` and `Footer`
## 1.9.9
  * fix bug
## 1.9.7
  * Modify the method of obtaining the OverlayState
## 1.9.6
  * add `EasyRefreshType`
## 1.9.5
  * fix bugs 
  * add doc
## 1.9.3
  * fix bugs for `des`
## 1.9.2
  * change `HintDot` to `Badge` 
  * add `DropdownMenuButton.material`
## 1.9.1
  * remove `DropdownMenuButton` constraints.
## 1.9.0
  * update `dio` to 4.0.0
  * fix bugs
## 1.8.7
  * add `DropdownMenuButton`
  * add example
  * add scaffoldMessengerKey for `MaterialApp`
  * add showSnackBar
## 1.8.6
  * optimization is not an `http-200` state return parameter
## 1.8.5
  * Repair `ScrollList.separated` bug
## 1.8.3
  * global optimization refresh
## 1.8.0
  * Replace refresh component
## 1.7.5
  * add ExpansionTiles example and fix bug
## 1.7.2
  * update flutter 2.0
## 1.6.0
  * add `Progress.circular` `Progress.linear`
  * ExtensionString add insert void
  * add `BasisText`  `BasisTextStyle` 
  * modify `RichSpan` to `RichTextSpan`
  * modify `sendMessage(RefreshCompletedType.refresh)` to `sendRefreshType(RefreshCompletedType.refresh)`
  * remove Ts 
  * remove `Carousel.pageView`
  * showToast add async callback
## 1.5.0
  * change Tools to Ts.
  * change GlobalMaterial to ExtendedWidgetsApp.
  * modify push and pop
  * add Universal tagging
  * fix ExtendedWidgetsApp did not return MaterialApp
  * modify styles.dart
  * Universal add Refreshed
  * add des encode and decode
  * remove `NestedScroll`
  * add `ScrollViewAuto` `SliverAutoPersistentHeader` `SliverAutoAppBar`
  * Universal add`StatefulWidgetBuilder` `SizedBox`
  * picker add `PickerTitle` `PickerWheel`
  * DateTimePicker add Start end range
  * add ScrollConfiguration
  * add extension
  * `push` `pushReplacement` `pushAndRemoveUntil`remove widget , push(Widget())
## 1.3.10
  * fix `ListWheel` The method 'call' was called on null.
  * remove `ListWheel` dispose().
## 1.3.9
  * remove Overflow for Universal
## 1.3.7
  * simplifying some component parameters 【PopupSureCancel，PopupOptions】
  * modify utils partial method name
## 1.3.3
  * add showCupertinoBottomPagePopup
## 1.3.2
  * remove some widget
  * format code
## 1.2.1
 * Refactoring all file names and classes
 * Optimize overlay `toast loading`
 * The pop method moves out of the context parameter.
 * Change of route jump can directly call `push() pushReplacement() pushAndRemoveUntil() pop()`.
## 1.1.1
 * Optimization class file
## 1.1.0
 * Split some tool classes
 * Add some components `GifControl` `DropdownMenu` `Universal`
## 1.0.4
 * Split TabBarWidget
 * Optimize part of the code
 * New components
## 1.0.3
 * Optimize time selector (simplified parameter)
 * Optimize overlay stack
 * To fix the problem that overlay cannot be closed by clicking the return button (overlay scaffold is required)
 * Add hero component
## 1.0.2
 * Fix download upload method catch exception failed to return
## 1.0.0
 * Release of official version
## 0.0.1
 *  create lib