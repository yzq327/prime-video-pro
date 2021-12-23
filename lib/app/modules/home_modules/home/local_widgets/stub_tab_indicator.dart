import 'package:flutter/cupertino.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';

class StubTabIndicator extends Decoration {
  final BoxPainter _painter;

  StubTabIndicator({required Color color}) : _painter = _StubPainter(color);

  @override
  BoxPainter createBoxPainter([ VoidCallback ? onChanged ]) => _painter;
}

class _StubPainter extends BoxPainter {
  final Paint _paint;

  _StubPainter(Color color)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final double width = SpaceData.spaceSizeWidth110;
    final double height = SpaceData.spaceSizeHeight40;
    final double radius = SpaceData.spaceSizeWidth20;
    final double left = offset.dx + cfg.size!.width / 2 - width / 2;
    canvas.drawRRect(
        RRect.fromLTRBR(
          left,
          cfg.size!.height - height,
          left + width,
          cfg.size!.height,
          Radius.circular(radius),
        ),
        _paint);
  }
}

