
// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/api/business_subscription_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionCard extends StatefulWidget {
  final SubscriptionModel model;
Function()? selectButtonOnTap;
int indexFonExpantion;
int? targetedIndex;
final void Function(int)? onOptionTap;
   SubscriptionCard({Key? key,this.targetedIndex, required this.model,required this.selectButtonOnTap,required this.onOptionTap,required this.indexFonExpantion}) : super(key: key);

  @override
State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();

if(widget.indexFonExpantion==widget.targetedIndex){
    _isExpanded=true;
}
  }
  @override
  Widget build(BuildContext context) {
    final model = widget.model;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.title,
            style: styleForBoldText.copyWith(
              color: AppColors.darkGrey,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            model.subtitle,
            style: styleForNormalText.copyWith(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text("Package Includes:", style: styleForBoldText.copyWith(fontSize: 18.sp)),
          SizedBox(height: 10.h),
          ...model.feature.map((f) => Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Text("• $f", style: styleForNormalText.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              )),
          SizedBox(height: 10.h),

          // ExpansionTile with manual control
          Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: UniqueKey(), // force rebuild to fix expansion bug
              initiallyExpanded: _isExpanded,
              onExpansionChanged: (value) {
                setState(() {
                  _isExpanded = value;
                });
              },
              trailing:SizedBox(),
              //  ElevatedButton(
              //   style: ButtonStyle(
              //     backgroundColor: WidgetStatePropertyAll(AppColors.primary),
              //   ),
              //   onPressed: widget.selectButtonOnTap,
              //   child: Text(
              //     "Select",
              //     style: styleForBoldText.copyWith(
              //       color: Colors.white,
              //       fontSize: 18.sp,
              //       height: 1.56.h,
              //     ),
              //   ),
              // ),
              title: Text("Starting From €${model.options.first.price}", style: styleForBoldText),
              children: [
                SizedBox(
                  height: 250,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: model.options.length,
                    itemBuilder: (context, index) {
                      final option = model.options[index];
                      return GestureDetector(
                        onTap: () {
      if (widget.onOptionTap != null) {
        widget.onOptionTap!(index); 
      }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.time,
                                style: styleForNormalText.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                "\$${option.price}",
                                style: styleForBoldText.copyWith(fontSize: 24.sp),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                "Expires in ${option.expirationDays} days",
                                style: styleForNormalText.copyWith(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
       
         CustomButton(text:_isExpanded ? "Hide" :  "Select", borderRadius: 16,onTap:_toggleExpansion ,),
        ],
      ),
    );
  }
}

