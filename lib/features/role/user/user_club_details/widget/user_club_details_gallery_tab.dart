import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';

class UserClubDetailsGalleryTab extends StatelessWidget {
  const UserClubDetailsGalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      ImagePath.feedImage,
      ImagePath.onbImage1,
      ImagePath.onbImage2,
      ImagePath.onbImage3,
      ImagePath.onbImage4,
      ImagePath.feedImage,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.asset(images[index], fit: BoxFit.cover),
        );
      },
    );
  }
}
