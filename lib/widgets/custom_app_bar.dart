import 'package:flutter/material.dart';
import 'package:part2_project/models/user_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final UserModel? user;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLoginTap;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.user,
    this.onProfileTap,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepOrange,
      elevation: 0,
      title: title != null
          ? Text(title!)
          : Image.asset("images/logo.png", height: 70),
      centerTitle: true,
      leading: leading ??
          (user != null
              ? GestureDetector(
                  onTap: onProfileTap,
                  child: CircleAvatar(
                    backgroundImage: MemoryImage(user!.profileImageBytes!),
                    radius: 20,
                  ),
                )
              : null),
      actions: actions ??
          [
            if (user == null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: onLoginTap,
                  child: const Text("Login"),
                ),
              ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 