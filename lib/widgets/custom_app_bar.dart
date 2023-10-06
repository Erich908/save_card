import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, this.removeBackButton});

  final String title;
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
