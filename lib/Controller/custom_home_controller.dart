import 'package:get/get.dart';

class CustomHomeController extends GetxController {
  static CustomHomeController instance = Get.find();
  int currentIndex = 0;
  //Make a list for dates and days one will be int and other will be string
  List<String> dates = [];
  List<String> days = [];

  void onInit() {
    super.onInit();
    getDates();
    getDays();
  }

  List getDates() {
    dates = generateDates();
    return dates;
  }

  List getDays() {
    days = generateDays();
    return days;
  }

  //genarate next five days from tomorrow
  List<String> generateDates() {
    List<String> dates = List.generate(5, (index) {
      DateTime date = DateTime.now().add(Duration(days: index + 1));
      return "${date.day}";
    });
    return dates;
  }

  // ///Genarat Dates for the last 5 days and 5 days after
  // List<String> generateDates() {
  //   List<String> dates = List.generate(5, (index) {
  //     DateTime date = DateTime.now().subtract(Duration(days: 2 - index));
  //     return "${date.day}";
  //   });
  //   return dates;
  // }

  //genarate next five days from tomorrow weekdays

  List<String> generateDays() {
    List<String> days = List.generate(5, (index) {
      DateTime date = DateTime.now().add(Duration(days: index + 1));
      String day = date.weekday == 1
          ? "Mon"
          : date.weekday == 2
              ? "Tue"
              : date.weekday == 3
                  ? "Wed"
                  : date.weekday == 4
                      ? "Thu"
                      : date.weekday == 5
                          ? "Fri"
                          : date.weekday == 6
                              ? "Sat"
                              : "Sun";
      return "${day}";
    });
    return days;
  }

  //
  // List<String> generateDays() {
  //   List<String> days = List.generate(5, (index) {
  //     DateTime date = DateTime.now().subtract(Duration(days: index + 1));
  //     String day = date.weekday == 1
  //         ? "Mon"
  //         : date.weekday == 2
  //             ? "Tue"
  //             : date.weekday == 3
  //                 ? "Wed"
  //                 : date.weekday == 4
  //                     ? "Thu"
  //                     : date.weekday == 5
  //                         ? "Fri"
  //                         : date.weekday == 6
  //                             ? "Sat"
  //                             : "Sun";
  //     return "${day}";
  //   });
  //   return days;
  // }

  // String getMonthName(int month) {
  //   const List<String> monthNames = [
  //     "Jan",
  //     "Feb",
  //     "Mar",
  //     "Apr",
  //     "May",
  //     "Jun",
  //     "July",
  //     "Aug",
  //     "Sep",
  //     "Oct",
  //     "Nov",
  //     "Dec"
  //   ];
  //   return monthNames[month - 1];
  // }
}
