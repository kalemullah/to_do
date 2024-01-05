import "dart:io";
import "package:date_picker_timeline/date_picker_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_staggered_animations/flutter_staggered_animations.dart";
import "package:flutter_styled_toast/flutter_styled_toast.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:image_picker/image_picker.dart";
import "package:intl/intl.dart";
import "package:to_do_app_3/ui/pages/add_task_page.dart";
import "../../controller/task_controller.dart";
import "../../models/task.dart";
import "../../services/notification_services.dart";
import "../../services/theme_services.dart";
import "../size_config.dart";
import "../theme.dart";
import "../widgets/button.dart";
import "../widgets/task_tile.dart";

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions;
    _taskController.getTasks();
  }

  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: appBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              width: 140,
              height: 50,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent[200])),
                  onPressed: () {
                    buildDialog(context);
                  },
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.delete_forever_outlined,
                        //color: Colors.redAccent,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 1,
                      ),
                      Text(
                        "Delete All",
                        style: GoogleFonts.lato(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  void buildDialog(BuildContext context) {
    final AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      contentTextStyle: subTitleStyle,
      title: Text(
        "Delete All tasks",
        style: headingStyle,
      ),
      content: SizedBox(
        height: 130,
        child: Column(
          children: <Widget>[
            const Divider(
              color: Colors.grey,
            ),
            const Text("Are You Sure You Want To Delete All Tasks?"),
            const SizedBox(height: 7),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _taskController.deleteAllTasks();
                        notifyHelper.cancelAllNotification();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Delete",
                        style: GoogleFonts.lato(color: Colors.white),
                      )),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.indigo[300]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.lato(color: Colors.white),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return alert;
      },
      barrierDismissible: false,
      //barrierColor: Colors.orange.withOpacity(0.3)
    );
  }

  final ImagePicker picker = ImagePicker();
  File? pickedImage;
  ImageProvider<Object>? imageProvider;

  fetchImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      pickedImage = File(image.path);
      imageProvider = FileImage(pickedImage!);
      showToast(
        "Your Pic Changed Successfully",
        context: context,
        animation: StyledToastAnimation.rotate,
        reverseAnimation: StyledToastAnimation.fade,
        position: const StyledToastPosition(
            align: Alignment.bottomCenter, offset: 50),
        animDuration: const Duration(seconds: 2),
        duration: const Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
        backgroundColor: Colors.purple[200],
      );
    });
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: context.theme.colorScheme.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          color: Get.isDarkMode ? primaryClr : secondaryClr,
          size: 28,
        ),
        onPressed: () {
          ThemeServices().switchTheme();
          /* notifyHelper.displayNotification(title: "Theme Changed", body: "");
          notifyHelper.scheduledNotification();*/
        },
      ),
      actions: [
        GestureDetector(
          onTap: fetchImage,
          child: CircleAvatar(
            backgroundImage: pickedImage == null
                ? const AssetImage("images/img.png")
                : imageProvider,
            radius: 20,
            backgroundColor: primaryClr,
          ),
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 5, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              )
            ],
          ),
          MyButton("+ Add Task", () async {
            await Get.to(AddTaskPage(imageProvider));
            _taskController.getTasks();
            //notifyHelper.sendNotification();
          }),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 3, left: 6),
      padding: const EdgeInsets.only(top: 3, left: 6),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: _selectedDate,
        width: 60,
        height: 110,
        selectedTextColor: Colors.white,
        selectionColor: Get.isDarkMode ? secondaryClr : primaryClr,
        deactivatedColor: Get.isDarkMode ? Colors.white : Colors.black,
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          if (_taskController.taskList.isEmpty) {
            return _noTaskMsg();
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              backgroundColor: Get.isDarkMode ? darkHeaderClr : Colors.white,
              color: Get.isDarkMode ? Colors.white : darkHeaderClr,
              child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  var task = _taskController.taskList[index];

                  if (task.repeat == "Daily" ||
                      task.date == DateFormat.yMd().format(_selectedDate) ||
                      (task.repeat == "Weekly" &&
                          _selectedDate
                                      .difference(
                                          DateFormat.yMd().parse(task.date!))
                                      .inDays %
                                  7 ==
                              0) ||
                      (task.repeat == "Monthly" &&
                          DateFormat.yMd().parse(task.date!).day ==
                              _selectedDate.day)) {
                    DateTime date =
                        DateFormat('HH:mm a').parse(task.startTime!);
                    var myTime = DateFormat('HH:mm', "en_US").format(date);
                    print("myTime: $myTime");
                    print(task.date);

                    notifyHelper.scheduledNotification(
                      int.parse(myTime.split(":")[0]),
                      int.parse(myTime.split(":")[1]),
                      task,
                    );

                    return AnimationConfiguration.staggeredList(
                      duration: const Duration(milliseconds: 1100),
                      position: index,
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              showBottomSheet(context, task);
                            },
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.redAccent),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      //margin: const EdgeInsets.symmetric(horizontal: 10),
                                      height: 90,
                                      width: 0.5,
                                      color: Get.isDarkMode
                                          ? Colors.grey[200]!.withOpacity(0.7)
                                          : secondaryClr,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                TaskTile(task),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: _taskController.taskList.length,
              ),
            );
          }
        },
      ),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            backgroundColor: Get.isDarkMode ? darkHeaderClr : Colors.white,
            color: Get.isDarkMode ? Colors.white : darkHeaderClr,
            child: SingleChildScrollView(
              child: Wrap(
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(
                          height: 190,
                        ),
                  SvgPicture.asset(
                    "images/task.svg",
                    height: 80,
                    semanticsLabel: "Task",
                    colorFilter: ColorFilter.mode(
                        Get.isDarkMode
                            ? secondaryClr.withOpacity(0.7)
                            : primaryClr.withOpacity(0.5),
                        BlendMode.srcIn),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      "You don't have any tasks yet! \n Add new tasks to make your days productive.",
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 120,
                        )
                      : const SizedBox(
                          height: 180,
                        ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: "Task Completed",
                    onTap: () {
                      notifyHelper.cancelNotification(task);
                      _taskController.updateTasks(task.id!);
                      Get.back();
                    },
                    clr: Get.isDarkMode ? secondaryClr : primaryClr),
            _buildBottomSheet(
                label: "Delete Task",
                onTap: () {
                  notifyHelper.cancelNotification(task);
                  _taskController.deleteTasks(task);
                  Get.back();
                },
                clr: Colors.red[400]!),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
              label: "Cancel",
              onTap: () {
                Get.back();
              },
              clr: Get.isDarkMode
                  ? secondaryClr.withOpacity(0.5)
                  : primaryClr.withOpacity(0.6),
            )
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
