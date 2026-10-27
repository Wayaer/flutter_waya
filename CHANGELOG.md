## 12.0.0

### Breaking changes

* Require Flutter 3.47+ / Dart 3.13+
* Unify public API naming with the `Fl` prefix: all public classes, enums, typedefs and extensions are renamed (for example `Event` → `FlEvent`, `ScreenAdaptation` → `FlScreenAdaptation`, `XSwitch` → `FlSwitch`, `Counter` → `FlCounter`); global helpers are now `flSendEvent`, `flEventListen` and `flEventDestroy`
* Reorganize `lib/src` by responsibility: `core`, `animation`, `feedback`, `paging`, `input`, `display`, `timing`
* Remove the `ListEntry` component
* Remove the `TabBarMerge` component
* Remove the `FlTabBarBox` component
* Remove the `FlDraggableScrollbar` component
* Remove the `FlLiquidProgressIndicator` component
* Remove the `flGetBoxShadow` helper
* Remove `FlWrapper.just` and custom `spinePathBuilder` support; use `FlWrapper` with the new `spineRadius` parameter instead
* The example now targets Web and iOS only; the Android/macOS platform folders were removed
* `FlPageViewController` index conversion is now consistent for `initial != 0` and non-loop mode
* `FlCounter.stopTiming()` no longer triggers `onEnds`; only natural completion does
* `FlSwitch` drag threshold now uses the logical position instead of the curved visual value
* `FlRatingStars` clipping now follows `TextDirection` (RTL support)
* `FlScreenAdaptation` reads the nearest `MediaQuery` size, falling back to the window size
* `flEventListen()` now returns a cancellable `StreamSubscription`
* `FlEventBus.emit` now dispatches subscribers in subscription order instead of reverse order

### Added

* Chinese API documentation for public classes, fields and methods
* Regression tests covering lifecycle, animation, paging, input, display and event edge cases
* `FlIndicator.activeSize` now participates in active-dot rendering
* `FlShimmery` supports a custom number of gradient colors
* `FlPageView.stopAutoPlay()` is persistent; autoplay no longer resumes after manual navigation
* `FlLinearProgress` animation now respects the configured `curve`
* Non-loop autoplay wraps to the first page with `jumpToPage` instead of rewinding
* Example gallery rewritten with one page per component category and usage comments

### Fixed

* Core: `FlEvent.on<E>()` filters by `E`; `FlEvent.listen` returns a subscription; `flEventDestroy` can be reused; the `FlScreenAdaptation` builder receives the scope context; `FlEventBus.emit` is safe when callbacks remove other listeners; global `flEventListen` is cancellable
* Animation: `FlBubbleButton` and `FlElasticBuilder` no longer recreate controllers with `SingleTickerProviderStateMixin`; `FlBubbleButton` toggles by default; `FlExpansionTiles` no longer collapses on unrelated rebuilds or invokes callbacks during build, and its background color now wraps a transparent `Material` so `ListTile` background/ink stays visible; `FlAnimationCounter` merges back to a single text after the `part` animation; `FlFlipCard.hint` is dispose-safe and `onFlipEnd` only fires after a real flip; `FlFlipCardStateful` ignores taps during a running flip; `FlShimmerDirection.fromRBLT()` starts from the bottom-right corner; `FlToggleRotate` handles mid-animation direction changes; `FlMultiPopupMenuButton` rebuilds after selection; `FlAutoCollapsingBuilder` syncs its initial scroll offset; `FlAnimationWave` disposes listeners and guards unbounded sizes
* Paging: `FlPageView` index math for `initial`/non-loop mode; controller replacement and `hasClients` guards; autoplay interval changes and persistent stop; non-loop wrap; `getPage()`/autoplay guard against a null page; autoplay pauses while the app is in the background and resumes on return; autoplay no longer stops permanently after an interrupted animation or when `ScrollEndNotification` arrives before `UserScrollNotification`; `FlPageViewTransform` no longer requires a `PageStorage` ancestor; `FlIndicator.activeSize`, empty counts and negative progress; the indicator canvas now reserves room for a larger active dot (no clipping or overflow) and repaints when `activeSize` changes
* Feedback: `FlLinearProgress` controller creation, curve application, rebuild restarts and unbounded width; `FlShimmery` and `FlLinearProgress` reuse their controller when `enabled`/`animation` or `duration` changes instead of recreating a ticker; `FlLinearProgress.repeat` no longer spins when `percent` is 0; `FlShimmery` custom color counts, zero interval and duration/interval updates
* Input: `FlPINTextField` whitespace handling, grapheme splitting, `onDone`, `obscureText`, controller changes and bounded width inside unbounded rows; `FlNumberLimitFormatter` anchoring and leading-dot rejection; `FlDecoratorBox` pendant rendering, unbounded width, hidden-pendant spacing, multiple-pendant spacing and `needFocus`/`needEditing`/`needValue` checks for builder pendants; `FlRatingStars` step clamping, RTL clipping and hit behavior; `FlSwitch` size constraints, drag threshold, thumb geometry and slow-drag release animation
* Display: `FlWrapper` top/left spines now attach to the body edge without a gap, and `spineRadius` smoothly rounds the tip and both junctions; `FlDottedLinePainter` edge inset, right border, first dash, negative-direction support, rounded corners, independent dash length and round stroke caps; `FlDottedLineBorder` inset and zero-length protection
* Timing: `FlCounter.stopTiming()` immediately rebuilds so `isRunning` reflects the stopped state
* Example: Flutter 3.47 Web/iOS platform templates, Chinese comments and categorized gallery; back navigation force-pops the page instead of looping between `PopScope` and `maybePop`
* Removed the unused `carousel/carousel_controller.dart` orphan file and the example dependency on `fl_extended`
