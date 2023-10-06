/// {@category Widgets}
library custom_app_bar;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///The app bar used across the app for consistency.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, this.removeBackButton});

  ///Title of the screen.
  final String title;

  ///To remove the back button from the app bar.
  final bool? removeBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(title, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: 22, fontWeight: FontWeight.w500),),
      leading: removeBackButton == true ? Container() : IconButton(
        onPressed: () {
          context.pop();
        }, icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyMedium!.color,),
      ),
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(70);
  }
}
