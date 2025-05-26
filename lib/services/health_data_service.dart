import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:health/health.dart';

class HealthDataService {
  Health health = Health();

  Future<dynamic> fetchHealthData(
      {required DateTime? startTime, required HealthDataType type}) async {
    final endTime = DateTime.now();
    startTime ??= DateTime(endTime.year, endTime.month, endTime.day);
    List<HealthDataType> dataTypes = [type];
    try {
      if (type == HealthDataType.STEPS) {
        int? steps = await health.getTotalStepsInInterval(startTime, endTime);
        Logger.log(message: "steps walked ====> $steps");
        return steps;
      } else {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
            types: dataTypes, startTime: startTime, endTime: endTime);
        Logger.log(message: "healthData  ====> $healthData");
        HealthDataPoint healthDataPoint = healthData.first;
        if (healthDataPoint.type == HealthDataType.STEPS) {
          NumericHealthValue value =
              healthDataPoint.value as NumericHealthValue;
          return value.numericValue.toInt();
        }
        return null;
        // return healthData.map((e) {
        //   return HealthDataModel(
        //       value: double.parse(e.value.toJson()['numericValue']),
        //       unit: e.unitString,
        //       dateFrom: e.dateFrom,
        //       dateTo: e.dateTo);
        // }).toList();
      }
    } catch (error) {
      Logger.log(
          message: "Caught exception in getTotalStepsInInterval: $error");
    }
  }
}
