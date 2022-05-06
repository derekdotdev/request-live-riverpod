import 'package:flutter/material.dart';

ScaffoldFeatureController showCustomSnackbar({
  required BuildContext ctx,
  required String message,
  required bool success,
}) {
  return ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: success ? Colors.green : Colors.red,
    ),
  );
}
