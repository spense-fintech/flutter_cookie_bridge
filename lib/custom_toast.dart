import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String message;

  const CustomToast({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        color: const Color(0xFF1B1B1B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontFamily: 'Urbanist',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
