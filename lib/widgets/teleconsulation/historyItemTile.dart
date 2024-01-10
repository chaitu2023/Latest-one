import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ihl/Getx/controller/ConsultationHistoryController.dart';
import 'package:ihl/constants/api.dart';
import 'package:ihl/constants/spKeys.dart';
import 'package:ihl/utils/screenutil.dart';
import 'package:ihl/utils/app_colors.dart';
import 'package:ihl/views/teleconsultation/consultationHistory.dart';
import 'package:ihl/views/teleconsultation/consultation_history_summary.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strings/strings.dart';

///Consultation History tile 🕓
class HistoryItem extends StatefulWidget {
  final int index;
  final String appointId;
  final String appointmentStartTime;
  final String appointmentEndTime;
  final String consultantName;
  final String consultationFees;
  final String appointmentStatus;
  final String callStatus;

  HistoryItem(
      {this.index,
      this.appointId,
      this.appointmentStartTime,
      this.appointmentEndTime,
      this.consultantName,
      this.consultationFees,
      this.appointmentStatus,
      this.callStatus});

  @override
  _HistoryItemState createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  http.Client _client = http.Client(); //3gb
  bool makeValidateVisible = false;

  var currentDateTime = new DateTime.now();
  var appointmentStartingTime;
  var appointmentEndingTime;

  String currentAppointmentStatus;
  bool isChecking = false;
  final reasonController = TextEditingController();
  String iHLUserId;

  @override
  void initState() {
    super.initState();
    convertStringToDateTime();
  }

  convertStringToDateTime() {
    String appointmentStartTime1 = widget.appointmentStartTime;

    if (appointmentStartTime1 != "" ||
        appointmentStartTime1 != null ||
        widget.appointmentStartTime != null ||
        widget.appointmentStartTime != "") {
      if (appointmentStartTime1[7] != '-') {
        String appEndTime = '';
        for (var i = 0; i < appointmentStartTime1.length; i++) {
          if (i == 5) {
            appEndTime += '0' + appointmentStartTime1[i];
          } else {
            appEndTime += appointmentStartTime1[i];
          }
        }
        appointmentStartTime1 = appEndTime;
      }
      if (appointmentStartTime1[10] != " ") {
        String appEndTime = '';
        for (var i = 0; i < appointmentStartTime1.length; i++) {
          if (i == 8) {
            appEndTime += '0' + appointmentStartTime1[i];
          } else {
            appEndTime += appointmentStartTime1[i];
          }
        }
        appointmentStartTime1 = appEndTime;
      }
    }

    String appointmentStartstringTime = appointmentStartTime1.substring(11, 19);
    String appointmentStartTime = appointmentStartTime1.substring(0, 10);
    DateTime startTimeformattime = DateFormat.jm().parse(appointmentStartstringTime);
    String starttime = DateFormat("HH:mm:ss").format(startTimeformattime);
    String appointmentStartdateToFormat = appointmentStartTime + " " + starttime;
    appointmentStartingTime = DateTime.parse(appointmentStartdateToFormat);

    String appointmentEndTime1 = widget.appointmentEndTime;

    if (appointmentEndTime1[7] != '-') {
      String appEndTime = '';
      for (var i = 0; i < appointmentEndTime1.length; i++) {
        if (i == 5) {
          appEndTime += '0' + appointmentEndTime1[i];
        } else {
          appEndTime += appointmentEndTime1[i];
        }
      }
      appointmentEndTime1 = appEndTime;
    }
    if (appointmentEndTime1[10] != " ") {
      String appEndTime = '';
      for (var i = 0; i < appointmentEndTime1.length; i++) {
        if (i == 8) {
          appEndTime += '0' + appointmentEndTime1[i];
        } else {
          appEndTime += appointmentEndTime1[i];
        }
      }
      appointmentEndTime1 = appEndTime;
    }

    String appointmentEndstringTime = appointmentEndTime1.substring(11, 19);
    String appointmentEndTime = appointmentEndTime1.substring(0, 10);
    DateTime endTimeformattime = DateFormat.jm().parse(appointmentEndstringTime);
    String endtime = DateFormat("HH:mm:ss").format(endTimeformattime);
    String appointmentEndDateToFormat = appointmentEndTime + " " + endtime;
    appointmentEndingTime = DateTime.parse(appointmentEndDateToFormat);
  }

  void cancelAppointment(var canceledBy, var appointId, var reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var data = prefs.get('data');
    Map res = jsonDecode(data);
    iHLUserId = res['User']['id'];
    var transcationId;
    var apiToken = prefs.get('auth_token');

    final response = await _client.post(
      Uri.parse(API.iHLUrl + '/consult/cancel_appointment'),
      headers: {'ApiToken': apiToken},
      body: jsonEncode(<String, dynamic>{
        "canceled_by": canceledBy.toString(),
        "ihl_appointment_id": appointId.toString(),
        "reason": reason.toString(),
      }),
    );
    if (response.statusCode == 200) {
      if (response.body != '"[]"') {
        var parsedString = response.body.replaceAll('&quot', '"');
        var parsedString1 = parsedString.replaceAll(";", "");
        var parsedString2 = parsedString1.replaceAll('"[', '[');
        var parsedString3 = parsedString2.replaceAll(']"', ']');
        var finalOutput = json.decode(parsedString3);
        var status = finalOutput["status"];
        var refundAmount = finalOutput["refund_amount"];
        if (status == "cancel_success") {
          final transresponce = await _client.get(
              Uri.parse(API.iHLUrl + "/consult/user_transaction_from_ihl_id?ihl_id=" + iHLUserId));
          if (transresponce.statusCode == 200) {
            if (transresponce.body != "[]" || transresponce.body != null) {
              var transcationList = json.decode(transresponce.body);
              for (int i = 0; i <= transcationList.length - 1; i++) {
                if (transcationList[i]["ihl_appointment_id"] == appointId) {
                  transcationId = transcationList[i]["transaction_id"];
                }
              }
              final responsetrans = await _client.get(Uri.parse(API.iHLUrl +
                  '/consult/update_refund_status?transaction_id=' +
                  transcationId +
                  '&refund_status=Initated'));
              if (responsetrans.statusCode == 200) {
                if (responsetrans.body == '"Refund Status Update Success"') {
                  // Updating getUserDetails API

                  if (this.mounted) {
                    setState(() {
                      isChecking = false;
                    });
                  }
                  callStatusUpdate(widget.appointId, "Completed");
                  AwesomeDialog(
                          context: context,
                          animType: AnimType.TOPSLIDE,
                          headerAnimationLoop: true,
                          dialogType: DialogType.SUCCES,
                          dismissOnTouchOutside: false,
                          title: 'Success!',
                          desc: 'Your refund is initiated for the amount Rs ' + refundAmount,
                          btnOkOnPress: () {
                            final ConsultationHistoryController _con = Get.find();
                            _con.getConsultationHistory(10, null);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => ConsultHistory()),
                                (Route<dynamic> route) => false);
                          },
                          btnOkColor: Colors.green,
                          btnOkText: 'Proceed',
                          btnOkIcon: Icons.check,
                          onDismissCallback: (_) {})
                      .show();
                } else {
                  errorDialog();
                }
              } else {
                errorDialog();
              }
            } else {
              errorDialog();
            }
          } else {
            errorDialog();
          }
        } else {
          errorDialog();
        }
      } else {
        errorDialog();
      }
    } else {
      errorDialog();
    }
  }

  errorDialog() {
    AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            headerAnimationLoop: true,
            dialogType: DialogType.ERROR,
            dismissOnTouchOutside: false,
            title: 'Failed!',
            desc: 'Getting Refund Failed!\nPlease try again ...',
            btnOkOnPress: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ConsultHistory()),
                  (Route<dynamic> route) => false);
            },
            btnOkColor: Colors.red,
            btnOkText: 'Proceed',
            btnOkIcon: Icons.refresh,
            onDismissCallback: (_) {})
        .show();
  }

  callStatusUpdate(String appointmentID, String appStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiToken = prefs.get('auth_token');
    final response = await _client.get(
      Uri.parse(API.iHLUrl +
          '/consult/update_call_status?appointment_id=' +
          appointmentID +
          '&call_status=' +
          appStatus),
      headers: {'ApiToken': apiToken},
    );
    var parsedString = response.body.replaceAll('&quot', '"');
    var parsedString1 = parsedString.replaceAll(";", "");
    var parsedString2 = parsedString1.replaceAll('"{', '{');
    var parsedString3 = parsedString2.replaceAll('}"', '}');
    var callStatusUpdate = json.decode(parsedString3);
    String apiResponse = callStatusUpdate['status'].toString();
    if (apiResponse == 'Update Sucessfull') {
      currentAppointmentStatusUpdate(widget.appointId, 'Completed');
    } else {}
  }

  currentAppointmentStatusUpdate(String appointmentID, String appStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiToken = prefs.get('auth_token');
    final response = await _client.get(
      Uri.parse(API.iHLUrl +
          '/consult/update_appointment_status?appointment_id=' +
          appointmentID +
          '&appointment_status=' +
          appStatus),
      headers: {'ApiToken': apiToken},
    );
    var parsedString = response.body.replaceAll('&quot', '"');
    var parsedString1 = parsedString.replaceAll(";", "");
    var parsedString2 = parsedString1.replaceAll('"{', '{');
    var parsedString3 = parsedString2.replaceAll('}"', '}');
    var currentAppointmentStatusUpdate = json.decode(parsedString3);
    if (currentAppointmentStatusUpdate == 'Database Updated') {
      if (this.mounted) {
        setState(() {
          currentAppointmentStatus = appStatus;
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      elevation: 2,
      // borderOnForeground: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
          side: BorderSide(
            width: 1,
            color: FitnessAppTheme.nearlyWhite,
          )),
      child: InkWell(
        onTap: () {
          print(widget.appointId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConsultationHistorySummary(
                appointmentId: widget.appointId,
              ),
            ),
          );
        },
        splashColor: AppColors.startConsult.withOpacity(0.5),
        child: ListTile(
          leading: Icon(
            FontAwesomeIcons.video,
            color: AppColors.startConsult,
          ),
          title: Text(
            camelize(widget.consultantName == null ? "N/A" : widget.consultantName) ?? 'Consultant',
          ),
          trailing: Icon(
            Icons.info,
            color: Colors.blue,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 3.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        widget.appointmentStartTime == null
                            ? "N/A"
                            : widget.appointmentStartTime ?? 'N/A',
                        style: TextStyle(fontSize: ScUtil().setSp(14)),
                        textAlign: TextAlign.justify),
                  ),
                ],
              ),
              SizedBox(
                height: 3.0,
              ),
              Row(
                children: [
                  Text("Appointment: ", style: TextStyle(fontSize: ScUtil().setSp(14))),
                  Text(
                      widget.appointmentStatus != null
                          ? camelize(widget.appointmentStatus)
                          : "N/A" ?? 'N/A',
                      style: TextStyle(fontSize: ScUtil().setSp(14)),
                      textAlign: TextAlign.justify),
                ],
              ),
              SizedBox(
                height: 3.0,
              ),
              Row(
                children: [
                  Text("Call Status: ", style: TextStyle(fontSize: ScUtil().setSp(14))),
                  Text(widget.callStatus != null ? camelize(widget.callStatus) : "N/A" ?? 'N/A',
                      style: TextStyle(fontSize: ScUtil().setSp(14)), textAlign: TextAlign.justify),
                ],
              ),
              SizedBox(
                height: 3.0,
              ),
              ((widget.callStatus == "N/A" ||
                          widget.callStatus == "Missed" ||
                          widget.callStatus == "missed") &&
                      appointmentStartingTime.isBefore(currentDateTime))
                  ? Visibility(
                      visible: widget.appointmentStatus == "Canceled" ||
                              widget.appointmentStatus == "canceled" ||
                              widget.appointmentStatus == "Completed" ||
                              widget.appointmentStatus == "completed" ||
                              widget.consultationFees == "0"
                          ? false
                          : true,
                      child: Column(
                        children: [
                          ButtonTheme(
                            minWidth: 300.0,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  primary: AppColors.primaryColor,
                                ),
                                child: Text('Refund',
                                    style: TextStyle(
                                      fontSize: 16,
                                    )),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String reasonRadioBtnVal = "";
                                      final _formKey = GlobalKey<FormState>();
                                      return WillPopScope(
                                        onWillPop: () async => false,
                                        child: AlertDialog(
                                            title: Text(
                                              'Provide the reason for Refund!',
                                              style: TextStyle(color: AppColors.primaryColor),
                                              textAlign: TextAlign.center,
                                            ),
                                            content: StatefulBuilder(
                                              builder:
                                                  (BuildContext context, StateSetter setState) {
                                                return SingleChildScrollView(
                                                  child: Form(
                                                    key: _formKey,
                                                    child: Column(
                                                      children: [
                                                        Column(
                                                          children: <Widget>[
                                                            Row(
                                                              children: [
                                                                new Radio<String>(
                                                                  value:
                                                                      "Consultant didn\'t joined the call",
                                                                  groupValue: reasonRadioBtnVal,
                                                                  onChanged: (String value) {
                                                                    if (this.mounted) {
                                                                      setState(() {
                                                                        reasonRadioBtnVal = value;
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                                Expanded(
                                                                  child: new Text(
                                                                    'Consultant didn\'t joined the call',
                                                                    style: new TextStyle(
                                                                        fontSize: 16.0),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                new Radio<String>(
                                                                  value:
                                                                      "You were facing technical issue",
                                                                  groupValue: reasonRadioBtnVal,
                                                                  onChanged: (String value) {
                                                                    if (this.mounted) {
                                                                      setState(() {
                                                                        reasonRadioBtnVal = value;
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                                Expanded(
                                                                  child: new Text(
                                                                    'You were facing technical issue',
                                                                    style: new TextStyle(
                                                                      fontSize: 16.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                new Radio<String>(
                                                                  value:
                                                                      'You didn\'t joined the call',
                                                                  groupValue: reasonRadioBtnVal,
                                                                  onChanged: (String value) {
                                                                    if (this.mounted) {
                                                                      setState(() {
                                                                        reasonRadioBtnVal = value;
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                                Expanded(
                                                                  child: new Text(
                                                                    'You didn\'t joined the call',
                                                                    style: new TextStyle(
                                                                        fontSize: 16.0),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                new Radio<String>(
                                                                  value:
                                                                      'Consultant was facing technical issue',
                                                                  groupValue: reasonRadioBtnVal,
                                                                  onChanged: (String value) {
                                                                    if (this.mounted) {
                                                                      setState(() {
                                                                        reasonRadioBtnVal = value;
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                                Expanded(
                                                                  child: new Text(
                                                                    'Consultant was facing technical issue',
                                                                    style: new TextStyle(
                                                                        fontSize: 16.0),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            TextFormField(
                                                              controller: reasonController,
                                                              validator: (value) {
                                                                if (value.isEmpty) {
                                                                  return 'Please provide the reason!';
                                                                }
                                                                return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical: 15,
                                                                        horizontal: 18),
                                                                labelText: "Other reason",
                                                                fillColor: Colors.white24,
                                                                border: new OutlineInputBorder(
                                                                    borderRadius:
                                                                        new BorderRadius.circular(
                                                                            15.0),
                                                                    borderSide: new BorderSide(
                                                                        color: Colors.blueGrey)),
                                                              ),
                                                              maxLines: 1,
                                                              textInputAction: TextInputAction.done,
                                                            ),
                                                          ],
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              makeValidateVisible ? true : false,
                                                          child: Text(
                                                            "Please select the reason!",
                                                            style: TextStyle(color: Colors.red),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                primary: Color(0xff4393cf),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(10.0),
                                                                    side: BorderSide(
                                                                        color: Color(0xff4393cf))),
                                                              ),
                                                              child: Text(
                                                                'Go Back',
                                                                style:
                                                                    TextStyle(color: Colors.white),
                                                              ),
                                                              onPressed: isChecking == true
                                                                  ? null
                                                                  : () {
                                                                      Navigator.pop(context);
                                                                    },
                                                            ),
                                                            ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                      side: BorderSide(
                                                                          color: AppColors
                                                                              .primaryColor)),
                                                                  primary: Color(0xff4393cf),
                                                                ),
                                                                child: isChecking == true
                                                                    ? SizedBox(
                                                                        height: 20.0,
                                                                        width: 20.0,
                                                                        child:
                                                                            new CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<
                                                                                      Color>(
                                                                                  Colors.white),
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        'Get Refund',
                                                                        style: TextStyle(
                                                                            color: Colors.white),
                                                                      ),
                                                                onPressed: isChecking == true
                                                                    ? null
                                                                    : () {
                                                                        if (reasonRadioBtnVal
                                                                            .isNotEmpty) {
                                                                          if (this.mounted) {
                                                                            setState(() {
                                                                              isChecking = true;
                                                                              makeValidateVisible =
                                                                                  false;
                                                                            });
                                                                          }
                                                                          cancelAppointment(
                                                                              "user",
                                                                              widget.appointId,
                                                                              reasonRadioBtnVal);
                                                                        } else if (reasonController
                                                                            .text.isNotEmpty) {
                                                                          if (this.mounted) {
                                                                            setState(() {
                                                                              isChecking = true;
                                                                              makeValidateVisible =
                                                                                  false;
                                                                            });
                                                                          }
                                                                          cancelAppointment(
                                                                              "user",
                                                                              widget.appointId,
                                                                              reasonController
                                                                                  .text);
                                                                        } else {
                                                                          if (this.mounted) {
                                                                            setState(() {
                                                                              makeValidateVisible =
                                                                                  true;
                                                                            });
                                                                          }
                                                                        }
                                                                      }),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )),
                                      );
                                    },
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          //Refund policy
                          /*GestureDetector(
                            onTap: () => refundDialogBox(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Refund Policy",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                      decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  refundDialogBox() {
    _buildChild(BuildContext context) => Container(
          height: MediaQuery.of(context).size.height / 1.25,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Refund Policy",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12), topRight: Radius.circular(12))),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cancellation Time",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        Text(
                          "Refund",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("x_hours"),
                        Text("_"),
                      ],
                    ),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("refund_perenct_\nbefore_x_hours"),
                        Text("50%"),
                      ],
                    ),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("refund_perenct_\nafter_x_hours"),
                        Text("30%"),
                      ],
                    ),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("refund_perenct_\nfor_customer_noshow"),
                        Text("0%"),
                      ],
                    ),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("refund_perenct_for_\nconsultant_cancel_\nbefore_appointment"),
                        Text("100%"),
                      ],
                    ),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("refund_percent_for_\nconsultant_no_show"),
                        Text("100%"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: AppColors.primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 13.0, bottom: 13.0, right: 15, left: 15),
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: _buildChild(context),
          );
        });
  }
}
