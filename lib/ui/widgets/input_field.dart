import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../size_config.dart';
import '../theme.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const InputField(
      {required this.title,
      required this.hint,
      this.controller,
      this.widget,
      super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        margin:  const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle,
            ),
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: SizeConfig.screenWidth,
              height: title == "Note"? 100 : 52,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueGrey)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          maxLines: title == "Note"? 5:1,
                          controller: controller,
                          autofocus: false,
                          readOnly: widget != null ? true : false,
                          style: subTitleStyle,
                          cursorColor: Get.isDarkMode? Colors.blueGrey : primaryClr,
                          decoration:InputDecoration(
                            hintText: hint,
                            hintStyle: subTitleStyle.copyWith(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: context.theme.colorScheme.background,
                                width: 0
                              )
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: context.theme.colorScheme.background,
                                width: 0
                              )
                            )
                          ) ,
                        ),
                      ),
                  ),
                  widget ?? Container()
                ],
              ),
            ),
          ],
        ));
  }
}
