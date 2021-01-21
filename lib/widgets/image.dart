import 'dart:typed_data';
import 'dart:ui' as ui show Codec;
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef ImageSequenceProcessCallback = void Function(
    ImageSequenceState _imageSequenceAnimator);

class ImageSequence extends StatefulWidget {
  const ImageSequence(
    this.folderName,
    this.fileName,
    this.suffixStart,
    this.suffixCount,
    this.fileFormat,
    this.frameCount, {
    Key key,
    this.fps = 60,
    this.isLooping = false,
    this.isBoomerang = false,
    this.isAutoPlay = true,
    this.color = Colors.white,
    this.onReadyToPlay,
    this.onStartPlaying,
    this.onPlaying,
    this.onFinishPlaying,
  }) : super(key: key);

  final String folderName;

  ///  The file name for each image in your image sequence excluding the suffix. For example, if the images in your image sequence are named as
  ///  'Frame_00000.png', 'Frame_00001.png', 'Frame_00002.png', 'Frame_00003.png' ...
  ///  then the [fileName] should be 'Frame_'. This should be the same for all the images in your image sequence.
  final String fileName;

  ///  The suffix for the first image in your image sequence. For example, if the first image in your image sequence is named as
  ///  'Frame_00001.png'
  ///  then [suffixStart] should be 1.
  final int suffixStart;

  ///  The suffix length for each image in your image sequence. Most software such as Adobe After Effects export image sequences with a suffix. For
  ///  example, if the images in your image sequence are named as
  ///  'Frame_00000.png', 'Frame_00001.png', 'Frame_00002.png', 'Frame_00003.png' ...
  ///  then the [suffixCount] should be 5. This should be the same for all the images in your image sequence.
  final int suffixCount;

  ///  The file format for each image in your image sequence. For example, if the images in your image sequence are named as
  ///  'Frame_00000.png', 'Frame_00001.png', 'Frame_00002.png', 'Frame_00003.png' ...
  ///  then the [fileFormat] should be 'png'. This should be the same for all the images in your image sequence.
  final String fileFormat;

  ///  The total number of images in your image sequence.
  final double frameCount;

  ///  The FPS for your image sequence. For example, if your [frameCount] is 60 and the animation is meant to run in 1 second, then your [fps] should
  ///  be 60.
  final double fps;

  ///  Use this value to determine whether your image sequence should loop or not. This will override [isBoomerang] if both are set to true.
  final bool isLooping;

  ///  Use this value to determine whether your image sequence should boomerang or not.
  final bool isBoomerang;

  ///  Use this value to determine whether your image sequence should start playing immediately or not.
  final bool isAutoPlay;

  ///  Use this value to determine the color for your image sequence.
  final Color color;

  ///  The callback for when the [ImageSequenceState] is ready to start playing.
  final ImageSequenceProcessCallback onReadyToPlay;

  ///  The callback for when the [ImageSequenceState] starts playing.
  final ImageSequenceProcessCallback onStartPlaying;

  ///  The callback for when the [ImageSequenceState] is playing. This callback is continuously through the entire process.
  final ImageSequenceProcessCallback onPlaying;

  ///  The callback for when the [ImageSequenceState] finishes playing.
  final ImageSequenceProcessCallback onFinishPlaying;

  @override
  ImageSequenceState createState() => ImageSequenceState();
}

class ImageSequenceState extends State<ImageSequence>
    with SingleTickerProviderStateMixin {
  String folderName;
  String fileName;
  int suffixStart;
  int suffixCount;

  double frameCount;
  double fps;
  bool isAutoPlay;
  ImageSequenceProcessCallback onReadyToPlay;
  ImageSequenceProcessCallback onStartPlaying;
  ImageSequenceProcessCallback onPlaying;
  ImageSequenceProcessCallback onFinishPlaying;

  String fileFormat;

  int get fpsInMilliseconds => (1.0 / fps * 1000.0).floor();
  bool isLooping;
  bool isBoomerang;

  Color color;
  bool colorChanged = false;

  ///  The [AnimationController] used to control the image sequence.
  AnimationController animationController;
  final ValueNotifier<int> changeNotifier = ValueNotifier<int>(0);
  int previousFrame = 0;
  Image currentFrame;

  ///  Use this value to get the total time of the animation in milliseconds.
  double get totalTime => animationController.upperBound * fpsInMilliseconds;

  ///  Use this value to get the current time of the animation in milliseconds.
  double get currentTime => animationController.value * fpsInMilliseconds;

  void animationListener() {
    changeNotifier.value++;
    if (onPlaying != null) onPlaying(this);
  }

  void animationStatusListener(AnimationStatus animationStatus) {
    switch (animationStatus) {
      case AnimationStatus.completed:
        if (onFinishPlaying != null) onFinishPlaying(this);
        if (isLooping) restart();
        if (isBoomerang) rewind();
        break;
      case AnimationStatus.dismissed:
        if (onFinishPlaying != null) onFinishPlaying(this);
        if (isLooping || isBoomerang) play();
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    folderName = widget.folderName;
    fileName = widget.fileName;
    suffixStart = widget.suffixStart;
    suffixCount = widget.suffixCount;
    frameCount = widget.frameCount;
    fps = widget.fps;
    isAutoPlay = widget.isAutoPlay;
    onReadyToPlay = widget.onReadyToPlay;
    onStartPlaying = widget.onStartPlaying;
    onPlaying = widget.onPlaying;
    onFinishPlaying = widget.onFinishPlaying;
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: frameCount,
        duration: Duration(milliseconds: frameCount.ceil() * fpsInMilliseconds))
      ..addListener(animationListener)
      ..addStatusListener(animationStatusListener);
    if (isLooping) isBoomerang = false;
    if (fileFormat.startsWith('.')) fileFormat = fileFormat.substring(1);
    if (onReadyToPlay != null) onReadyToPlay(this);
    if (isAutoPlay) play();
  }

  @override
  void dispose() {
    reset();
    animationController.removeListener(animationListener);
    animationController.removeStatusListener(animationStatusListener);
    animationController.dispose();
    super.dispose();
  }

  ///  Use this function to set the value for [ImageSequence.isLooping] at runtime.
  void setIsLooping(bool isLooping) {
    this.isLooping = isLooping;
    if (this.isLooping) {
      isBoomerang = false;
      if (!animationController.isAnimating) restart();
    }
  }

  ///  Use this function to set the value for [ImageSequence.isBoomerang] at runtime.
  void setIsBoomerang(bool isBoomerang) {
    this.isBoomerang = isBoomerang;
    if (this.isBoomerang) {
      isLooping = false;
      if (!animationController.isAnimating) restart();
    }
  }

  ///  Use this function to set the value for [ImageSequence.color] at runtime.
  void changeColor(Color color) {
    this.color = color;
    colorChanged = true;
    changeNotifier.value++;
  }

  void play({double from = -1.0}) {
    if (!animationController.isAnimating && onStartPlaying != null)
      onStartPlaying(this);
    if (from == -1.0)
      animationController.forward();
    else
      animationController.forward(from: from);
  }

  void rewind({double from = -1.0}) {
    if (!animationController.isAnimating && onStartPlaying != null)
      onStartPlaying(this);
    if (from == -1.0)
      animationController.reverse();
    else
      animationController.reverse(from: from);
  }

  void pause() => animationController.stop();

  ///  Only use either value or percentage.
  void skip(double value, {double percentage = -1.0}) {
    if (percentage != -1.0)
      animationController.value = totalTime * percentage;
    else
      animationController.value = value;
  }

  void restart() {
    stop();
    play();
  }

  void stop() => reset();

  void reset() {
    animationController.value = 0;
    animationController.stop(canceled: true);
    previousFrame = 0;
    currentFrame = null;
  }

  String getSuffix(String value) {
    while (value.length < suffixCount) value = '0' + value;
    return value;
  }

  String getDirectory() =>
      folderName +
      '/' +
      fileName +
      getSuffix((suffixStart + previousFrame).toString()) +
      '.' +
      fileFormat;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        builder: (BuildContext context, int change, Widget cachedChild) {
          if (currentFrame == null ||
              animationController.value.floor() != previousFrame ||
              colorChanged) {
            colorChanged = false;
            previousFrame = animationController.value.floor();
            if (previousFrame < frameCount)
              currentFrame = Image.asset(getDirectory(),
                  color: color, gaplessPlayback: true);
          }
          return currentFrame;
        },
        valueListenable: changeNotifier);
  }
}

///  cache gif fetched image
class GifCache {
  final Map<String, List<ImageInfo>> caches = <String, List<ImageInfo>>{};

  void clear() => caches.clear();

  bool evict(Object key) {
    final List<ImageInfo> pendingImage = caches.remove(key);
    if (pendingImage != null) return true;
    return false;
  }
}

///  Controller gif
class GifController extends AnimationController {
  GifController(
      {@required TickerProvider vsync,
      double value = 0.0,
      Duration reverseDuration,
      Duration duration,
      AnimationBehavior animationBehavior})
      : super.unbounded(
            value: value,
            reverseDuration: reverseDuration,
            duration: duration,
            animationBehavior: animationBehavior ?? AnimationBehavior.normal,
            vsync: vsync);

  @override
  void reset() => value = 0.0;
}

class GifImage extends StatefulWidget {
  const GifImage({
    @required this.image,
    @required this.controller,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.onFetchCompleted,
    this.color,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gapLessPlayback = false,
  });

  final VoidCallback onFetchCompleted;
  final GifController controller;
  final ImageProvider image;
  final double width;
  final double height;
  final Color color;
  final BlendMode colorBlendMode;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect centerSlice;
  final bool matchTextDirection;
  final bool gapLessPlayback;
  final String semanticLabel;
  final bool excludeFromSemantics;

  @override
  _GifImageState createState() => _GifImageState();

  static GifCache cache = GifCache();
}

class _GifImageState extends State<GifImage> {
  List<ImageInfo> _images;
  int _curIndex = 0;
  bool _fetchComplete = false;

  ImageInfo get _imageInfo {
    if (!_fetchComplete) return null;
    return _images == null ? null : _images[_curIndex];
  }

  @override
  void initState() {
    super.initState();
    widget?.controller?.addListener(_listener);
  }

  @override
  void dispose() {
    widget?.controller?.removeListener(_listener);
    super.dispose();
  }

  @override
  void didUpdateWidget(GifImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _fetchGif(widget.image).then((List<ImageInfo> imageInfo) {
        if (imageInfo == null) return;
        if (mounted) {
          _images = imageInfo;
          _fetchComplete = true;
          _curIndex = widget.controller.value.toInt();
          if (widget.onFetchCompleted != null) widget.onFetchCompleted();
          setState(() {});
        }
      });
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_listener);
      widget.controller.addListener(_listener);
    }
  }

  void _listener() {
    if (_curIndex != widget.controller.value && _fetchComplete && mounted) {
      _curIndex = widget.controller.value.toInt();
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_images == null) {
      _fetchGif(widget.image).then((List<ImageInfo> imageInfo) {
        if (imageInfo == null) return;
        if (mounted) {
          _images = imageInfo;
          _fetchComplete = true;
          _curIndex = widget.controller.value.toInt();
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final RawImage image = RawImage(
        image: _imageInfo?.image,
        width: widget.width,
        height: widget.height,
        scale: _imageInfo?.scale ?? 1.0,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
        fit: widget.fit,
        alignment: widget.alignment,
        repeat: widget.repeat,
        centerSlice: widget.centerSlice,
        matchTextDirection: widget.matchTextDirection);
    if (widget.excludeFromSemantics) return image;
    return Semantics(
        container: widget.semanticLabel != null,
        image: true,
        label: widget.semanticLabel ?? '',
        child: image);
  }

  Future<List<ImageInfo>> _fetchGif(ImageProvider provider) async {
    List<ImageInfo> images = <ImageInfo>[];
    dynamic data;
    final String key = provider is NetworkImage
        ? provider.url
        : provider is AssetImage
            ? provider.assetName
            : provider is MemoryImage
                ? provider.bytes.toString()
                : '';
    if (GifImage.cache.caches.containsKey(key)) {
      images = GifImage.cache.caches[key];
      return images;
    }
    if (provider is NetworkImage) {
      final BaseOptions options = BaseOptions(responseType: ResponseType.bytes);
      provider.headers?.forEach((String name, String value) =>
          options.headers.addAll(<String, String>{name: value}));
      final ResponseModel result =
          await DioTools.getInstance(options: options).getHttp(provider.url);
      if (result?.statusCode != 200) {
        showToast(result?.statusMessage);
        return null;
      }
      data = result.data as Uint8List;
    } else if (provider is AssetImage) {
      final AssetBundleImageKey key =
          await provider.obtainKey(const ImageConfiguration());
      data = await key.bundle.load(key.name);
    } else if (provider is FileImage) {
      data = await provider.file.readAsBytes();
    } else if (provider is MemoryImage) {
      data = provider.bytes;
    }
    final ui.Codec codec = await PaintingBinding.instance
        .instantiateImageCodec(data.buffer.asUint8List() as Uint8List);
    images = <ImageInfo>[];
    for (int i = 0; i < codec.frameCount; i++) {
      final FrameInfo frameInfo = await codec.getNextFrame();
      images.add(ImageInfo(image: frameInfo.image));
    }
    GifImage.cache.caches.putIfAbsent(key, () => images);
    return images;
  }
}
