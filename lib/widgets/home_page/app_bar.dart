import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;

  CustomAppBar({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: Theme.of(context).primaryColor,
      child: Container(
        height: preferredSize.height,
        color: Theme.of(context).primaryColor,
        child: child,
      ),
    );
  }
}
