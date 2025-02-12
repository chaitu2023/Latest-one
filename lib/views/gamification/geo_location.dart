// import 'dart:async';
// import 'dart:io' show Platform;
//
// // import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// /// Defines the main theme color.
// // final MaterialColor themeMaterialColor =
// // BaseflowPluginExample.createMaterialColor(
// //     const Color.fromRGBO(48, 49, 60, 1));
// //
// // void main() {
// //   runApp(const GeolocatorWidget());
// // }
//
// /// Example [Widget] showing the functionalities of the geolocator plugin
// class GeolocatorWidget extends StatefulWidget {
//   /// Creates a new GeolocatorWidget.
//   const GeolocatorWidget();
//
//   /// Utility method to create a page with the Baseflow templating.
//   static ExamplePage createPage() {
//     return ExamplePage(
//         Icons.location_on, (context) => const GeolocatorWidget());
//   }
//
//   @override
//   _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
// }
//
// class _GeolocatorWidgetState extends State<GeolocatorWidget> {
//   static const String _kLocationServicesDisabledMessage =
//       'Location services are disabled.';
//   static const String _kPermissionDeniedMessage = 'Permission denied.';
//   static const String _kPermissionDeniedForeverMessage =
//       'Permission denied forever.';
//   static const String _kPermissionGrantedMessage = 'Permission granted.';
//
//   final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
//   final List<_PositionItem> _positionItems = <_PositionItem>[];
//   StreamSubscription<Position> _positionStreamSubscription;
//   StreamSubscription<ServiceStatus> _serviceStatusStreamSubscription;
//   bool positionStreamStarted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _toggleServiceStatusStream();
//   }
//
//   PopupMenuButton _createActions() {
//     return PopupMenuButton(
//       elevation: 40,
//       onSelected: (value) async {
//         switch (value) {
//           case 1:
//             _getLocationAccuracy();
//             break;
//           case 2:
//             _requestTemporaryFullAccuracy();
//             break;
//           case 3:
//             _openAppSettings();
//             break;
//           case 4:
//             _openLocationSettings();
//             break;
//           case 5:
//             setState(_positionItems.clear);
//             break;
//           default:
//             break;
//         }
//       },
//       itemBuilder: (context) => [
//         if (Platform.isIOS)
//           const PopupMenuItem(
//             child: Text("Get Location Accuracy"),
//             value: 1,
//           ),
//         if (Platform.isIOS)
//           const PopupMenuItem(
//             child: Text("Request Temporary Full Accuracy"),
//             value: 2,
//           ),
//         const PopupMenuItem(
//           child: Text("Open App Settings"),
//           value: 3,
//         ),
//         if (Platform.isAndroid)
//           const PopupMenuItem(
//             child: Text("Open Location Settings"),
//             value: 4,
//           ),
//         const PopupMenuItem(
//           child: Text("Clear"),
//           value: 5,
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const sizedBox = SizedBox(
//       height: 10,
//     );
//
//     return BaseflowPluginExample(
//         pluginName: 'Geolocator',
//         githubURL: 'https://github.com/Baseflow/flutter-geolocator',
//         pubDevURL: 'https://pub.dev/packages/geolocator',
//         appBarActions: [
//           _createActions()
//         ],
//         pages: [
//           ExamplePage(
//             Icons.location_on,
//                 (context) => Scaffold(
//               backgroundColor: Theme.of(context).backgroundColor,
//               body: ListView.builder(
//                 itemCount: _positionItems.length,
//                 itemBuilder: (context, index) {
//                   final positionItem = _positionItems[index];
//
//                   if (positionItem.type == _PositionItemType.log) {
//                     return ListTile(
//                       title: Text(positionItem.displayValue,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           )),
//                     );
//                   } else {
//                     return Card(
//                       child: ListTile(
//                         // tileColor: themeMaterialColor,
//                         title: Text(
//                           positionItem.displayValue,
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     );
//                   }
//                 },
//               ),
//               floatingActionButton: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   FloatingActionButton(
//                     child: (_positionStreamSubscription == null ||
//                         _positionStreamSubscription.isPaused)
//                         ? const Icon(Icons.play_arrow)
//                         : const Icon(Icons.pause),
//                     onPressed: () {
//                       positionStreamStarted = !positionStreamStarted;
//                       _toggleListening();
//                     },
//                     tooltip: (_positionStreamSubscription == null)
//                         ? 'Start position updates'
//                         : _positionStreamSubscription.isPaused
//                         ? 'Resume'
//                         : 'Pause',
//                     backgroundColor: _determineButtonColor(),
//                   ),
//                   sizedBox,
//                   FloatingActionButton(
//                     child: const Icon(Icons.my_location),
//                     onPressed: _getCurrentPosition,
//                   ),
//                   sizedBox,
//                   FloatingActionButton(
//                     child: const Icon(Icons.bookmark),
//                     onPressed: _getLastKnownPosition,
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ]);
//   }
//
//   Future<void> _getCurrentPosition() async {
//     final hasPermission = await _handlePermission();
//
//     if (!hasPermission) {
//       return;
//     }
//
//     final position = await _geolocatorPlatform.getCurrentPosition();
//     _updatePositionList(
//       _PositionItemType.position,
//       position.toString(),
//     );
//   }
//
//   Future<bool> _handlePermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       _updatePositionList(
//         _PositionItemType.log,
//         _kLocationServicesDisabledMessage,
//       );
//
//       return false;
//     }
//
//     permission = await _geolocatorPlatform.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await _geolocatorPlatform.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         _updatePositionList(
//           _PositionItemType.log,
//           _kPermissionDeniedMessage,
//         );
//
//         return false;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       _updatePositionList(
//         _PositionItemType.log,
//         _kPermissionDeniedForeverMessage,
//       );
//
//       return false;
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     _updatePositionList(
//       _PositionItemType.log,
//       _kPermissionGrantedMessage,
//     );
//     return true;
//   }
//
//   void _updatePositionList(_PositionItemType type, String displayValue) {
//     _positionItems.add(_PositionItem(type, displayValue));
//     setState(() {});
//   }
//
//   bool _isListening() => !(_positionStreamSubscription == null ||
//       _positionStreamSubscription!.isPaused);
//
//   Color _determineButtonColor() {
//     return _isListening() ? Colors.green : Colors.red;
//   }
//
//   void _toggleServiceStatusStream() {
//     if (_serviceStatusStreamSubscription == null) {
//       final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
//       _serviceStatusStreamSubscription =
//           serviceStatusStream.handleError((error) {
//             _serviceStatusStreamSubscription?.cancel();
//             _serviceStatusStreamSubscription = null;
//           }).listen((serviceStatus) {
//             String serviceStatusValue;
//             if (serviceStatus == ServiceStatus.enabled) {
//               if (positionStreamStarted) {
//                 _toggleListening();
//               }
//               serviceStatusValue = 'enabled';
//             } else {
//               if (_positionStreamSubscription != null) {
//                 setState(() {
//                   _positionStreamSubscription?.cancel();
//                   _positionStreamSubscription = null;
//                   _updatePositionList(
//                       _PositionItemType.log, 'Position Stream has been canceled');
//                 });
//               }
//               serviceStatusValue = 'disabled';
//             }
//             _updatePositionList(
//               _PositionItemType.log,
//               'Location service has been $serviceStatusValue',
//             );
//           });
//     }
//   }
//
//   void _toggleListening() {
//     if (_positionStreamSubscription == null) {
//       final positionStream = _geolocatorPlatform.getPositionStream();
//       _positionStreamSubscription = positionStream.handleError((error) {
//         _positionStreamSubscription?.cancel();
//         _positionStreamSubscription = null;
//       }).listen((position) => _updatePositionList(
//         _PositionItemType.position,
//         position.toString(),
//       ));
//       _positionStreamSubscription?.pause();
//     }
//
//     setState(() {
//       if (_positionStreamSubscription == null) {
//         return;
//       }
//
//       String statusDisplayValue;
//       if (_positionStreamSubscription.isPaused) {
//         _positionStreamSubscription.resume();
//         statusDisplayValue = 'resumed';
//       } else {
//         _positionStreamSubscription.pause();
//         statusDisplayValue = 'paused';
//       }
//
//       _updatePositionList(
//         _PositionItemType.log,
//         'Listening for position updates $statusDisplayValue',
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     if (_positionStreamSubscription != null) {
//       _positionStreamSubscription.cancel();
//       _positionStreamSubscription = null;
//     }
//
//     super.dispose();
//   }
//
//   void _getLastKnownPosition() async {
//     final position = await _geolocatorPlatform.getLastKnownPosition();
//     if (position != null) {
//       _updatePositionList(
//         _PositionItemType.position,
//         position.toString(),
//       );
//     } else {
//       _updatePositionList(
//         _PositionItemType.log,
//         'No last known position available',
//       );
//     }
//   }
//
//   void _getLocationAccuracy() async {
//     final status = await _geolocatorPlatform.getLocationAccuracy();
//     _handleLocationAccuracyStatus(status);
//   }
//
//   void _requestTemporaryFullAccuracy() async {
//     final status = await _geolocatorPlatform.requestTemporaryFullAccuracy(
//       purposeKey: "TemporaryPreciseAccuracy",
//     );
//     _handleLocationAccuracyStatus(status);
//   }
//
//   void _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
//     String locationAccuracyStatusValue;
//     if (status == LocationAccuracyStatus.precise) {
//       locationAccuracyStatusValue = 'Precise';
//     } else if (status == LocationAccuracyStatus.reduced) {
//       locationAccuracyStatusValue = 'Reduced';
//     } else {
//       locationAccuracyStatusValue = 'Unknown';
//     }
//     _updatePositionList(
//       _PositionItemType.log,
//       '$locationAccuracyStatusValue location accuracy granted.',
//     );
//   }
//
//   void _openAppSettings() async {
//     final opened = await _geolocatorPlatform.openAppSettings();
//     String displayValue;
//
//     if (opened) {
//       displayValue = 'Opened Application Settings.';
//     } else {
//       displayValue = 'Error opening Application Settings.';
//     }
//
//     _updatePositionList(
//       _PositionItemType.log,
//       displayValue,
//     );
//   }
//
//   void _openLocationSettings() async {
//     final opened = await _geolocatorPlatform.openLocationSettings();
//     String displayValue;
//
//     if (opened) {
//       displayValue = 'Opened Location Settings';
//     } else {
//       displayValue = 'Error opening Location Settings';
//     }
//
//     _updatePositionList(
//       _PositionItemType.log,
//       displayValue,
//     );
//   }
// }
//
// enum _PositionItemType {
//   log,
//   position,
// }
//
// class _PositionItem {
//   _PositionItem(this.type, this.displayValue);
//
//   final _PositionItemType type;
//   final String displayValue;
// }
import 'dart:async';
import 'dart:io' show Platform;

// import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:ihl/utils/app_colors.dart';
class GeoLocation extends StatefulWidget {
  const GeoLocation();

  @override
  _GeoLocationState createState() => _GeoLocationState();
}

class _GeoLocationState extends State<GeoLocation> {
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position> _positionStreamSubscription;
  StreamSubscription<ServiceStatus> _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;
  @override
  double distanceInMeters= 0.00 ;
  @override
  void initState() {
    super.initState();
    timeOut();
    // _toggleServiceStatusStream();
  }
  String forNow = 'incomplete for now';

  PopupMenuButton _createActions() {
    return PopupMenuButton(
      elevation: 40,
      onSelected: (value) async {
        switch (value) {
          case 1:
            _getLocationAccuracy();
            break;
          case 2:
            _requestTemporaryFullAccuracy();
            break;
          case 3:
            _openAppSettings();
            break;
          case 4:
            _openLocationSettings();
            break;
          case 5:
            setState(_positionItems.clear);
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        if (Platform.isIOS)
          const PopupMenuItem(
            child: Text("Get Location Accuracy"),
            value: 1,
          ),
        if (Platform.isIOS)
          const PopupMenuItem(
            child: Text("Request Temporary Full Accuracy"),
            value: 2,
          ),
        const PopupMenuItem(
          child: Text("Open App Settings"),
          value: 3,
        ),
        if (Platform.isAndroid)
          const PopupMenuItem(
            child: Text("Open Location Settings"),
            value: 4,
          ),
        const PopupMenuItem(
          child: Text("Clear"),
          value: 5,
        ),
      ],
    );
  }
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 10,
    );
    return Scaffold(
      backgroundColor: FitnessAppTheme.grey,
      appBar: AppBar(
        title: Text(forNow),
        actions: [
          _createActions(),
        ],
      ),
      body: ListView.builder(
        itemCount: _positionItems.length,
        // itemCount: 1,
        itemBuilder: (context, index) {
          final positionItem = _positionItems[index];
          if (positionItem.type == _PositionItemType.log) {
            return ListTile(
              title: Text(positionItem.displayValue,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            );
          } else {
            return Card(
              child: ListTile(
                tileColor: Colors.blue,
                title: Text(
                  positionItem.displayValue ,
                  // '${_positionItems.length}  '+
                  //     '\n $distanceInMeters meters',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        // onPressed: _getCurrentPosition,
        onPressed: (){
          timeOut();
          // _timer.cancel();
        },
      ),
      // floatingActionButton: Column(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       child: (_positionStreamSubscription == null ||
      //           _positionStreamSubscription.isPaused)
      //           ? const Icon(Icons.play_arrow)
      //           : const Icon(Icons.pause),
      //       onPressed: () {
      //         positionStreamStarted = !positionStreamStarted;
      //         _toggleListening();
      //
      //         // double distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
      //         // print('distance covered => $distanceInMeters meters');
      //       },
      //       tooltip: (_positionStreamSubscription == null)
      //           ? 'Start position updates'
      //           : _positionStreamSubscription.isPaused
      //           ? 'Resume'
      //           : 'Pause',
      //       backgroundColor: _determineButtonColor(),
      //     ),
      //     sizedBox,
      //     FloatingActionButton(
      //       child: const Icon(Icons.my_location),
      //       onPressed: _getCurrentPosition,
      //     ),
      //     sizedBox,
      //     FloatingActionButton(
      //       child: const Icon(Icons.bookmark),
      //       onPressed: _getLastKnownPosition,
      //     ),
      //   ],
      // ),
    );
  }
  int _start = 60;
  var _timer;
  timeOut() {
    ///after 60 second we make the timeout variable(sixtySecComplete) true
    const callBackSec = const Duration(seconds: 5);
    _timer = Timer.periodic(
      callBackSec,
          (Timer timer){
        if (_start == 0){
          // setState(() {
          //   timer.cancel();
          // });
        } else {
          // setState(() {
            _getCurrentPosition();
            // _start--;

            print(_start.toString());
          // });
        }
      },
    );
  }


  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    cui =position.toString();
    // print(cui.type);
    li = cui.toString().split(',');
    cLat = double.parse(li[0].replaceAll('Latitude: ', ''));
    cLong = double.parse(li[1].replaceAll(' Longitude: ', ''));

    // 12.9969178         80.2557400

    if (12.9969178 - cLat < 0.0000300 ||
        80.2557400 - cLong < 0.0000300){
      setState(() {
        forNow = 'congrats you did it';
      });
    }
    _updatePositionList(
      _PositionItemType.position,
      position.toString(),

    );


  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  bool iIChange = true;
  var iLat;
  var iLong;
  var cui;
  var li ;
  var cLat;
  var cLong;
  void _updatePositionList(_PositionItemType type, String displayValue) {

    _positionItems.add(_PositionItem(type, displayValue));



    // if(iIChange){
    //   var iic = _PositionItem(type, displayValue);
    //   // print(cui.type);
    //   // var ic = iic.displayValue.toString().split(',');
    //   // iLat = double.parse(ic[0].replaceAll('Latitude: ', ''));
    //   // iLong = double.parse(ic[1].replaceAll(' Longitude: ', ''));
    //   // iIChange=false;
    // }
    ///initial index


    // cui = _PositionItem(type, displayValue);
    // // print(cui.type);
    // li = cui.displayValue.toString().split(',');
    // cLat = double.parse(li[0].replaceAll('Latitude: ', ''));
    // cLong = double.parse(li[1].replaceAll(' Longitude: ', ''));
    //
    // // 12.9969178         80.2557400
    //
    // if (12.9969178 - cLat < 0.0000300 ||
    //     80.2557400 - cLong < 0.0000300){
    //   setState(() {
    //     forNow = 'congrats you did it';
    //   });
    // }
    // Latitude: 12.993416, Longitude: 80.2533457
    // var currentLong
    // for(int i = 0; i<li.length;i++){}
    // distanceInMeters = Geolocator.distanceBetween(iLat, iLong, cLat, cLong);
    // print('distance covered => $distanceInMeters meters');
    setState(() {});
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
            _serviceStatusStreamSubscription?.cancel();
            _serviceStatusStreamSubscription = null;
          }).listen((serviceStatus) {
            String serviceStatusValue;
            if (serviceStatus == ServiceStatus.enabled) {
              if (positionStreamStarted) {
                _toggleListening();
              }
              serviceStatusValue = 'enabled';
            } else {
              if (_positionStreamSubscription != null) {
                setState(() {
                  _positionStreamSubscription?.cancel();
                  _positionStreamSubscription = null;
                  _updatePositionList(
                      _PositionItemType.log, 'Position Stream has been canceled');
                });
              }
              serviceStatusValue = 'disabled';
            }
            _updatePositionList(
              _PositionItemType.log,
              'Location service has been $serviceStatusValue',
            );
          });
    }
  }

  void _toggleListening() {
     LocationSettings locationSettings;

    // if (defaultTargetPlatform == TargetPlatform.android) {
    locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.best,
      // distanceFilter: 100,
      forceLocationManager: true,
      intervalDuration: const Duration(seconds: 5),
    );
    // } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
    //   locationSettings = AppleSettings(
    //     accuracy: LocationAccuracy.high,
    //     activityType: ActivityType.fitness,
    //     distanceFilter: 100,
    //     pauseLocationUpdatesAutomatically: true,
    //   );
    // } else {
    //   locationSettings = LocationSettings(
    //     accuracy: LocationAccuracy.high,
    //     distanceFilter: 100,
    //   );
    // }
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream(locationSettings: locationSettings);
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) //=>
      {

        print('accuracy =>'+'${position.accuracy}');
        return _updatePositionList(
          _PositionItemType.position,
          position.toString(),
        );

      });
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      String statusDisplayValue;
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(
        _PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }

  void _getLastKnownPosition() async {
    final position = await _geolocatorPlatform.getLastKnownPosition();
    if (position != null) {
      _updatePositionList(
        _PositionItemType.position,
        position.toString(),
      );
    } else {
      _updatePositionList(
        _PositionItemType.log,
        'No last known position available',
      );
    }
  }

  void _getLocationAccuracy() async {
    final status = await _geolocatorPlatform.getLocationAccuracy();
    _handleLocationAccuracyStatus(status);
  }

  void _requestTemporaryFullAccuracy() async {
    final status = await _geolocatorPlatform.requestTemporaryFullAccuracy(
      purposeKey: "TemporaryPreciseAccuracy",
    );
    _handleLocationAccuracyStatus(status);
  }

  void _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
    String locationAccuracyStatusValue;
    if (status == LocationAccuracyStatus.precise) {
      locationAccuracyStatusValue = 'Precise';
    } else if (status == LocationAccuracyStatus.reduced) {
      locationAccuracyStatusValue = 'Reduced';
    } else {
      locationAccuracyStatusValue = 'Unknown';
    }
    _updatePositionList(
      _PositionItemType.log,
      '$locationAccuracyStatusValue location accuracy granted.',
    );
  }

  void _openAppSettings() async {
    final opened = await _geolocatorPlatform.openAppSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Application Settings.';
    } else {
      displayValue = 'Error opening Application Settings.';
    }

    _updatePositionList(
      _PositionItemType.log,
      displayValue,
    );
  }

  void _openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Location Settings';
    } else {
      displayValue = 'Error opening Location Settings';
    }

    _updatePositionList(
      _PositionItemType.log,
      displayValue,
    );
  }
}
// 12.996910463188302, 80.25575987282387
// 12.99630891901443, 80.25507221438886
// 12.9969178         80.2557400
//
// 64463086,
//
// 8441845
enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}

