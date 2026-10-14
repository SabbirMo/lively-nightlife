import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_recent_activity.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_revenue_chart.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_summary_grid.dart';

class ClubOverviewTab extends StatelessWidget {
  const ClubOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ClubSummaryGrid(),
        SizedBox(height: 24.h),
        const ClubRevenueChart(),
        SizedBox(height: 24.h),
        const ClubRecentActivity(),
      ],
    );
  }
}
