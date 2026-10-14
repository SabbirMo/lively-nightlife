import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';

class HeatZoneMarkerWidget extends StatelessWidget {
  final double percentage;
  final Color color;
  final double size;

  const HeatZoneMarkerWidget({
    super.key,
    required this.percentage,
    required this.color,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    final innerSize = size * .42;

    final iconSize = innerSize * .25;

    final textSize = innerSize * .18;

    return Container(
      width: size.w,
      height: size.w,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: .18),
      ),

      child: Center(
        child: Container(
          width: innerSize.w,
          height: innerSize.w,

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: .12),
            border: Border.all(
              color: color,
              width: 1.5,
            ),
          ),

          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  IconPath.flameIcon,
                  width: iconSize.w,
                  height: iconSize.w,
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcIn,
                  ),
                ),

                SizedBox(
                  height: innerSize * .04,
                ),

                TextProperty(
                  text: '${percentage.toInt()}%',
                  textColor: color,
                  fontSize: textSize.sp,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}