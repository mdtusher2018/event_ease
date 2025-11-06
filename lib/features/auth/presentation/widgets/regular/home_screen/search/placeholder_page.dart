import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/custom_button.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;
  final VoidCallback onNext;

  const PlaceholderPage({super.key, required this.title, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          CustomButton(
            text: AppString.next,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}
