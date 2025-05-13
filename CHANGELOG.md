## 11.2.0

* Remove `DecoratorPendantVisibilityMode` from `DecoratorPendant`, please use `needEditing` and
  `needFocus`
* `BoxDecorative()` removes `focusedBorderSide` and `crossAxisAlignment`
* Changed the `decoration` of `BoxDecorative()` to callback mode

## 11.0.2

* Removed `CheckBox`, `FlBadge`,`FlPopupMenuButton`,`FlSwiper`, `FlSwiperPagination`,
  `FlSwiperIndicator`,
* Removed `CarouselSlider`,added  `FlPageViewTransform`,`FlPageView`

## 10.0.1

* `AutomaticKeepAliveWrapperState` renamed to `AutomaticKeepAliveClientMixinState`
* `AutomaticKeepAliveWrapper` renamed to `AutomaticKeepAliveClientWrapper`

## 10.0.0

* Migrate to 3.27.0

## 9.10.1

* Remove `CounterAnimation`, add `AnimationCounter.down()`、`AnimationCounter.up()`
* Remove `CountDown`, add `Counter.down()`、`Counter.up()`

## 9.9.0

* Changed `FlProgress` to `FlLinearProgress` and made modifications to the parameters

## 9.8.0

* Add some callbacks for `CountDown()` and remove `CountDownType` enumeration
* Add `onStartTiming` `onStarts` `onEnds` callback method for `CountDown()`
* Change the `onTap` of `SendVerificationCode()` to `onSendTap`
* Change the `onStateChanged` of `SendVerificationCode()` to `onChanged`

## 9.7.1

* Modify `DecoratorEntry` to `DecoratorPendant`,and adds the `maintainSize` property to determine
  whether to maintain the size
* Modify `DecoratorPositioned` to `DecoratorPendantPosition`
* Added `BoxDecorative` to `DecoratorBox` and `DecoratorBoxState`
* Modify `.toDecoratorEntry()` to `.toDecoratorPendant()`
* Remove the `needKeyBoard` and `focusNode` from `PINTextField`
* Change the `controller` of `PINTextField` to mandatory
* Hide `contextMenuBuilder` and `enableInteractiveSelection` for `PINTextField`
* Modify some parameters of `ExpansionTiles` `PopupMenuButtonRotateBuilder` `ToggleRotate`, please
  refer to Example

## 9.6.0

* Remove the `DropdownMenusButton` component, please use the `MultiPopupMenuButton` component
* Remove the `DropdownMenuButton` component, please use the `PopupMenuButtonRotateBuilder` component

## 9.5.2

* export `SystemUiOverlayStyleLight`、`SystemUiOverlayStyleDark`

## 9.5.1

* Removed `fl_extended`

## 9.3.1

* Change the `SendSMS` to `SendVerificationCode`
* Change the `PinBox` to `PINTextField`
* Change the `PinTextFieldBuilderConfig` to `PINTextFieldBuilderConfig`

## 9.1.4

* Removed `AnchorScrollBuilder`
* Add `Shimmery`

## 9.1.3

* Add `FlipCardController` to `FlipCard()`

## 9.1.2

* Fixed conflicts between `DropdownMenusButton` and official packages

## 9.1.1

* Refactor the `DropdownMenuButton` and `DropdownMenusButton`

## 9.0.1

* Split core extension to [fl_extended](https://pub.dev/packages/fl_extended) package
* Modify all `GlobalWayUI()` to `FlExtended()`
