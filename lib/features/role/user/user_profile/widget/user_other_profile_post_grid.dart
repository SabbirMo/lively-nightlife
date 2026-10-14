import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/user_other_profile_controller.dart';

class UserOtherProfilePostGrid extends StatelessWidget {
  const UserOtherProfilePostGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserOtherProfileController>();
    final posts = controller.mockPosts;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.network(
            posts[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
