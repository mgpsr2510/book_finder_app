import 'package:flutter/material.dart';
import '../../core/utils/responsive_helper.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final Widget? mobileChild;
  final Widget? tabletChild;
  final Widget? desktopChild;

  const ResponsiveWrapper({
    Key? key,
    required this.child,
    this.mobileChild,
    this.tabletChild,
    this.desktopChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isMobile(context) && mobileChild != null) {
      return mobileChild!;
    }
    if (ResponsiveHelper.isTablet(context) && tabletChild != null) {
      return tabletChild!;
    }
    if (ResponsiveHelper.isDesktop(context) && desktopChild != null) {
      return desktopChild!;
    }
    return child;
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.maxWidth,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: maxWidth ?? ResponsiveHelper.getMaxWidth(context),
        padding: padding ?? EdgeInsets.zero, // Remove default padding
        child: child,
      ),
    );
  }
}
