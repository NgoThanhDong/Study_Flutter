import 'package:flutter/material.dart';

class SlideRightRoute<T> extends PageRouteBuilder<T> {
  SlideRightRoute({
    required Widget page,
    Duration duration = const Duration(milliseconds: 800),
  }) : super(
         pageBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
             ) => page,

         transitionDuration: duration,
         reverseTransitionDuration: duration,

         transitionsBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
               Widget child,
             ) {
               final curvedAnimation = CurvedAnimation(
                 parent: animation,
                 curve: Curves.easeOutCubic,
                 reverseCurve: Curves.easeInCubic,
               );

               final slideTween = Tween<Offset>(
                 begin: const Offset(1.0, 0.0),
                 end: Offset.zero,
               );

               return SlideTransition(
                 position: curvedAnimation.drive(slideTween),
                 child: child,
               );
             },
       );
}
