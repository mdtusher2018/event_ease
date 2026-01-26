import 'package:event_ease/features/auth/presentation/widgets/regular/inspiration/custom_idea_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/styles.dart';

class ViewAllInspirationPage extends StatelessWidget {
  final String title; // Static title
  final String subtitle; // Static subtitle
  final List<dynamic> inspirations; // List of inspirations

  const ViewAllInspirationPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.inspirations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  inspirations.isNotEmpty
                      ? ListView.builder(
                        itemCount: inspirations.length,
                        itemBuilder: (context, index) {
                          var data = inspirations[index];

                          String isoTime = data['createdAt'];
                          DateTime dateTime = DateTime.parse(isoTime);
                          String createDate = DateFormat(
                            'dd-MM-yyyy',
                          ).format(dateTime);
                          String createTime = DateFormat(
                            'HH:mm',
                          ).format(dateTime);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomIdeaContainer(
                              image: "${data['coverImage']}",
                              title: data['title'] ?? "",
                              description: data['description'] ?? "",
                              authorImage: data['author']['profileImage'],
                              authorName: data['author']['name'],
                              createDate: createDate,
                              createTime: createTime,
                              imageWidth: double.infinity,
                              onTap: () {
                                // Optionally handle tap
                              },
                            ),
                          );
                        },
                      )
                      : Center(
                        child: Text(
                          "No data found".tr,
                          style: styleForNormalText.copyWith(fontSize: 14.sp),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
