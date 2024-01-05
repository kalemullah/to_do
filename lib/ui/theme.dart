import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

const primaryClr = Color.fromRGBO(190, 173, 250,1);
const secondaryClr =  Color.fromRGBO(101, 100, 124,1);
const Color pinkClr = Color(0xfff65671);
const Color orangeClr = Color.fromRGBO(241, 201, 104, 1.0);
const Color darkHeaderClr = Color(0xFF424242);
const Color darkGreyClr = Color(0xFF121212);

class Themes {
  static final light = ThemeData(
    //useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color.fromRGBO(74, 85, 162, 1),
        primary: primaryClr,
        background: Colors.white,
        brightness: Brightness.light),
  );
  static final dark = ThemeData(
    //useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch().copyWith(
        //secondary: const Color.fromRGBO(74, 85, 162, 1),
        primary: secondaryClr,
        background: Colors.black,
        brightness: Brightness.dark),
    //canvasColor: Colors.black,
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 26,
        color: Get.isDarkMode ? Colors.white : Colors.blueGrey[600]),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle:  TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Get.isDarkMode?Colors.white: Colors.black),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle:  TextStyle(
        fontSize: 18,
        color: Get.isDarkMode?Colors.white: Colors.black,
        fontWeight: FontWeight.bold,
      ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle:  TextStyle(fontSize: 20, color: Get.isDarkMode?Colors.white: Colors.black),
  );
}
