part of 'carousel_slider.dart';

enum CarouselPageChangedReason { timed, manual, controller }

enum CenterPageEnlargeStrategy { scale, height, zoom }

typedef CarouselPageChangedCallback = void Function(
    int index, CarouselPageChangedReason reason);

class CarouselSliderOptions {
  /// Set carousel height and overrides any existing [aspectRatio].
  final double? height;

  /// Aspect ratio is used if no height have been declared.
  ///
  /// Defaults to 16:9 aspect ratio.
  final double aspectRatio;

  /// The fraction of the viewport that each page should occupy.
  ///
  /// Defaults to 0.8, which means each page fills 80% of the carousel.
  final double viewportFraction;

  /// The initial page to show when first creating the [CarouselSlider].
  ///
  /// Defaults to 0.
  final int initialPage;

  ///Determines if carousel should loop infinitely or be limited to item length.
  ///
  ///Defaults to true, i.e. infinite loop.
  final bool enableInfiniteScroll;

  ///Determines if carousel should loop to the closest occurence of requested page.
  ///
  ///Defaults to true.
  final bool animateToClosest;

  /// Enables auto play, sliding one page at a time.
  ///
  /// Use [autoPlayInterval] to determent the frequency of slides.
  /// Defaults to false.
  final bool autoPlay;

  /// Sets Duration to determent the frequency of slides when
  ///
  /// [autoPlay] is set to true.
  /// Defaults to 4 seconds.
  final Duration autoPlayInterval;

  /// The animation duration between two transitioning pages while in auto playback.
  ///
  /// Defaults to 800 ms.
  final Duration autoPlayAnimationDuration;

  /// Determines the animation curve physics.
  ///
  /// Defaults to [Curves.fastOutSlowIn].
  final Curve autoPlayCurve;

  /// Determines if current page should be larger than the side images,
  /// creating a feeling of depth in the carousel.
  ///
  /// Defaults to false.
  final bool enlargeCenterPage;

  /// The axis along which the page view scrolls.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Called whenever the page in the center of the viewport changes.
  final CarouselPageChangedCallback? onPageChanged;

  /// Called whenever the carousel is scrolled
  final ValueChanged<double?>? onScrolled;

  /// If `true`, the auto play function will be paused when user is interacting with
  /// the carousel, and will be resumed when user finish interacting.
  /// Default to `true`.
  final bool pauseAutoPlayOnTouch;

  /// If `true`, the auto play function will be paused when user is calling
  /// pageController's `nextPage` or `previousPage` or `animateToPage` method.
  /// And after the animation complete, the auto play will be resumed.
  /// Default to `true`.
  final bool pauseAutoPlayOnManualNavigate;

  /// If `enableInfiniteScroll` is `false`, and `autoPlay` is `true`, this option
  /// decide the carousel should go to the first item when it reach the last item or not.
  /// If set to `true`, the auto play will be paused when it reach the last item.
  /// If set to `false`, the auto play function will animate to the first item when it was
  /// in the last item.
  final bool pauseAutoPlayInFiniteScroll;

  /// Use [enlargeStrategy] to determine which method to enlarge the center page.
  final CenterPageEnlargeStrategy enlargeStrategy;

  /// How much the pages next to the center page will be scaled down.
  /// If `enlargeCenterPage` is false, this property has no effect.
  final double enlargeFactor;

  /// Whether or not to disable the `Center` widget for each slide.
  final bool disableCenter;

  const CarouselSliderOptions({
    this.height,
    this.aspectRatio = 16 / 9,
    this.viewportFraction = 0.8,
    this.initialPage = 0,
    this.enableInfiniteScroll = true,
    this.animateToClosest = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.enlargeCenterPage = false,
    this.onPageChanged,
    this.onScrolled,
    this.scrollDirection = Axis.horizontal,
    this.pauseAutoPlayOnTouch = true,
    this.pauseAutoPlayOnManualNavigate = true,
    this.pauseAutoPlayInFiniteScroll = false,
    this.enlargeStrategy = CenterPageEnlargeStrategy.scale,
    this.enlargeFactor = 0.3,
    this.disableCenter = false,
  });
}

class CarouselState {
  /// The [CarouselSliderOptions] to create this state
  CarouselSliderOptions options;

  /// [pageController] is created using the properties passed to the constructor
  /// and can be used to control the [PageView] it is passed to.
  PageController? pageController;

  /// The actual index of the [PageView].
  ///
  /// This value can be ignored unless you know the carousel will be scrolled
  /// backwards more then 10000 pages.
  /// Defaults to 10000 to simulate infinite backwards scrolling.
  int realPage = 10000;

  /// The initial index of the [PageView] on [CarouselSlider] init.
  ///
  int initialPage = 0;

  /// The widgets count that should be shown at carousel
  int? itemCount;

  /// Will be called when using pageController to go to next page or
  /// previous page. It will clear the autoPlay timer.
  /// Internal use only
  Function onResetTimer;

  /// Will be called when using pageController to go to next page or
  /// previous page. It will restart the autoPlay timer.
  /// Internal use only
  Function onResumeTimer;

  /// The callback to set the Reason Carousel changed
  Function(CarouselPageChangedReason) changeMode;

  CarouselState(
      this.options, this.onResetTimer, this.onResumeTimer, this.changeMode);
}

class CarouselSliderController {
  CarouselState? _state;

  set state(CarouselState? state) {
    _state = state;
  }

  void _setModeController() =>
      _state!.changeMode(CarouselPageChangedReason.controller);

  /// Animates the controlled [CarouselSlider] to the next page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> nextPage(
      {Duration? duration = const Duration(milliseconds: 300),
      Curve? curve = Curves.linear}) async {
    final bool isNeedResetTimer = _state!.options.pauseAutoPlayOnManualNavigate;
    if (isNeedResetTimer) {
      _state!.onResetTimer();
    }
    _setModeController();
    await _state!.pageController!.nextPage(duration: duration!, curve: curve!);
    if (isNeedResetTimer) {
      _state!.onResumeTimer();
    }
  }

  /// Animates the controlled [CarouselSlider] to the previous page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> previousPage(
      {Duration? duration = const Duration(milliseconds: 300),
      Curve? curve = Curves.linear}) async {
    final bool isNeedResetTimer = _state!.options.pauseAutoPlayOnManualNavigate;
    if (isNeedResetTimer) {
      _state!.onResetTimer();
    }
    _setModeController();
    await _state!.pageController!
        .previousPage(duration: duration!, curve: curve!);
    if (isNeedResetTimer) {
      _state!.onResumeTimer();
    }
  }

  /// Changes which page is displayed in the controlled [CarouselSlider].
  ///
  /// Jumps the page position from its current value to the given value,
  /// without animation, and without checking if the new value is in range.
  void jumpToPage(int page) {
    final index = _getRealIndex(_state!.pageController!.page!.toInt(),
        _state!.realPage - _state!.initialPage, _state!.itemCount);

    _setModeController();
    final int pageToJump = _state!.pageController!.page!.toInt() + page - index;
    return _state!.pageController!.jumpToPage(pageToJump);
  }

  /// Animates the controlled [CarouselSlider] from the current page to the given page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> animateToPage(int page,
      {Duration? duration = const Duration(milliseconds: 300),
      Curve? curve = Curves.linear}) async {
    final bool isNeedResetTimer = _state!.options.pauseAutoPlayOnManualNavigate;
    if (isNeedResetTimer) {
      _state!.onResetTimer();
    }
    final index = _getRealIndex(_state!.pageController!.page!.toInt(),
        _state!.realPage - _state!.initialPage, _state!.itemCount);
    int smallestMovement = page - index;
    if (_state!.options.enableInfiniteScroll &&
        _state!.itemCount != null &&
        _state!.options.animateToClosest) {
      if ((page - index).abs() > (page + _state!.itemCount! - index).abs()) {
        smallestMovement = page + _state!.itemCount! - index;
      } else if ((page - index).abs() >
          (page - _state!.itemCount! - index).abs()) {
        smallestMovement = page - _state!.itemCount! - index;
      }
    }
    _setModeController();
    await _state!.pageController!.animateToPage(
        _state!.pageController!.page!.toInt() + smallestMovement,
        duration: duration!,
        curve: curve!);
    if (isNeedResetTimer) {
      _state!.onResumeTimer();
    }
  }

  /// Starts the controlled [CarouselSlider] autoplay.
  ///
  /// The carousel will only autoPlay if the [autoPlay] parameter
  /// in [CarouselSliderOptions] is true.
  void startAutoPlay() {
    _state!.onResumeTimer();
  }

  /// Stops the controlled [CarouselSlider] from autoplaying.
  ///
  /// This is a more on-demand way of doing this. Use the [autoPlay]
  /// parameter in [CarouselSliderOptions] to specify the autoPlay behaviour of the carousel.
  void stopAutoPlay() {
    _state!.onResetTimer();
  }
}

/// Converts an index of a set size to the corresponding index of a collection of another size
/// as if they were circular.
///
/// Takes a [position] from collection Foo, a [base] from where Foo's index originated
/// and the [length] of a second collection Baa, for which the correlating index is sought.
///
/// For example; We have a Carousel of 10000(simulating infinity) but only 6 images.
/// We need to repeat the images to give the illusion of a never ending stream.
/// By calling _getRealIndex with position and base we get an offset.
/// This offset modulo our length, 6, will return a number between 0 and 5, which represent the image
/// to be placed in the given position.
int _getRealIndex(int position, int base, int? length) {
  final int offset = position - base;
  return _remainder(offset, length);
}

/// Returns the remainder of the modulo operation [input] % [source], and adjust it for
/// negative values.
int _remainder(int input, int? source) {
  if (source == 0) return 0;
  final int result = input % source!;
  return result < 0 ? source + result : result;
}
