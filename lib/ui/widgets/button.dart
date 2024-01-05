import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

class MyButton extends StatelessWidget {

  final String label;
  final Function() onTap;

  const MyButton(this.label,this.onTap,{super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Get.isDarkMode? secondaryClr : primaryClr,
        ),
        child: Text(label,style: GoogleFonts.lato(color: Colors.white),textAlign: TextAlign.center,),
      ),
    );
  }
}
