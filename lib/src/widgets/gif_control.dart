import 'dart:typed_data';
import 'dart:ui' as ui show Codec;
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// cache gif fetched image
class GifCache {
  final Map<String, List<ImageInfo>> caches = <String, List<ImageInfo>>{};

  void clear() => caches.clear();

  bool evict(Object key) {
    final List<ImageInfo> pendingImage = caches.remove(key);
    if (pendingImage != null) return true;
    return false;
  }
}

/// Controller gif
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
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_listener);
  }

  @override
  void didUpdateWidget(GifImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _fetchGif(widget.image).then((List<ImageInfo> imageInfo) {
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
        container: widget.semanticLabel != null, image: true, label: widget.semanticLabel ?? '', child: image);
  }
}

Future<List<ImageInfo>> _fetchGif(ImageProvider provider) async {
  List<ImageInfo> images = <ImageInfo>[];
  dynamic data;
  final String key = provider is NetworkImage
      ? provider.url
      : provider is AssetImage ? provider.assetName : provider is MemoryImage ? provider.bytes.toString() : '';
  if (GifImage.cache.caches.containsKey(key)) {
    images = GifImage.cache.caches[key];
    return images;
  }
  if (provider is NetworkImage) {
    final BaseOptions options = BaseOptions(responseType: ResponseType.bytes);
    provider.headers?.forEach((String name, String value) => options.headers.addAll(<String, String>{name: value}));
    final ResponseModel result = await DioTools.getInstance(options: options).getHttp(provider.url);
    data = result.data as Uint8List;
  } else if (provider is AssetImage) {
    final AssetBundleImageKey key = await provider.obtainKey(const ImageConfiguration());
    data = await key.bundle.load(key.name);
  } else if (provider is FileImage) {
    data = await provider.file.readAsBytes();
  } else if (provider is MemoryImage) {
    data = provider.bytes;
  }
  final ui.Codec codec = await PaintingBinding.instance.instantiateImageCodec(data.buffer.asUint8List() as Uint8List);
  images = <ImageInfo>[];
  for (int i = 0; i < codec.frameCount; i++) {
    final FrameInfo frameInfo = await codec.getNextFrame();
    images.add(ImageInfo(image: frameInfo.image));
  }
  GifImage.cache.caches.putIfAbsent(key, () => images);
  return images;
}
