import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihl/utils/app_colors.dart';
import 'package:ihl/views/dietJournal/DietJournalUI.dart';
import 'package:ihl/views/dietJournal/MealTypeScreen.dart';
import 'package:ihl/views/dietJournal/apis/list_apis.dart';
import 'package:ihl/views/dietJournal/apis/log_apis.dart';
import 'package:ihl/views/dietJournal/custom_food_detail.dart';
import 'package:ihl/views/dietJournal/models/log_user_food_intake_model.dart';
import 'package:ihl/views/dietJournal/models/view_custom_food_model.dart';
import 'package:ihl/views/dietJournal/title_widget.dart';
import 'package:ihl/widgets/customSlideButton.dart';
import 'package:loading_skeleton/loading_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strings/strings.dart';

import '../../new_design/presentation/controllers/healthJournalControllers/loadFoodList.dart';

class EditCustomFoodLogScreen extends StatefulWidget {
  final String foodItemId;
  final double quantity;
  final String foodLogTime;
  final int foodEpochTime;
  final MealsListData mealType;

  const EditCustomFoodLogScreen(
      {this.foodItemId, this.quantity, this.foodLogTime, this.foodEpochTime, this.mealType});
  @override
  _EditCustomFoodLogScreenState createState() => _EditCustomFoodLogScreenState();
}

class _EditCustomFoodLogScreenState extends State<EditCustomFoodLogScreen> {
  ListCustomRecipe foodDetail;
  TextEditingController quantityTextController = TextEditingController(text: "1");
  bool dataLoaded = false;
  bool submitted = false;
  bool deleted = false;
  bool noDataFound = false;
  String _chosenValue;
  num quantity = 1;
  bool bookmarked = false;

  @override
  void initState() {
    super.initState();
    checkbookmark();
    getDetails();
  }

  void getDetails() async {
    var details = await ListApis.customFoodDetailsApi();
    if (details.isEmpty) {
      if (this.mounted) {
        setState(() {
          dataLoaded = false;
          noDataFound = true;
        });
      }
    }
    for (int i = 0; i < details.length; i++) {
      if (widget.foodItemId == details[i].foodId) {
        if (this.mounted) {
          setState(() {
            foodDetail = details[i];
            dataLoaded = true;
            quantity = widget.quantity;
          });
        }
      }
    }
    quantity = double.parse(foodDetail.quantity);
    if (dataLoaded == false) {
      if (this.mounted) {
        setState(() {
          noDataFound = true;
        });
      }
    }
  }

  void checkbookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList("bookmarked_food");
    if (bookmarks != null) {
      bookmarked = bookmarks.contains(widget.foodItemId);
    }
  }

  void bookmarkFood() async {
    if (!bookmarked) {
      Get.snackbar('Bookmarked!', '${camelize(foodDetail.dish)} bookmarked successfully.',
          icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Icon(bookmarked ? Icons.favorite : Icons.favorite_border, color: Colors.white)),
          margin: EdgeInsets.all(20).copyWith(bottom: 40),
          backgroundColor: AppColors.primaryAccentColor,
          colorText: Colors.white,
          duration: Duration(seconds: 6),
          snackPosition: SnackPosition.BOTTOM);
      await LogApis.bookmarkFoodApi(foodItemID: widget.foodItemId).then((data) async {
        if (data != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String> bookmarks = prefs.getStringList("bookmarked_food") ?? [];
          if (!bookmarks.contains(widget.foodItemId)) {
            bookmarks.add(widget.foodItemId);
            prefs.setStringList("bookmarked_food", bookmarks);
          }
          if (this.mounted) {
            setState(() {
              bookmarked = true;
            });
          }
        } else {
          Get.snackbar('Bookmark error!', 'Try Later',
              icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite, color: Colors.white)),
              margin: EdgeInsets.all(20).copyWith(bottom: 40),
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          bookmarked = false;
        }
      });
    } else {
      Get.snackbar('Bookmark Removed!', '${camelize(foodDetail.dish)} removed from your bookmarks.',
          icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Icon(bookmarked ? Icons.favorite : Icons.favorite_border, color: Colors.white)),
          margin: EdgeInsets.all(20).copyWith(bottom: 40),
          backgroundColor: AppColors.primaryAccentColor,
          colorText: Colors.white,
          duration: Duration(seconds: 6),
          snackPosition: SnackPosition.BOTTOM);
      await LogApis.deleteBookmarkFoodApi(foodItemID: widget.foodItemId).then((data) async {
        if (data != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String> bookmarks = prefs.getStringList("bookmarked_food") ?? [];
          if (bookmarks.contains(widget.foodItemId)) {
            bookmarks.remove(widget.foodItemId);
            prefs.setStringList("bookmarked_food", bookmarks);
          }
          if (this.mounted) {
            setState(() {
              bookmarked = false;
            });
          }
        } else {
          Get.snackbar('Bookmark not removed!', 'Try Later',
              icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite, color: Colors.white)),
              margin: EdgeInsets.all(20).copyWith(bottom: 40),
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          bookmarked = true;
        }
      });
    }
  }

  Widget noData() {
    return DietJournalUI(
      topColor: widget.mealType != null
          ? HexColor(widget.mealType.startColor)
          : AppColors.primaryAccentColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: LoadingSkeleton(
            width: 200,
            height: 20,
            colors: [Colors.grey, Colors.grey[300], Colors.grey],
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: LoadingSkeleton(
                  width: 400,
                  height: 250,
                  colors: [Colors.grey, Colors.grey[300], Colors.grey],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: LoadingSkeleton(
                  width: 400,
                  height: 150,
                  colors: [Colors.grey, Colors.grey[300], Colors.grey],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: LoadingSkeleton(
                width: 350,
                height: 100,
                colors: [Colors.grey, Colors.grey[300], Colors.grey],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget foodCard(String titleTxt, String subTxt) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleView(
            titleTxt: camelize(foodDetail.dish),
            subTxt: 'View detail',
            onTap: () {
              Get.delete<FoodDataLoaderController>();
              Get.to(CustomFoodDetailScreen(
                foodDetail,
                viewOnly: true,
                mealType: widget.mealType,
              ));
            },
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today ${widget.foodLogTime.substring(11, 16)}",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Center(
            child: Column(
              children: <Widget>[
                Text(
                  calculateCalories(foodDetail.calories, quantity.toString()).toStringAsFixed(0),
                  style: TextStyle(
                    color: widget.mealType != null
                        ? HexColor(widget.mealType.startColor)
                        : AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                Text(
                  "Cal",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 180,
                child: CustomSlideButton(
                  backGroundColor: Colors.black12.withOpacity(0.2),
                  initialValue: widget.quantity,
                  speedTransitionLimitCount: 3,
                  firstIncrementDuration: Duration(milliseconds: 300),
                  secondIncrementDuration: Duration(milliseconds: 100),
                  direction: Axis.horizontal,
                  dragButtonColor: widget.mealType != null
                      ? HexColor(widget.mealType.startColor)
                      : AppColors.primaryColor,
                  withSpring: true,
                  maxValue: 20,
                  minValue: widget.quantity,
                  withBackground: true,
                  withPlusMinus: true,
                  iconsColor: widget.mealType != null
                      ? HexColor(widget.mealType.startColor)
                      : AppColors.primaryColor,
                  //withFastCount: true,
                  stepperValue: quantity,
                  onChanged: (double val) {
                    if (this.mounted) {
                      setState(() {
                        quantity = val;
                        if (val != widget.quantity || double.parse(foodDetail.quantity) > 1.0) {
                          _chosenValue = 'true';
                        } else {
                          _chosenValue = null;
                        }
                      });
                    }
                  },
                  editMeal: true,
                ),
              ),
              Text(
                camelize(foodDetail.servingUnitSize ?? 'Nos.'),
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  num calculateCalories(String defaultCalories, String quantity) {
    if (quantity != null) {
      if (double.parse(foodDetail.quantity) > 1.0) {
        return ((double.parse(defaultCalories) / double.parse(foodDetail.quantity)) *
            double.parse(quantity));
      }
      return (double.parse(defaultCalories) * double.parse(quantity));
    } else {
      return double.parse(defaultCalories);
    }
  }

  @override
  Widget build(BuildContext context) {
    return dataLoaded
        ? IgnorePointer(
            ignoring: deleted,
            child: DietJournalUI(
              topColor: widget.mealType != null
                  ? HexColor(widget.mealType.startColor)
                  : AppColors.primaryAccentColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: FitnessAppTheme.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: AutoSizeText(
                  'Edit Food Log',
                  style: TextStyle(fontSize: 24.0, color: FitnessAppTheme.white),
                  maxLines: 1,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(
                        bookmarked ? Icons.favorite : Icons.favorite_border,
                        color: FitnessAppTheme.white,
                      ),
                      onPressed: () {
                        bookmarkFood();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: FitnessAppTheme.white,
                      ),
                      onPressed: () {
                        deleteMeal();
                      },
                    ),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(0.1, 0.1),
                              blurRadius: 18,
                            )
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            'https://static.vecteezy.com/system/resources/previews/000/463/565/non_2x/healthy-food-clipart-vector.jpg',
                            fit: BoxFit.fill,
                          ),
                        )),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: foodCard(foodDetail.dish, foodDetail.quantity),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
              fab: IgnorePointer(
                ignoring: submitted,
                child: Visibility(
                  visible: _chosenValue != null ? true : false,
                  child: FloatingActionButton.extended(
                      onPressed: () {
                        logMeal();
                      },
                      backgroundColor: widget.mealType != null
                          ? HexColor(widget.mealType.startColor)
                          : AppColors.primaryAccentColor,
                      label: Text(
                        'Change Log',
                        style: TextStyle(color: FitnessAppTheme.white),
                      ),
                      icon: Icon(
                        Icons.set_meal,
                        color: FitnessAppTheme.white,
                      )),
                ),
              ),
            ),
          )
        : noDataFound
            ? IgnorePointer(
                ignoring: deleted,
                child: DietJournalUI(
                  topColor: widget.mealType != null
                      ? HexColor(widget.mealType.startColor)
                      : AppColors.primaryAccentColor,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: AutoSizeText(
                      'Edit Food Log',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteMeal();
                          },
                        ),
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                            height: 200,
                            width: 300,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300],
                                  offset: Offset(0.1, 0.1),
                                  blurRadius: 18,
                                )
                              ],
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                'https://static.vecteezy.com/system/resources/previews/000/463/565/non_2x/healthy-food-clipart-vector.jpg',
                                fit: BoxFit.fill,
                              ),
                            )),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "This food item not found in the database.\nSo, you cannot update this food but can delete it.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                  fab: IgnorePointer(
                    ignoring: submitted,
                    child: Visibility(
                      visible: _chosenValue != null ? true : false,
                      child: FloatingActionButton.extended(
                          onPressed: () {
                            logMeal();
                          },
                          backgroundColor: widget.mealType != null
                              ? HexColor(widget.mealType.startColor)
                              : AppColors.primaryAccentColor,
                          label: Text(
                            'Change Log',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          icon: Icon(
                            Icons.set_meal,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              )
            : noData();
  }

  void logMeal() async {
    if (this.mounted) {
      setState(() {
        submitted = true;
      });
    }
    var fooddetail = FoodDetail(
        foodId: widget.foodItemId,
        foodName: foodDetail.dish,
        foodQuantity: quantity.toString(),
        quantityUnit: foodDetail.servingUnitSize);
    var logFood = await prepareForLog(fooddetail);
    LogApis.editUserFoodLogApi(data: logFood).then((value) {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            submitted = false;
          });
        }
        ListApis.getUserTodaysFoodLogApi(widget.mealType.type).then((value) {
          Get.to(MealTypeScreen(
            mealsListData: value,
            cardioNavigate: false,
          ));
        });
        Get.snackbar('Changes Logged!', '${camelize(foodDetail.dish)} logged successfully.',
            icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.check_circle, color: Colors.white)),
            margin: EdgeInsets.all(20).copyWith(bottom: 40),
            backgroundColor: AppColors.primaryAccentColor,
            colorText: Colors.white,
            duration: Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM);
      } else {
        if (this.mounted) {
          setState(() {
            submitted = false;
          });
        }
        Get.close(1);
        Get.snackbar('Log not Changed', 'Encountered some error while logging. Please try again',
            icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.cancel_rounded, color: Colors.white)),
            margin: EdgeInsets.all(20).copyWith(bottom: 40),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }

  void deleteMeal() async {
    if (this.mounted) {
      setState(() {
        deleted = true;
      });
    }
    var logFood = await deleteLog();
    LogApis.editUserFoodLogApi(data: logFood).then((value) {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            deleted = false;
          });
        }
        ListApis.getUserTodaysFoodLogApi(widget.mealType.type).then((value) {
          Get.to(MealTypeScreen(
            mealsListData: value,
            cardioNavigate: false,
          ));
        });
        Get.snackbar('Log Deleted', '${camelize(foodDetail.dish)} deleted successfully.',
            icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.check_circle, color: Colors.white)),
            margin: EdgeInsets.all(20).copyWith(bottom: 40),
            backgroundColor: AppColors.primaryAccentColor,
            colorText: Colors.white,
            duration: Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM);
      } else {
        if (this.mounted) {
          setState(() {
            submitted = false;
          });
        }
        Get.close(1);
        Get.snackbar('Log not Deleted', 'Encountered some error while deleted. Please try later',
            icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.cancel_rounded, color: Colors.white)),
            margin: EdgeInsets.all(20).copyWith(bottom: 40),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }

  Future<EditLogUserFood> deleteLog() async {
    final prefs = await SharedPreferences.getInstance();
    String iHLUserId = prefs.getString('ihlUserId');
    return EditLogUserFood(
        userIhlId: iHLUserId,
        foodLogTime: widget.foodLogTime,
        epochLogTime: widget.foodEpochTime,
        foodTimeCategory: widget.mealType.type,
        caloriesGained: '0',
        food: []);
  }

  Future<EditLogUserFood> prepareForLog(FoodDetail fooddetail) async {
    final prefs = await SharedPreferences.getInstance();
    String iHLUserId = prefs.getString('ihlUserId');
    return EditLogUserFood(
        userIhlId: iHLUserId,
        foodLogTime: widget.foodLogTime,
        epochLogTime: widget.foodEpochTime,
        foodTimeCategory: widget.mealType.type,
        caloriesGained:
            calculateCalories(foodDetail.calories, quantity.toString()).toStringAsFixed(0),
        food: [
          Food(foodDetails: [fooddetail])
        ]);
  }
}
