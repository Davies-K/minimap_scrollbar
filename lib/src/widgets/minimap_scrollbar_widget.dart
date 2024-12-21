import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../resources/minimap_image_painter.dart';

/// A live mirror widget that captures & displays a miniature, synchronised view
/// of its child widget. The mirror image updates every 2 seconds to reflect
/// the current state of the child widget, allowing real-time monitoring and
/// quick navigation of scrollable content.
///
/// Key features:
/// - Creates a scaled-down, interactive minimap of the child widget
/// - Provides a movable highlight indicating current viewport position
/// - Allows scrolling and navigation through the minimap
/// - Automatically updates minimap image periodically
class MinimapScrollbarWidget extends StatefulWidget {
  const MinimapScrollbarWidget({
    super.key,
    required this.child,
    this.miniWidth = 120.0,
    this.scaleFactor = 0.3,
    this.highlightColor = Colors.blue,
    this.viewportHeight = 200.0,
  });

  final Widget child;
  final double miniWidth;
  final double scaleFactor;
  final Color highlightColor;
  final double viewportHeight;

  @override
  State<MinimapScrollbarWidget> createState() => _MinimapScrollbarWidgetState();
}

class _MinimapScrollbarWidgetState extends State<MinimapScrollbarWidget> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _childKey = GlobalKey();

  ui.Image? _miniImage;
  Timer? _imageUpdateTimer;
  late double assignedViewPortHeight;

  @override
  void initState() {
    super.initState();
    assignedViewPortHeight = widget.viewportHeight;

    _scrollController.addListener(_updateHighlight);
    WidgetsBinding.instance.addPostFrameCallback((_) => _captureMiniImage());

    _imageUpdateTimer = Timer.periodic(
      const Duration(seconds: 2),
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

  void _onMiniTapDown(TapDownDetails details, double miniHeight) {
    if (!_scrollController.hasClients) return;
    
    final tapPositionRatio = details.localPosition.dy / miniHeight;
    final targetScroll = tapPositionRatio * _scrollController.position.maxScrollExtent;

    _scrollController.jumpTo(
      targetScroll.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
    );
  }

  double _calculateHighlightTop(double contentHeight, double viewportHeight) {
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentScrollPosition = _scrollController.offset;

    final scrollProgress = maxScrollExtent > 0
        ? (currentScrollPosition / maxScrollExtent).clamp(0.0, 1.0)
        : 0.0;

    final availableMovementSpace = contentHeight - viewportHeight;
    return scrollProgress * availableMovementSpace;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const headerHeight = 88;
        final maxMiniHeight = MediaQuery.of(context).size.height - headerHeight;

        assignedViewPortHeight = maxMiniHeight * widget.scaleFactor;

        double? childHeight;
        final childContext = _childKey.currentContext;
        if (childContext != null) {
          final childRenderBox = childContext.findRenderObject() as RenderBox?;
          childHeight = childRenderBox?.size.height;
        }

        final miniChildHeight = childHeight != null
            ? (childHeight * widget.scaleFactor).clamp(0.0, maxMiniHeight)
            : double.maxFinite;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth - widget.miniWidth,
                    ),
                    child: RepaintBoundary(
                      key: _childKey,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: widget.miniWidth,
              child: GestureDetector(
                onTapDown: (details) => _onMiniTapDown(details, miniChildHeight),
                onVerticalDragUpdate: (details) {
                  if (!_scrollController.hasClients) return;
                  
                  final dragRatio = details.localPosition.dy / miniChildHeight;
                  final targetScroll = dragRatio * _scrollController.position.maxScrollExtent;

                  _scrollController.jumpTo(
                    targetScroll.clamp(
                      0.0,
                      _scrollController.position.maxScrollExtent,
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    if (_miniImage != null)
                      ConstrainedBox(
                        constraints: BoxConstraints.tight(Size(widget.miniWidth, double.maxFinite)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomPaint(
                            size: Size(widget.miniWidth, double.maxFinite),
                            painter: ImagePainter(
                              _miniImage!,
                              widget.miniWidth,
                              miniChildHeight,
                            ),
                          ),
                        ),
                      ),
                    Container(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    if (_scrollController.hasClients)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 100),
                        top: _calculateHighlightTop(
                          miniChildHeight,
                          assignedViewPortHeight,
                        ),
                        left: 0,
                        right: 0,
                        height: assignedViewPortHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: widget.highlightColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}