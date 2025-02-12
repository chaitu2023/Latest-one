import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ihl/new_design/app/utils/textStyle.dart';
import 'package:ihl/new_design/presentation/pages/dashboard/common_screen_for_navigation.dart';
import 'package:ihl/new_design/presentation/pages/manageHealthscreens/healthJournalScreens/customeFoodDetailScreen.dart';
import 'package:ihl/new_design/presentation/pages/manageHealthscreens/healthJournalScreens/foodDetailScreen.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'foodLog1.dart';

class FrequentlyConsumedScreen extends StatelessWidget {
  FrequentlyConsumedScreen(
      {Key key,
      @required this.range,
      @required this.mealData,
      @required this.logDate,
      @required this.mealType,
      @required this.freqList,
      @required this.baseColor});
  final baseColor;
  final freqList;
  final mealType;
  final logDate;
  final mealData;
  final range;

  @override
  Widget build(BuildContext context) {
    DateTime _selectedDay;
    String todayDate = DateFormat("yyyy-MM-dd")
        .format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    return CommonScreenForNavigation(
        contentColor: "True",
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () async {
              Get.to(LogFoodLanding(
                mealType: mealType,
                bgColor: baseColor,
                mealData: mealData,
              ));
            }, //replaces the screen to Main dashboard
            color: Colors.white,
          ),
          title: const Text("Frequently Consumed"),
          centerTitle: true,
          backgroundColor: baseColor,
        ),
        content: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0, top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: freqList.length,
                      itemBuilder: (cntx, index) {
                        var splitedTxt = freqList[index].subtitle.split("|");

                        return InkWell(
                          onTap: () {
                            if (range) {
                              if (freqList[index].foodItemID.length < 20) {
                                Get.to(FoodDetailScreen(
                                    title: freqList[index].title ?? '',
                                    baseColor: baseColor,
                                    foodId: freqList[index].foodItemID,
                                    mealType: mealType,
                                    logDate: logDate,
                                    mealData: mealData));
                              } else {
                                Get.to(CustomeFoodDetailScreen(
                                  foodName: freqList[index].title ?? '',
                                  foodId: freqList[index].foodItemID,
                                  mealType: mealType,
                                  mealData: mealData,
                                  baseColor: baseColor,
                                  logDate: logDate,
                                ));
                              }
                            } else {}
                          },
                          child: Card(
                            elevation: 3,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 15.sp),
                              // padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 10.sp),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width:27.2.h,
                                        child: Text(
                                          freqList[index].title ?? " ",
                                          maxLines: 2,
                                          style: AppTextStyles.contentFont3,
                                        ),
                                      ),
                                      Text(splitedTxt[0],style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(splitedTxt[1],style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15.sp,
                                        color: Colors.grey,
                                      ),),
                                      Gap(20.sp),
                                      Icon(
                                        Icons.add,
                                        color: range ? baseColor : Colors.grey,
                                        size: 21.sp,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              // subtitle: Text(splitedTxt[0]),
                            ),
                          ),
                        );
                      })),
              SizedBox(
                height: 9.2.h,
              )
            ],
          ),
        ));
  }
}
