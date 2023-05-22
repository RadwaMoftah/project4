import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'states.dart';

class AccidentCubit extends Cubit<AccidentStats> {
  AccidentCubit() : super(AccidentInitialStats());
  static AccidentCubit get(context) => BlocProvider.of(context);



  bool isAccidentInAccelerometer = false;
  bool isAccidentInGyroscope = false;
  bool isAccident = false;

  LocationData? locationData;
  DateTime? eventTime;
  String? outButDate;
  double netforce = 0;
  void Listen() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (event.x > 2 ||
          event.y > 2 ||
          event.z > 2 ||
          event.x < -2 ||
          event.y < -2 ||
          event.x < -2) {
        isAccidentInGyroscope = true;
        emit(IsGyroscopeValidState());

        if (isAccidentInAccelerometer == true &&
            isAccidentInGyroscope == true) {
          AccidentValid();
        }
      }
    });
    accelerometerEvents.listen((AccelerometerEvent event) {
      netforce = sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
      if (netforce > 50) {

        isAccidentInAccelerometer = true;
        emit(IsAccelerometerValidState());

        if (isAccidentInAccelerometer == true &&
            isAccidentInGyroscope == true) {
          AccidentValid();
        }
      }
    });
  }

  void AccidentValid() {
    calculateLocationTime().then((value) {
      isAccident = true;
    });
  }

  Future<void> calculateLocationTime() async {
    locationData = await Location().getLocation();
    eventTime =
        DateTime.fromMillisecondsSinceEpoch(locationData!.time!.toInt());

    String date = eventTime.toString();
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSSS'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('MMM d hh:mm a');
    // var outputFormat = DateFormat('hh:mm a');

    outButDate = outputFormat.format(inputDate);
    emit(LocationTimeState());
  }

  void reset() {
    isAccident = false;
    isAccidentInAccelerometer = false;
    isAccidentInGyroscope = false;
    netforce = 0;
    emit(ResetState());
  }
}
