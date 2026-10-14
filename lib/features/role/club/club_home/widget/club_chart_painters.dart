import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';

class FollowerGrowthLinePainter extends CustomPainter {
  final List<double> data;
  FollowerGrowthLinePainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paintLine = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.insaneColor, AppColors.insaneColor],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.w
      ..strokeCap = StrokeCap.round;

    final paintGrid = Paint()
      ..color = AppColors.lightGreyColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.w;

    const gridLines = 3;
    final gridSpacing = size.height / gridLines;
    for (int i = 0; i <= gridLines; i++) {
      final y = i * gridSpacing;
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), paintGrid);
    }

    final pointsCount = data.length;
    final spacing = size.width / (pointsCount - 1);
    for (int i = 0; i < pointsCount; i++) {
      final x = i * spacing;
      _drawDashedLine(canvas, Offset(x, 0), Offset(x, size.height), paintGrid);
    }

    final points = <Offset>[];
    const maxVal = 100.0;
    for (int i = 0; i < data.length; i++) {
      final x = i * spacing;
      final y = size.height - (data[i] / maxVal * size.height);
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    final paintFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.insaneColor.withValues(alpha: 0.15),
          AppColors.insaneColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = p1.dx;
    double startY = p1.dy;

    if (p1.dy == p2.dy) {
      while (startX < p2.dx) {
        canvas.drawLine(
          Offset(startX, p1.dy),
          Offset(startX + dashWidth, p1.dy),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    } else {
      while (startY < p2.dy) {
        canvas.drawLine(
          Offset(p1.dx, startY),
          Offset(p1.dx, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WeeklyTicketsBarPainter extends CustomPainter {
  final List<double> data;
  WeeklyTicketsBarPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paintGrid = Paint()
      ..color = AppColors.lightGreyColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.w;

    const gridLines = 3;
    final gridSpacing = size.height / gridLines;
    for (int i = 0; i <= gridLines; i++) {
      final y = i * gridSpacing;
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), paintGrid);
    }

    final barCount = data.length;
    final spacing = size.width / barCount;

    for (int i = 0; i <= barCount; i++) {
      final x = i * spacing;
      _drawDashedLine(canvas, Offset(x, 0), Offset(x, size.height), paintGrid);
    }

    const maxVal = 140.0;
    final barWidth = 40.w;

    final paintBar = Paint()
      ..color = AppColors.purpleColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < barCount; i++) {
      final cx = i * spacing + (spacing / 2);
      final barHeight = (data[i] / maxVal) * size.height;
      final rect = Rect.fromLTWH(
        cx - (barWidth / 2),
        size.height - barHeight,
        barWidth,
        barHeight,
      );
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(6.r));
      canvas.drawRRect(rrect, paintBar);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = p1.dx;
    double startY = p1.dy;

    if (p1.dy == p2.dy) {
      while (startX < p2.dx) {
        canvas.drawLine(
          Offset(startX, p1.dy),
          Offset(startX + dashWidth, p1.dy),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    } else {
      while (startY < p2.dy) {
        canvas.drawLine(
          Offset(p1.dx, startY),
          Offset(p1.dx, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
