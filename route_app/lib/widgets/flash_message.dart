import 'package:flutter/material.dart';

void showSuccessSnackBar(BuildContext context, String successMessage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(child: Text(successMessage)),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.green,
  ));
}

void showErrorSnackBar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      children: [
        const Icon(Icons.error, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(child: Text(errorMessage)),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red,
  ));
}

void showWarningSnackBar(BuildContext context, String warningMessage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      children: [
        const Icon(Icons.warning, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(child: Text(warningMessage)),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.orange,
  ));
}
