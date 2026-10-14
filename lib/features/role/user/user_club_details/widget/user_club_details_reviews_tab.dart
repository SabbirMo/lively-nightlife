import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';

class UserClubDetailsReviewsTab extends StatelessWidget {
  const UserClubDetailsReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      _ReviewData(
        name: 'luna_vibes',
        avatarUrl: 'https://i.pravatar.cc/150?img=49',
        rating: 5,
        timeAgo: '2 days ago',
        comment:
            'Absolutely mind-blowing experience. The music, the crowd, the atmosphere — all top tier. Will definitely be coming back!',
      ),
      _ReviewData(
        name: 'dj_maxxx',
        avatarUrl: 'https://i.pravatar.cc/150?img=33',
        rating: 5,
        timeAgo: '1 week ago',
        comment:
            'Best sound system in Vegas hands down. The production is unreal. Every show here is a 10/10.',
      ),
      _ReviewData(
        name: 'party_legend',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        rating: 4,
        timeAgo: '2 weeks ago',
        comment:
            'Incredible vibes, a bit pricey but worth every penny. The DJ set was legendary.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating breakdown panel card
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.grey50Color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              // Rating average column
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextProperty(
                    text: '4.8',
                    textColor: AppColors.blackColor,
                    fontSize: 42.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < 4 ? Icons.star : Icons.star_half,
                        size: 16.sp,
                        color: AppColors.amberColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextProperty(
                    text: '12.4k reviews',
                    textColor: AppColors.greyColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              SizedBox(width: 24.w),

              // Rating slider distribution
              Expanded(
                child: Column(
                  children: [
                    _buildProgressRow(starsCount: 5, percentage: 0.85),
                    SizedBox(height: 4.h),
                    _buildProgressRow(starsCount: 4, percentage: 0.65),
                    SizedBox(height: 4.h),
                    _buildProgressRow(starsCount: 3, percentage: 0.35),
                    SizedBox(height: 4.h),
                    _buildProgressRow(starsCount: 2, percentage: 0.15),
                    SizedBox(height: 4.h),
                    _buildProgressRow(starsCount: 1, percentage: 0.05),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        // Reviews list
        ...reviews.map((rev) => _buildReviewCard(rev)),
      ],
    );
  }

  Widget _buildProgressRow({
    required int starsCount,
    required double percentage,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 12.w,
          child: TextProperty(
            text: '$starsCount',
            textColor: AppColors.greyColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3.r),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 6.h,
              backgroundColor: AppColors.grey50Color,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.amberColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(_ReviewData rev) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.grey50Color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, TimeAgo
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: NetworkImage(rev.avatarUrl),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextProperty(
                    text: rev.name,
                    textColor: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star,
                        size: 12.sp,
                        color: i < rev.rating ? AppColors.amberColor : AppColors.grey50Color,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              TextProperty(
                text: rev.timeAgo,
                textColor: AppColors.greyColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Comment
          TextProperty(
            text: rev.comment,
            textColor: AppColors.grey700Color,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            lineHeight: 1.5,
          ),
        ],
      ),
    );
  }
}

class _ReviewData {
  final String name;
  final String avatarUrl;
  final int rating;
  final String timeAgo;
  final String comment;

  _ReviewData({
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.timeAgo,
    required this.comment,
  });
}
