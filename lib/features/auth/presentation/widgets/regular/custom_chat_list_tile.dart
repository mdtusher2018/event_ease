import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomChatListTile extends StatelessWidget {
  final String profileImage;
  final String name;
  final String msg;
  final String time;
  final String chatname;
  final Color? bgColor;
  final Color? borderColor;
  final bool isClosed;

  const CustomChatListTile({
    Key? key,
    required this.profileImage,
    required this.name,
    required this.msg,
    required this.time,
    required this.chatname,
    this.bgColor,
    this.borderColor,
    this.isClosed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(profileImage)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(child: Text(name,maxLines: 1,)),
              
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color:(PrefsHelper.myRole=='user')?Colors.transparent: (isClosed)? Colors.green:Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          if(chatname.isNotEmpty)
          Text(chatname,style: TextStyle(fontSize: 12),)
        ],
      ),
      subtitle: Text(msg),
      trailing: Text(time, style: styleForBoldText.copyWith(fontSize: 14.sp),),
      tileColor: bgColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
