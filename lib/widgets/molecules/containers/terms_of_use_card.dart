import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../atoms/app_label.dart';
class TermsOfUseCard extends StatelessWidget {
  final String label;
  final Function onTap;

  TermsOfUseCard({Key? key,required this.label,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){onTap();},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColors.appColorLightGray.withOpacity(0.2),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppLabel(text: label,fontSize: 14,fontWeight:FontWeight.w500,textColor: AppColors.appColorBlack01,),
            Icon(Icons.arrow_forward_ios,size: 18,)
          ],
        ),
      ),
    );
  }
}
