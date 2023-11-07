import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../Controller/theme_controller.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    this.iconColor,
    this.bgIconColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final Color? iconColor;
  final Color? bgIconColor;

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: bgIconColor ?? Colors.blueAccent.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.blueAccent,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: textColor,
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: isDark
                    ? Colors.grey.withOpacity(0.25)
                    : Colors.grey.withOpacity(0.75),
              ),
              child: Icon(
                LineAwesomeIcons.angle_right,
                size: 20,
                color: iconColor,
              ),
            )
          : null,
    );
  }
}
