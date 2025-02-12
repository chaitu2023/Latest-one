import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ihl/dietDashboard/monthly_diet_activity_tab.dart';
import 'package:ihl/utils/app_colors.dart';
import 'package:ihl/views/dietJournal/apis/list_apis.dart';
import 'package:ihl/views/dietJournal/apis/log_apis.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ihl/dietDashboard/bar_chart_sample1.dart';
import 'package:ihl/dietDashboard/diet_journal_daily_diet_list.dart';
import 'package:ihl/views/dietJournal/addFood.dart';

import 'bar_chart_weekly.dart';

class DietAndActivityJournal extends StatefulWidget {
  @override
  _DietAndActivityJournalState createState() => _DietAndActivityJournalState();
}

class _DietAndActivityJournalState extends State<DietAndActivityJournal>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
    // tabController.addListener(() {
    //   if (tabController.indexIsChanging){
    //    setState(() {
    //                 // tabController.index = index;
    //                 print(tabController.index.toString());

    //               });
    //   }
    //     // Tab Changed tapping on new tab
    //   //  onTabTap();
    //   else if(tabController.index != tabController.previousIndex){
    //      setState(() {
    //                 // tabController.index = index;
    //                 print(tabController.index.toString());

    //               });
    //   }
    //     // Tab Changed swiping to a new tab
    //     // onTabDrag();
    // });
    super.initState();
  }

  ListApis listapis = ListApis();
  LogApis logapis = LogApis();
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.primaryAccentColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: SafeArea(
            child: AppBar(
                // titleSpacing: 0,
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: AppColors.primaryAccentColor,
                bottom: TabBar(
                  isScrollable: true,
                  labelPadding: EdgeInsets.all(0),
                  controller: tabController,
                  indicatorColor: Colors.transparent,
                  onTap: (index) {
                    if (this.mounted) {
                      setState(() {
                        tabController.index = index;
                      });
                    }
                  },
                  tabs: [
                    Container(
                      decoration: BoxDecoration(
                          border: border(),
                          color: tabController.index == 0
                              ? Colors.white
                              : AppColors.primaryAccentColor),
                      height: 40,
                      width: 100,
                      child: Tab(
                        child: Center(
                            child: Text(
                          'Daily',
                          style: TextStyle(color: AppColors.textitemTitleColor),
                        )),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: border(),
                          color: tabController.index == 1
                              ? Colors.white
                              : AppColors.primaryAccentColor),
                      height: 40,
                      width: 100,
                      child: Tab(
                        child: Center(
                            child: Text(
                          'Weekly',
                          style: TextStyle(color: AppColors.textitemTitleColor),
                        )),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: border(),
                          color: tabController.index == 2
                              ? Colors.white
                              : AppColors.primaryAccentColor),
                      height: 40,
                      width: 100,
                      child: Tab(
                        child: Center(
                            child: Text(
                          'Monthly',
                          style: TextStyle(color: AppColors.textitemTitleColor),
                        )),
                      ),
                    ),
                  ],
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 100.0, top: 5),
                      child: Text(
                        'Your Diet &\nActivity Journal',
                        style: TextStyle(
                            color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ),
                    // SizedBox(height: 10,),
                  ],
                )),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // listapis.autoCompleteSearchAPI();
            // listapis.ingredientDetailsApi();
            // listapis.getUserActivityLogHistoryApi();
            // listapis.getUserFoodLogHistoryApi();
            LogApis.logUserFoodIntakeApi();
            // logapis.logUserActivityApi();
            if (this.mounted) {
              setState(() {
                // calPercent = calPercent+0.20;
              });
            }
          },
          child: Icon(Icons.add),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            DailyTab(),
            WeeklyTab(),
            MonthlyDietActivityTab(),
            // PatternForwardHatchBarChart(ser),
          ],
        ),
      ),
    );
  }

  Border border() {
    return Border(
      left: BorderSide(
        color: Colors.black,
        width: 2,
      ),
      right: BorderSide(
        color: Colors.black,
        width: 2,
      ),
      top: BorderSide(
        color: Colors.black,
        width: 2,
      ),
      bottom: BorderSide(
        color: Colors.black,
        width: 2,
      ),
    );
  }
}

class DailyTab extends StatefulWidget {
  const DailyTab();

  @override
  _DailyTabState createState() => _DailyTabState();
}

class _DailyTabState extends State<DailyTab> {
  @override
  double calPercent = 0.2;
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // RaisedButton(
          //   child: Text('demo'),
          //   onPressed: (){

          // setState(() {
          //   calPercent = calPercent+0.20;
          // });

          //   }
          // ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
              Positioned(
                child: CircularPercentIndicator(
                  //  center: Text('230 Kcal'),
                  progressColor: Colors.orange,
                  radius: 179,
                  lineWidth: 16.0,
                  animation: true,
                  backgroundColor: Colors.white,
                  percent: calPercent,
                  animationDuration: 1200,
                  // footer: Text('340 Kcal 20% burn',
                  //   // "${(calPercent*100).toInt()}%",
                  //   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17.0),
                  // ),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              Positioned(
                top: 18.0,
                //  top: 18,left:106,
                //  left: 60,bottom: 85,
                child: CircularPercentIndicator(
                  circularStrokeCap: CircularStrokeCap.round,
                  radius: 148.5,
                  lineWidth: 12.0,
                  percent: 0.33,
                  center: new Text(
                    "270 / 1000 Cal",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  progressColor: Colors.green,
                  curve: Curves.bounceIn,
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 25,
          ),
          // Text('Daily Diet And Activity Journal Indicator', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17.0),),
          // SizedBox(height: 20,),
          Row(
            children: [
              Container(
                width: 15,
                height: 15,
                margin: EdgeInsets.only(left: 30, right: 10),
                decoration:
                    BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(15)),
              ),
              Text('Gained Calories'),
              Container(
                width: 15,
                height: 15,
                margin: EdgeInsets.only(left: 30, right: 5),
                decoration:
                    BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(15)),
              ),
              Text('Burn Calories')
            ],
          ),
          //             Row(
          //   children: [
          //     Container(width: 15,height: 15,margin: EdgeInsets.only(left:10,right:5),decoration: BoxDecoration(
          //       color: Colors.orange,
          //       borderRadius: BorderRadius.circular(15)
          //     ),),
          //     Text('Burn Calories')

          //   ],
          // )
          breakfastCard(),
          SizedBox(
            height: 15.0,
          ),
          lunchCard(),
          SizedBox(
            height: 15.0,
          ),
          dinnerCard(),
          SizedBox(
            height: 15.0,
          ),
          snacksCard(),
          SizedBox(
            height: 15.0,
          ),
          extrasCard(),
        ],
      ),
    );
  }

  Widget breakfastCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Breakfast",
                style: TextStyle(
                    letterSpacing: 2.0,
                    color: Color(0xfffc6111),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.local_fire_department_outlined,
                  color: Color(0xfffc6111),
                ),
                SizedBox(
                  width: 5.0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '120 ',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appTextColor),
                      ),
                      TextSpan(
                        text: "kcal ",
                        style: TextStyle(color: AppColors.appTextColor, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Container(
              width: 40.0,
              height: 40.0,
              child: RawMaterialButton(
                key: Key('journalAddBreakfast'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AddFood(mealType: "Breakfast")),
                      (Route<dynamic> route) => false);
                },
                elevation: 1.0,
                fillColor: Color(0xffe5cac2),
                child: Icon(
                  Icons.add,
                  size: 30.0,
                  color: Color(0xfffc6111),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
            child: Container(
              height: 80,
              child: Row(children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                            fit: BoxFit.fill)),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text("Salad with soup",
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              '105 cals',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
            child: Container(
              height: 80,
              child: Row(children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://images.unsplash.com/photo-1498837167922-ddd27525d352?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&w=1000&q=80'),
                            fit: BoxFit.fill)),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text("Salad with white egg",
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              '200 cals',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 8.0),
          //   child: ListTile(
          //     leading: ConstrainedBox(
          //       constraints: BoxConstraints(
          //         minWidth: 75,
          //         minHeight: 75,
          //         maxWidth: 100,
          //         maxHeight: 100,
          //       ),
          //       child: Image.network(
          //           "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNhbGFkfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80", fit: BoxFit.cover),
          //     ),
          //     // ClipRRect(
          //     //   borderRadius: BorderRadius.circular(8.0),
          //     //   child: Image.network(
          //     //     // "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/1800x1200_potassium_foods_other.jpg",
          //     //     "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNhbGFkfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
          //     //     ),
          //     // ),
          //     title: Text("Salad with soup", style: TextStyle(
          //       color: AppColors.appTextColor,
          //         fontWeight: FontWeight.bold, fontSize: 18.0
          //     ),),
          //     subtitle: Padding(
          //       padding: const EdgeInsets.only(top: 8.0),
          //       child: Text("105 cals", style: TextStyle(
          //           color: AppColors.appTextColor,
          //           fontSize: 16.0
          //       ),),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 5.0,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 8.0),
          //   child: ListTile(
          //     leading: ClipRRect(
          //       borderRadius: BorderRadius.circular(8.0),
          //       child: Image.network(
          //           "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNhbGFkfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80"
          //       ),
          //     ),
          //     title: Text("Salad with white egg", style: TextStyle(
          //         color: AppColors.appTextColor,
          //         fontWeight: FontWeight.bold, fontSize: 18.0
          //     ),),
          //     subtitle: Padding(
          //       padding: const EdgeInsets.only(top: 8.0),
          //       child: Text("200 cals", style: TextStyle(
          //           color: AppColors.appTextColor,
          //           fontSize: 16.0
          //       ),),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget lunchCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Lunch",
                style: TextStyle(
                    letterSpacing: 2.0,
                    color: AppColors.dietJournalOrange,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.local_fire_department_outlined,
                  color: AppColors.dietJournalOrange,
                ),
                SizedBox(
                  width: 5.0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '420 ',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appTextColor),
                      ),
                      TextSpan(
                        text: "Cal ",
                        style: TextStyle(color: AppColors.appTextColor, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Container(
              width: 40.0,
              height: 40.0,
              child: RawMaterialButton(
                key: Key('journalAddLunch'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AddFood(mealType: "Lunch")),
                      (Route<dynamic> route) => false);
                },
                elevation: 1.0,
                fillColor: Color(0xffe5cac2),
                child: Icon(
                  Icons.add,
                  size: 30.0,
                  color: AppColors.dietJournalOrange,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
            child: Container(
              height: 80,
              child: Row(children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg"),
                            fit: BoxFit.fill)),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text("Food Item 1",
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              '105 cals',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     child: ListTile(
          //       leading: ClipRRect(
          //         borderRadius: BorderRadius.circular(8.0),
          //         child: Image.network(
          //           "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNhbGFkfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80"
          //           ,),
          //       ),
          //       title: Text("Salad with wheat and white egg", style: TextStyle(
          //           color: AppColors.appTextColor, fontWeight: FontWeight.bold
          //       ),),
          //       subtitle: Padding(
          //         padding: const EdgeInsets.only(top: 8.0),
          //         child: Text("200 cals"),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 5.0,
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     child: ListTile(
          //       leading: ClipRRect(
          //         borderRadius: BorderRadius.circular(8.0),
          //         child: Image.network(
          //           "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNhbGFkfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80"
          //           ,),
          //       ),
          //       title: Text("Salad with wheat and white egg", style: TextStyle(
          //           color: AppColors.appTextColor, fontWeight: FontWeight.bold
          //       ),),
          //       subtitle: Padding(
          //         padding: const EdgeInsets.only(top: 8.0),
          //         child: Text("200 cals"),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget dinnerCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Dinner",
                style: TextStyle(
                    letterSpacing: 2.0,
                    color: AppColors.dietJournalOrange,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.local_fire_department_outlined,
                  color: AppColors.dietJournalOrange,
                ),
                SizedBox(
                  width: 5.0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '120 ',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appTextColor),
                      ),
                      TextSpan(
                        text: "Cal ",
                        style: TextStyle(color: AppColors.appTextColor, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Container(
              width: 40.0,
              height: 40.0,
              child: RawMaterialButton(
                key: Key('journalAddDinner'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AddFood(mealType: "Dinner")),
                      (Route<dynamic> route) => false);
                },
                elevation: 1.0,
                fillColor: Color(0xffe5cac2),
                child: Icon(
                  Icons.add,
                  size: 30.0,
                  color: AppColors.dietJournalOrange,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
            child: Container(
              height: 80,
              child: Row(children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://media.istockphoto.com/photos/top-view-table-full-of-food-picture-id1220017909?b=1&k=6&m=1220017909&s=170667a&w=0&h=yqVHUpGRq-vldcbdMjSbaDV9j52Vq8AaGUNpYBGklXs="),
                            fit: BoxFit.fill)),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text("Food Item 2",
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              '400 cals',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
            child: Container(
              height: 80,
              child: Row(children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://images2.minutemediacdn.com/image/upload/c_crop,h_1126,w_2000,x_0,y_181/f_auto,q_auto,w_1100/v1554932288/shape/mentalfloss/12531-istock-637790866.jpg"),
                            fit: BoxFit.fill)),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text("Food Item 3",
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              '155 cals',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     child: ListTile(
          //       leading: ClipRRect(
          //         borderRadius: BorderRadius.circular(8.0),
          //         child: Image.network(
          //           "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNhbGFkfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80"
          //           ,),
          //       ),
          //       title: Text("Salad with wheat and white egg", style: TextStyle(
          //           color: AppColors.appTextColor, fontWeight: FontWeight.bold
          //       ),),
          //       subtitle: Padding(
          //         padding: const EdgeInsets.only(top: 8.0),
          //         child: Text("200 cals"),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 5.0,
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     child: ListTile(
          //       leading: ClipRRect(
          //         borderRadius: BorderRadius.circular(8.0),
          //         child: Image.network(
          //           "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNhbGFkfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80"
          //           ,),
          //       ),
          //       title: Text("Salad with wheat and white egg", style: TextStyle(
          //           color: AppColors.appTextColor, fontWeight: FontWeight.bold
          //       ),),
          //       subtitle: Padding(
          //         padding: const EdgeInsets.only(top: 8.0),
          //         child: Text("200 cals"),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget snacksCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Snacks",
                style: TextStyle(
                    letterSpacing: 2.0,
                    color: AppColors.dietJournalOrange,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.local_fire_department_outlined,
                  color: AppColors.dietJournalOrange,
                ),
                SizedBox(
                  width: 5.0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '120 ',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appTextColor),
                      ),
                      TextSpan(
                        text: "Cal ",
                        style: TextStyle(color: AppColors.appTextColor, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Container(
              width: 40.0,
              height: 40.0,
              child: RawMaterialButton(
                key: Key('journalAddSnack'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AddFood(mealType: "Snacks")),
                      (Route<dynamic> route) => false);
                },
                elevation: 1.0,
                fillColor: Color(0xffe5cac2),
                child: Icon(
                  Icons.add,
                  size: 30.0,
                  color: AppColors.dietJournalOrange,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
            child: Container(
              height: 80,
              child: Row(children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://post.healthline.com/wp-content/uploads/2020/07/pizza-beer-1200x628-facebook-1200x628.jpg"),
                            fit: BoxFit.fill)),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text("Food Item 4",
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              '120 cals',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     child: ListTile(
          //       leading: ClipRRect(
          //         borderRadius: BorderRadius.circular(8.0),
          //         child: Image.network(
          //           "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNhbGFkfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80"
          //           ,),
          //       ),
          //       title: Text("Salad with wheat and white egg", style: TextStyle(
          //           color: AppColors.appTextColor, fontWeight: FontWeight.bold
          //       ),),
          //       subtitle: Padding(
          //         padding: const EdgeInsets.only(top: 8.0),
          //         child: Text("200 cals"),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 5.0,
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(8.0),
          //       child: ListTile(
          //         leading: Image.network(
          //           "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNhbGFkfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80"
          //           ,),
          //         title: Text("Salad with wheat and white egg", style: TextStyle(
          //             color: AppColors.appTextColor, fontWeight: FontWeight.bold
          //         ),),
          //         subtitle: Padding(
          //           padding: const EdgeInsets.only(top: 8.0),
          //           child: Text("200 cals"),
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget extrasCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Extras",
                style: TextStyle(
                    letterSpacing: 2.0,
                    color: AppColors.dietJournalOrange,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.local_fire_department_outlined,
                  color: AppColors.dietJournalOrange,
                ),
                SizedBox(
                  width: 5.0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '0 ',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appTextColor),
                      ),
                      TextSpan(
                        text: "Cal ",
                        style: TextStyle(color: AppColors.appTextColor, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Container(
              width: 40.0,
              height: 40.0,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AddFood(mealType: "Extras")),
                      (Route<dynamic> route) => false);
                },
                elevation: 1.0,
                fillColor: Color(0xffe5cac2),
                child: Icon(
                  Icons.add,
                  size: 30.0,
                  color: AppColors.dietJournalOrange,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyTab extends StatefulWidget {
  const WeeklyTab();

  @override
  _WeeklyTabState createState() => _WeeklyTabState();
}

class _WeeklyTabState extends State<WeeklyTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryAccentColor, // Color(0xff232040),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BarChartSample2(),
        ),
      ),
    );
  }
}
