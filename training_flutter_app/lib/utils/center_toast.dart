import 'package:flutter/material.dart';

void showCenterToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);

  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.4,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 5), () {
    overlayEntry.remove();
  });
}
