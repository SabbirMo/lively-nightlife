import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/controller/heat_map_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/widget/heat_filer_tabs_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/widget/heat_map_bottom_sheet_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/widget/heat_map_header_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/widget/heat_map_legend_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/widget/heat_zone_marker_widget.dart';

class HeatMapView extends GetView<HeatMapController> {
  const HeatMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // GoogleMap(
          //   initialCameraPosition: const CameraPosition(
          //     target: LatLng(25.774, -80.190),
          //     zoom: 13,
          //   ),
          //   myLocationEnabled: true,
          //   myLocationButtonEnabled: false,
          //   zoomControlsEnabled: false,
          //   compassEnabled: false,
          //   mapToolbarEnabled: false,
          //   circles: _buildHeatCircles(),
          // ),
          Positioned(
            top: 170.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(ImagePath.heatMapDemo, fit: BoxFit.cover),
          ),

          Obx(
            () => Stack(
              children: controller.visibleZones.map((zone) {
                return Positioned(
                  top: zone.top.h,
                  left: zone.left.w,

                  child: GestureDetector(
                    onTap: () {
                      controller.selectZone(zone);
                    },

                    child: HeatZoneMarkerWidget(
                      percentage: zone.heatPercentage,
                      color: _zoneColor(zone.heatPercentage),
                      size: _zoneSize(zone.heatPercentage),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  const HeatMapHeaderWidget(),
                  SizedBox(height: 16.h),
                  const HeatFilterTabsWidget(),
                  const Spacer(),
                ],
              ),
            ),
          ),

          Positioned(
            top: 220.h,
            right: 20.w,
            child: const HeatMapLegendWidget(),
          ),

          const HeatMapBottomSheetWidget(),
        ],
      ),
    );
  }

  Color _zoneColor(double heat) {
    if (heat >= 90) {
      return AppColors.insaneColor;
    }

    if (heat >= 70) {
      return AppColors.hotColor;
    }

    if (heat >= 50) {
      return AppColors.activeColor;
    }

    return AppColors.mildColor;
  }

  double _zoneSize(double heat) {
    if (heat >= 90) {
      return 180;
    }

    if (heat >= 70) {
      return 140;
    }

    if (heat >= 50) {
      return 100;
    }

    return 80;
  }
}
