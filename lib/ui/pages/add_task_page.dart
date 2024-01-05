import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_3/models/task.dart';
import 'package:to_do_app_3/ui/theme.dart';
import 'package:to_do_app_3/ui/widgets/button.dart';
import 'package:to_do_app_3/ui/widgets/input_field.dart';

import '../../controller/task_controller.dart';

class AddTaskPage extends StatefulWidget {
  final ImageProvider<Object>? bgImage;

  const AddTaskPage(this.bgImage,{super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: appBar(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                "Add Task",
                style: headingStyle,
              ),
              InputField(
                title: "Title",
                hint: "Enter Title Here",
                controller: _titleController,
              ),
              InputField(
                title: "Note",
                hint: "Enter Note Here",
                controller: _noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () => _getDateFromUser(),
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: primaryClr,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: primaryClr,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: primaryClr,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: Row(
                  children: <Widget>[
                    DropdownButton(
                      dropdownColor: Get.isDarkMode ? secondaryClr : primaryClr,
                      borderRadius: BorderRadius.circular(10),
                      items: remindList
                          .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                "$value",
                                style: const TextStyle(color: Colors.white),
                              )))
                          .toList(),
                      style: subTitleStyle,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRemind = newValue!;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: primaryClr,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
              InputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: Row(
                  children: <Widget>[
                    DropdownButton(
                      dropdownColor: Get.isDarkMode ? secondaryClr : primaryClr,
                      borderRadius: BorderRadius.circular(10),
                      items: repeatList
                          .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  )))
                          .toList(),
                      style: subTitleStyle,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRepeat = newValue!;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: primaryClr,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _colorPalette(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MyButton("Create Task", () {
                      _validation();
                    }),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }



  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: context.theme.colorScheme.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_outlined,
          color: Get.isDarkMode ? primaryClr : secondaryClr,
          size: 28,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      actions:   [
        CircleAvatar(
          backgroundImage: widget.bgImage ?? const AssetImage("images/img.png"),
          radius: 20,
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  _validation() {
    if ((_titleController.text.isNotEmpty && !_titleController.text.isNum) &&
        (_noteController.text.isNotEmpty && !_noteController.text.isNum)) {
      _addTaskToDB();
      Get.back();
    }
    else if(_titleController.text.isNum || _noteController.text.isNum)
      {
        Get.snackbar("Warning", "Don't Enter A Numbers At Text Fields",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.isDarkMode ? darkHeaderClr : Colors.grey[200],
            colorText: Colors.red,
            icon: const Icon(
              Icons.warning_amber_outlined,
              color: Colors.yellow,
            ),
            forwardAnimationCurve: Curves.easeInToLinear,
            reverseAnimationCurve: Curves.easeInSine,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 10));
      }
    else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("required", "All Fields Are Required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.isDarkMode ? darkHeaderClr : Colors.grey[200],
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_outlined,
            color: Colors.red,
          ),
          forwardAnimationCurve: Curves.bounceInOut,
          reverseAnimationCurve: Curves.easeInOutCirc,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 10));
    } else {
      print("############SOMETHING BAD HAPPENED##########");
    }
  }

  _addTaskToDB() async {
    try {
      int value = await _taskController.addTask(
          task: Task(
              title: (_titleController.text).toString(),
              note: (_noteController.text).toString(),
              isCompleted: 0,
              date: DateFormat.yMd().format(_selectedDate),
              startTime: _startTime,
              endTime: _endTime,
              color: _selectedColor,
              remind: _selectedRemind,
              repeat: _selectedRepeat,
          ));
      print(value);
    } catch (e) {
      print(e);
    }
  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            "Color",
            style: titleStyle,
          ),
        ),
        Wrap(
            children: List.generate(
          3,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : orangeClr,
                radius: 16,
                child: _selectedColor == index
                    ? const Icon(
                        Icons.done_outline,
                        size: 16,
                        color: Colors.black,
                      )
                    : null,
              ),
            ),
          ),
        ))
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    } else {
      print("IT'S NULL OR SOMETHING IS WRONG!!");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );

    String formattedTime = pickedTime!.format(context);

    if (isStartTime) {
      setState(() {
        _startTime = formattedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = formattedTime;
      });
    } else {
      print("IT'S NULL OR SOMETHING IS WRONG!!");
    }
  }
}
