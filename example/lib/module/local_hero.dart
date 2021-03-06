import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class LocalHeroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('JsonParse Demo'), centerTitle: true),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          customElasticButton('TestOne', onTap: () => push(const _TestOne())),
          customElasticButton('LocalHero',
              onTap: () => push(const _LocalHero())),
          customElasticButton('LocalHeroPlayground.list',
              onTap: () => push(const _LocalHeroPlayground())),
        ]);
  }
}

class _LocalHero extends StatefulWidget {
  const _LocalHero({
    Key? key,
  }) : super(key: key);

  @override
  _LocalHeroState createState() => _LocalHeroState();
}

class _LocalHeroState extends State<_LocalHero> {
  AlignmentGeometry alignment = Alignment.topLeft;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        appBar: AppBar(title: BasisText('LocalHero')),
        body: Column(children: <Widget>[
          Container(
                  padding: const EdgeInsets.all(8),
                  alignment: alignment,
                  child: LocalHero(
                      tag: 'id',
                      child:
                          Container(color: Colors.red, width: 50, height: 50)))
              .expandedNull,
          ElevatedButton(
              onPressed: () {
                alignment = alignment == Alignment.topLeft
                    ? Alignment.bottomRight
                    : Alignment.topLeft;
                setState(() {});
              },
              child: const Text('Move')),
        ]));
  }
}

class _LocalHeroPlayground extends StatelessWidget {
  const _LocalHeroPlayground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocalHeroScope(
        duration: const Duration(milliseconds: 500),
        createRectTween: (Rect? begin, Rect? end) =>
            RectTween(begin: begin!, end: end!),
        curve: Curves.easeInOut,
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                  title: const TabBar(tabs: <Widget>[
                Text('Animate wrap reordering'),
                Text('Move between containers'),
                Text('Draggable content'),
              ])),
              body: const TabBarView(children: <Widget>[
                _WrapReorderingAnimation(),
                _AcrossContainersAnimation(),
                _DraggableExample(),
              ]),
            )));
  }
}

class _TileModel extends Equatable {
  const _TileModel({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  List<Object> get props => <Object>[color, text];

  @override
  String toString() => text;
}

class _Tile extends StatelessWidget {
  const _Tile({
    Key? key,
    required this.model,
    required this.size,
    this.onTap,
  }) : super(key: key);

  final _TileModel model;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) => LocalHero(
      tag: model.text,
      child: GestureDetector(
          onTap: onTap, child: _RawTile(model: model, size: size)));
}

class _RawTile extends StatelessWidget {
  const _RawTile({
    Key? key,
    required this.model,
    required this.size,
  }) : super(key: key);

  final _TileModel model;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
      color: model.color,
      height: size,
      width: size,
      padding: const EdgeInsets.all(16),
      child: CircleAvatar(
          backgroundColor: Colors.white70,
          foregroundColor: Colors.black54,
          child: Text(model.text)));
}

class _WrapReorderingAnimation extends StatefulWidget {
  const _WrapReorderingAnimation({Key? key}) : super(key: key);

  @override
  _WrapReorderingAnimationState createState() =>
      _WrapReorderingAnimationState();
}

class _WrapReorderingAnimationState extends State<_WrapReorderingAnimation> {
  final List<_TileModel> tiles = <_TileModel>[];
  double spacing = 10;
  double runSpacing = 10;

  @override
  void initState() {
    super.initState();
    final List<MaterialColor> colors = Colors.primaries;
    for (int i = 0; i < colors.length; i++) {
      tiles.add(_TileModel(color: colors[i], text: '$i'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Universal(
          expanded: true,
          padding: const EdgeInsets.all(4),
          child: _LocalHeroOverlay(
              child: Wrap(
            alignment: WrapAlignment.start,
            spacing: spacing,
            runSpacing: runSpacing,
            children: tiles.builder((_TileModel tile) => _Tile(
                  key: ValueKey<dynamic>(tile),
                  size: 80,
                  model: tile,
                  onTap: () {
                    final int index = tiles.indexOf(tile);
                    final int swappedIndex = (index + 5) % tiles.length;
                    tiles[index] = tiles[swappedIndex];
                    tiles[swappedIndex] = tile;
                    setState(() {});
                  },
                )),
          ).center())),
      Slider(
          max: 30,
          divisions: 3,
          value: spacing,
          onChanged: (double value) => setState(() => spacing = value)),
      Slider(
          max: 30,
          divisions: 3,
          value: runSpacing,
          onChanged: (double value) => setState(() => runSpacing = value))
    ]);
  }
}

class _AcrossContainersAnimation extends StatefulWidget {
  const _AcrossContainersAnimation({Key? key}) : super(key: key);

  @override
  _AcrossContainersAnimationState createState() =>
      _AcrossContainersAnimationState();
}

class _AcrossContainersAnimationState
    extends State<_AcrossContainersAnimation> {
  final List<_TileModel> rowTiles = <_TileModel>[];
  final List<_TileModel> colTiles = <_TileModel>[];

  @override
  void initState() {
    super.initState();
    final List<MaterialColor> primaries = Colors.primaries;
    for (int i = 0; i < 5; i++) {
      final _TileModel tile = _TileModel(color: primaries[i], text: 'p$i');
      rowTiles.add(tile);
    }
    final List<MaterialAccentColor> accents = Colors.accents;
    for (int i = 0; i < 5; i++) {
      final _TileModel tile = _TileModel(color: accents[i], text: 'a$i');
      colTiles.add(tile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Universal(
          padding: const EdgeInsets.all(4),
          direction: Axis.horizontal,
          children: rowTiles.builder((_TileModel tile) => _Tile(
                key: ValueKey<dynamic>(tile),
                model: tile,
                size: 80,
                onTap: () {
                  colTiles.add(tile);
                  rowTiles.remove(tile);
                  setState(() {});
                },
              ))),
      const SizedBox(height: 10),
      Universal(
          expanded: true,
          children: colTiles.builder((_TileModel tile) => _Tile(
                key: ValueKey<dynamic>(tile),
                model: tile,
                size: 60,
                onTap: () {
                  rowTiles.add(tile);
                  colTiles.remove(tile);
                  setState(() {});
                },
              )))
    ]);
  }
}

class _DraggableExample extends StatefulWidget {
  const _DraggableExample({
    Key? key,
  }) : super(key: key);

  @override
  _DraggableExampleState createState() => _DraggableExampleState();
}

class _DraggableExampleState extends State<_DraggableExample> {
  final List<_TileModel> tiles = <_TileModel>[];

  @override
  void initState() {
    super.initState();
    final List<MaterialColor> colors = Colors.primaries;
    for (int i = 0; i < colors.length; i++) {
      tiles.add(_TileModel(color: colors[i], text: 'd$i'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: tiles.builder((_TileModel tile) => DragTarget<_TileModel>(
              key: ValueKey<dynamic>(tile),
              onWillAccept: (_TileModel? data) {
                final bool accept = data != tile;
                if (accept) onDrag(data!, tile);
                return accept;
              },
              builder: (__, List<_TileModel?> candidateData, _) =>
                  _DraggableTile(model: tile),
            ))).center();
  }

  void onDrag(_TileModel source, _TileModel target) {
    final int index = tiles.indexOf(target);
    tiles.remove(source);
    tiles.insert(index, source);
    setState(() {});
  }
}

class _DraggableTile extends StatefulWidget {
  _DraggableTile({
    Key? key,
    required this.model,
  })   : child = _RawTile(model: model, size: 80),
        super(key: key);

  final _TileModel model;
  final Widget child;

  @override
  _DraggableTileState createState() => _DraggableTileState();
}

class _DraggableTileState extends State<_DraggableTile> {
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return Draggable<_TileModel>(
        onDragStarted: () {
          dragging = true;
        },
        onDragEnd: (DraggableDetails details) {
          dragging = false;
        },
        data: widget.model,
        feedback: widget.child,
        childWhenDragging: Container(width: 80, height: 80),
        child: LocalHero(
            tag: widget.model, enabled: !dragging, child: widget.child));
  }
}

class _LocalHeroOverlay extends StatefulWidget {
  const _LocalHeroOverlay({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _LocalHeroOverlayState createState() => _LocalHeroOverlayState();
}

class _LocalHeroOverlayState extends State<_LocalHeroOverlay> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
        child: Overlay(initialEntries: <OverlayEntry>[
      OverlayEntry(builder: (BuildContext context) => widget.child),
    ]));
  }
}

class _TestOne extends StatefulWidget {
  const _TestOne({Key? key}) : super(key: key);

  @override
  _TestOneState createState() => _TestOneState();
}

class _TestOneState extends State<_TestOne> {
  final List<Widget> children = <Widget>[
    LocalHero(
        tag: 0,
        key: const ValueKey<dynamic>(0),
        child: Container(height: 20, width: 20, color: Colors.green)),
    LocalHero(
        tag: 1,
        key: const ValueKey<int>(1),
        child: Container(height: 40, width: 40, color: Colors.yellow)),
    LocalHero(
        tag: 2,
        key: const ValueKey<int>(2),
        child: Container(height: 60, width: 60, color: Colors.red))
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ...children,
      TextButton(
          onPressed: () {
            children.shuffle();
            setState(() {});
          },
          child: const Text('shuffle')),
    ]);
  }
}
