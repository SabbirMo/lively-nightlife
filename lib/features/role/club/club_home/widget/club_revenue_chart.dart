import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_home_controller.dart';

class ClubRevenueChart extends StatelessWidget {
  const ClubRevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClubHomeController>();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor2,
        borderRadius: BorderRadius.circular(24.r),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.015),
        //     blurRadius: 10.r,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextProperty(
                text: 'Revenue This Week',
                textColor: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
              TextProperty(
                text: '+23% vs last week',
                textColor: AppColors.greenColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 120.h,
            width: double.infinity,
            child: CustomPaint(
              painter: _RevenueLinePainter(data: controller.revenueData),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: controller.chartDays.map((day) {
              return SizedBox(
                width: 42.w,
                child: TextProperty(
                  text: day,
                  textColor: AppColors.lightGreyColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _RevenueLinePainter extends CustomPainter {
  final List<double> data;

  _RevenueLinePainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paintLine = Paint()
      ..color = AppColors.purpleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.w
      ..strokeCap = StrokeCap.round;

    // Draw horizontal dashed grid lines
    final paintGrid = Paint()
      ..color = AppColors.lightGreyColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.w;

    const gridLines = 3;
    final gridSpacing = size.height / gridLines;
    for (int i = 0; i <= gridLines; i++) {
      final y = i * gridSpacing;
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), paintGrid);
    }

    // Draw vertical dashed grid lines
    final pointsCount = data.length;
    final spacing = size.width / (pointsCount - 1);
    for (int i = 0; i < pointsCount; i++) {
      final x = i * spacing;
      _drawDashedLine(canvas, Offset(x, 0), Offset(x, size.height), paintGrid);
    }

    // Compute coordinate points
    final points = <Offset>[];
    const maxVal = 80.0; // Scaled to fit chart values (up to 75.0)
    for (int i = 0; i < data.length; i++) {
      final x = i * spacing;
      final y = size.height - (data[i] / maxVal * size.height);
      points.add(Offset(x, y));
    }

    // Generate smooth Bezier path
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    // Draw gradient fill under the path
    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    final paintFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.purpleColor.withValues(alpha: 0.25),
          AppColors.purpleColor.withValues(alpha: 0.0),
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
      // Horizontal
      while (startX < p2.dx) {
        canvas.drawLine(
          Offset(startX, p1.dy),
          Offset(startX + dashWidth, p1.dy),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    } else {
      // Vertical
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
