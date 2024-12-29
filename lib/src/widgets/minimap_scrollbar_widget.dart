import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../resources/minimap_image_painter.dart';

enum MinimapPosition { left, right, top, bottom }

class MinimapScrollbarWidget extends StatefulWidget {
  const MinimapScrollbarWidget({
    super.key,
    required this.child,
    this.miniSize = 100.0,
    this.scaleFactor = 0.1,
    this.highlightColor = Colors.blue,
    this.position = MinimapPosition.right,
  });

  final Widget child;
  final double miniSize;
  final double scaleFactor;
  final Color highlightColor;
  final MinimapPosition position;

  @override
  State<MinimapScrollbarWidget> createState() => _MinimapScrollbarWidgetState();
}

class _MinimapScrollbarWidgetState extends State<MinimapScrollbarWidget> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _childKey = GlobalKey();

  ui.Image? _miniImage;
  Timer? _imageUpdateTimer;
  late double assignedViewPortSize;

  bool get _isVertical =>
      widget.position == MinimapPosition.left ||
      widget.position == MinimapPosition.right;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateHighlight);
    WidgetsBinding.instance.addPostFrameCallback((_) => _captureMiniImage());

    _imageUpdateTimer = Timer.periodic(
      const Duration(microseconds: 100),
      (_) => setState(_captureMiniImage),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _imageUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MinimapScrollbarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _captureMiniImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _captureMiniImage();
  }

  void _updateHighlight() => setState(() {});

  void _captureMiniImage() {
    final boundary =
        _childKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary != null) {
      boundary.toImage(pixelRatio: widget.scaleFactor).then((image) {
        if (mounted) {
          setState(() => _miniImage = image);
        }
      });
    }
  }

  void _onMinimapInteraction(
    Offset localPosition,
    double miniContentSize,
  ) {
    if (!_scrollController.hasClients) return;

    final ratio = _isVertical
        ? localPosition.dy / miniContentSize
        : localPosition.dx / miniContentSize;

    final targetScroll = ratio * _scrollController.position.maxScrollExtent;

    _scrollController.jumpTo(
      targetScroll.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
    );
  }

  double _calculateHighlightPosition(double contentSize, double viewportSize) {
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentScrollPosition = _scrollController.offset;

    final scrollProgress = maxScrollExtent > 0
        ? (currentScrollPosition / maxScrollExtent).clamp(0.0, 1.0)
        : 0.0;

    final availableMovementSpace = contentSize - viewportSize;
    return scrollProgress * availableMovementSpace;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.of(context).size;
        const pageHeader = 88;
        final maxSize =
            _isVertical ? screenSize.height - pageHeader : screenSize.width;

        assignedViewPortSize = maxSize * widget.scaleFactor;

        double? childSize;
        final childContext = _childKey.currentContext;
        if (childContext != null) {
          final childRenderBox = childContext.findRenderObject() as RenderBox?;
          childSize = _isVertical
              ? childRenderBox?.size.height
              : childRenderBox?.size.width;
        }

        final miniContentSize = childSize != null
            ? (childSize * widget.scaleFactor).clamp(0.0, maxSize)
            : double.maxFinite;

        final scrollView = Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: _isVertical ? Axis.vertical : Axis.horizontal,
            child: RepaintBoundary(
              key: _childKey,
              child: widget.child,
            ),
          ),
        );

        Widget buildHighlight() {
          if (!_scrollController.hasClients) return const SizedBox();

          final highlightPosition = _calculateHighlightPosition(
            miniContentSize,
            assignedViewPortSize,
          );

          return AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            top: _isVertical ? highlightPosition : 0,
            left: !_isVertical ? highlightPosition : 0,
            width: _isVertical ? widget.miniSize : assignedViewPortSize,
            height: _isVertical ? assignedViewPortSize : widget.miniSize,
            child: Container(
              height: assignedViewPortSize,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: widget.highlightColor,
                  width: 2,
                ),
              ),
            ),
          );
        }

        final minimap = SizedBox(
          width: _isVertical ? widget.miniSize : double.infinity,
          height: _isVertical ? double.infinity : widget.miniSize,
          child: GestureDetector(
            onTapDown: (details) => _onMinimapInteraction(
              details.localPosition,
              miniContentSize,
            ),
            onVerticalDragUpdate: _isVertical
                ? (details) => _onMinimapInteraction(
                      details.localPosition,
                      miniContentSize,
                    )
                : null,
            onHorizontalDragUpdate: !_isVertical
                ? (details) => _onMinimapInteraction(
                      details.localPosition,
                      miniContentSize,
                    )
                : null,
            child: Stack(
              children: [
                if (_miniImage != null)
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(Size(
                      _isVertical ? widget.miniSize : double.maxFinite,
                      _isVertical ? double.maxFinite : widget.miniSize,
                    )),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomPaint(
                        size: Size(
                          _isVertical ? widget.miniSize : double.maxFinite,
                          _isVertical ? double.maxFinite : widget.miniSize,
                        ),
                        painter: ImagePainter(
                          _miniImage!,
                          _isVertical ? widget.miniSize : miniContentSize,
                          _isVertical ? miniContentSize : widget.miniSize,
                        ),
                      ),
                    ),
                  ),
                Container(
                  color: Colors.grey.withOpacity(0.1),
                ),
                buildHighlight(),
              ],
            ),
          ),
        );

        switch (widget.position) {
          case MinimapPosition.left:
            return Row(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [minimap, scrollView],
            );
          case MinimapPosition.right:
            return Row(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [scrollView, minimap],
            );
          case MinimapPosition.top:
            return Column(
              children: [minimap, scrollView],
            );
          case MinimapPosition.bottom:
            return Column(
              children: [scrollView, minimap],
            );
        }
      },
    );
  }
}
