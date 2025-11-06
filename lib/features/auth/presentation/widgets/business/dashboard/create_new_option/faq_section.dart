import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';
import '../../../custom_text_field.dart';

class FAQSection extends StatelessWidget {
  final List<Map<String, String>> faqList;
  final List<TextEditingController> questionControllers;
  final List<TextEditingController> answerControllers;
  final VoidCallback addFAQField;
  final Function(int) deleteFAQField;

  const FAQSection({
    super.key,
    required this.faqList,
    required this.questionControllers,
    required this.answerControllers,
    required this.addFAQField,
    required this.deleteFAQField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppString.addFaq, style: styleForBoldText),
        const SizedBox(height: 10),
        ...List.generate(faqList.length, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question field
              Text('Question ${index + 1}', style: styleForBoldText.copyWith(fontSize: 14, color: AppColors.primary),),
              SizedBox(height: 10,),
              CustomTextField(
                hintText: 'Add Question',
                isSuffix: false,
                controller: questionControllers[index],
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Answer field
              Text('Answer ${index + 1}',  style: styleForBoldText.copyWith(fontSize: 14, color: AppColors.primary)),
              SizedBox(height: 10,),
              CustomTextField(
                maxLine: 4,
                hintText: 'Answer',
                isSuffix: false,
                controller: answerControllers[index],
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an answer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Delete button for each FAQ field
              if (faqList.length > 1)
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteFAQField(index),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          );
        }),

        InkWell(
          onTap: addFAQField,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primary
            ),
            padding: EdgeInsets.all(10),
            child: Text(AppString.addMore, style: styleForBoldText.copyWith(fontSize: 14, color: Colors.white),),
          ),
        ),
      ],
    );
  }
}