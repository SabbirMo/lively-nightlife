import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/models/auth_role.dart';

class RoleSelectorWidget extends StatelessWidget {
  final AuthRole selectedRole;
  final Function(AuthRole role) onChanged;

  const RoleSelectorWidget({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      decoration: BoxDecoration(
        color: AppColors.grey100Color,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _RoleItem(
              title: 'User',
              isSelected: selectedRole == AuthRole.user,
              onTap: () => onChanged(AuthRole.user),
            ),
          ),
          Expanded(
            child: _RoleItem(
              title: 'Club',
              isSelected: selectedRole == AuthRole.club,
              onTap: () => onChanged(AuthRole.club),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.whiteColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Center(
          child: TextProperty(
            text: title,
            textColor: isSelected ? AppColors.blackColor : AppColors.greyColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}