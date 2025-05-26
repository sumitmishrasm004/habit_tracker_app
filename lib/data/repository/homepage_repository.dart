import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:habit_tracker/constant/app_urls.dart';
import 'package:habit_tracker/constant/text_strings.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/domain/repositories/api_repository.dart';
import 'package:habit_tracker/services/health_data_service.dart';
import 'package:habit_tracker/services/shared_preferences.dart';
import 'package:habit_tracker/utils/enum/SaveStatusEnum.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:habit_tracker/utils/resources/database_provider.dart';
import 'package:habit_tracker/utils/resources/utils.dart';
import 'package:health/health.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'homepage_repository.g.dart';

@riverpod
HomepageRepository homepageRepository(HomepageRepositoryRef ref) {
  return HomepageRepository(ref.watch(databaseImplProvider));
}

class HomepageRepository extends BaseRepository {
  HtDatabaseImpl databaseImpl;

  HomepageRepository(this.databaseImpl);

  Future<List<HabitsModel>?> getAllHabitsFromDatabase({required int currentDate}) async {
    try {
      List<Map> savedHabits = await databaseImpl.getHabitsValueByDate(currentDate: currentDate);
      List<HabitsModel>? habitsList =
          List.generate(savedHabits.length, (index) => HabitsModel.fromMap(savedHabits[index]));
      if (habitsList.isNotEmpty) {
        for (HabitsModel model in habitsList) {
          if (model.healthApp == 1) {
            int? steps = await HealthDataService().fetchHealthData(
                startTime: (model.lastHealthSync != null && model.lastHealthSync! > 0)
                    ? Utils.convertTimestampToDateTime(model.lastHealthSync!)
                    : null,
                type: HealthDataType.STEPS);
            if (steps != null && steps > 0) {
              int newHabitValue = (model.habitCompletedValue ?? 0) + steps;

              model.lastHealthSync = DateTime.now().millisecondsSinceEpoch;
              await saveHabitValue(habitValue: newHabitValue, habitsModel: model);
              model.habitCompletedValue = newHabitValue;
            }
          }
        }
      }
      return habitsList;
    } catch (e) {
      throw Exception("Failed to get habits details");
    }
  }

  Future<List<Map>?> getAllHabitsAsMap({required int currentDate}) async {
    try {
      List<Map> savedHabits = await databaseImpl.getHabitsValueByDate(currentDate: currentDate);
      return savedHabits;
    } catch (e) {
      throw Exception("Failed to get habits details");
    }
  }

  Future<void> saveHabitValue({required int habitValue, required HabitsModel habitsModel}) async {
    try {
      HtDatabaseImpl databaseImpl = HtDatabaseImpl();
      Map<String, dynamic> map = {
        "habitId": habitsModel.id,
        "habitTrackingDate": Utils.dateForDb(DateTime.now()),
        "habitCompletedValue": habitValue
      };
      if (habitsModel.htId == null) {
        map.putIfAbsent("saveStatus", () => SaveStatusEnum.pending.name);
        habitsModel.htId =
            await databaseImpl.insert(tableName: HtDatabaseImpl.habitTrackingTableName, data: map);
      } else {
        map.putIfAbsent("saveStatus", () => SaveStatusEnum.updated.name);

        await databaseImpl.update(
            tableName: HtDatabaseImpl.habitTrackingTableName,
            data: map,
            whereCondition: "htId = ${habitsModel.htId}");
      }

      await databaseImpl.update(
          tableName: HtDatabaseImpl.habitTableName,
          data: habitsModel.toJson(),
          whereCondition: "id = ${habitsModel.id}");
    } catch (e) {
      Logger.log(message: e.toString());
    }
  }

  Future<void> savePendingHabitsToFirebaseDatabase() async {
    try {
      const String userIdKey = 'userId';
      String? userId = SharedprefUtils.getString(userIdKey);
      if (userId != null && userId.isNotEmpty) {
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult != ConnectivityResult.none) {
          List<HabitsModel>? habitsList =
              await getHabitsBasedOnStatus(saveStatusEnum: SaveStatusEnum.pending);
          if (habitsList != null && habitsList.isNotEmpty) {
            FirebaseDatabase database = FirebaseDatabase.instance;
            database.databaseURL = AppUrls.firebaseDatabaseUrl;
            for (HabitsModel model in habitsList) {
              var databaseRef = database.ref("users/$userId/habits_table/${model.id}");
              await databaseRef.set(model.toJson());
              await updateHabitsStatus(habitId: model.id!, saveStatus: SaveStatusEnum.saved);
            }
          }
        }
      }
    } catch (e) {
      throw Exception("Failed to upload habits");
    }
  }

  Future<void> savePendingHabitsValuesToFirebaseDatabase() async {
    try {
      const String userIdKey = 'userId';
      String? userId = SharedprefUtils.getString(userIdKey);
      if (userId != null && userId.isNotEmpty) {
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult != ConnectivityResult.none) {
          List<Map>? habitsList =
              await getHabitsValuesBasedOnStatus(saveStatusEnum: SaveStatusEnum.pending);
          if (habitsList != null && habitsList.isNotEmpty) {
            FirebaseDatabase database = FirebaseDatabase.instance;
            database.databaseURL = AppUrls.firebaseDatabaseUrl;
            for (var model in habitsList) {
              var databaseRef = database.ref("users/$userId/habits_tracking_table/${model["habitId"]}");
              await databaseRef.set(model);
              await updateHabitsValueStatus(habitId: model["habitId"], saveStatus: SaveStatusEnum.saved);
            }
          }
        }
      }
    } catch (e) {
      Logger.log(message: "Error : ${e.toString()}");
      throw Exception("Failed to upload habits");
    }
  }

  Future<List<HabitsModel>?> getAllHabitsFromFirebaseDatabase() async {
    try {
      const String userIdKey = 'userId';
      String? userId = SharedprefUtils.getString(userIdKey);
      if (userId != null && userId.isNotEmpty) {
        FirebaseDatabase database = FirebaseDatabase.instance;
        database.databaseURL = AppUrls.firebaseDatabaseUrl;
        var databaseRef = database.ref("users/$userId/habits_table");
        DataSnapshot snapshot = await databaseRef.get();
        if (snapshot.exists) {
          List<HabitsModel> habitsList = [];
          Map<dynamic, dynamic> habitsMap = snapshot.value as Map<dynamic, dynamic>;
          habitsMap.forEach((key, value) {
            habitsList.add(HabitsModel.fromMap(Map<String, dynamic>.from(value)));
          });
          return habitsList;
        }
      }
      return null;
    } catch (e) {
      throw Exception("Failed to get habits from Firebase");
    }
  }

  Future<List<Map>?> getAllHabitsValuesFromFirebaseDatabase() async {
    try {
      const String userIdKey = 'userId';
      String? userId = SharedprefUtils.getString(userIdKey);
      if (userId != null && userId.isNotEmpty) {
        FirebaseDatabase database = FirebaseDatabase.instance;
        database.databaseURL = AppUrls.firebaseDatabaseUrl;
        var databaseRef = database.ref("users/$userId/habits_tracking_table");
        DataSnapshot snapshot = await databaseRef.get();
        if (snapshot.exists) {
          List<Map> habitsValuesList = [];
          Map<dynamic, dynamic> habitsMap = snapshot.value as Map<dynamic, dynamic>;
          habitsMap.forEach((key, value) {
            habitsValuesList.add(Map<String, dynamic>.from(value));
          });
          return habitsValuesList;
        }
      }
      return null;
    } catch (e) {
      throw Exception("Failed to get habit values from Firebase");
    }
  }

  Future<List<HabitsModel>?> getHabitsBasedOnStatus({required SaveStatusEnum saveStatusEnum}) async {
    try {
      List<Map> savedHabits = await databaseImpl.getHabitByStatus(saveStatusEnum: saveStatusEnum);
      List<HabitsModel>? habitsList =
          List.generate(savedHabits.length, (index) => HabitsModel.fromMap(savedHabits[index]));
      return habitsList;
    } catch (e) {
      throw Exception("Failed to get habits details");
    }
  }

  Future<List<Map>?> getHabitsValuesBasedOnStatus({required SaveStatusEnum saveStatusEnum}) async {
    try {
      List<Map> savedHabits =
          await databaseImpl.getHabitsValuesByStatus(saveStatusEnum: saveStatusEnum);
      return savedHabits;
    } catch (e) {
      Logger.log(message: "Error : ${e.toString()}");
      throw Exception("Failed to get habits details");
    }
  }

  Future<bool?> updateHabitsStatus({required int habitId, required SaveStatusEnum saveStatus}) async {
    try {
      await databaseImpl.updateHabitsSaveStatus(habitId: habitId, saveStatusEnum: saveStatus);
      return true;
    } catch (e) {
      Logger.log(message: "Error: ${e.toString()}");
      return false;
    }
  }

  Future<bool?> updateHabitsValueStatus({required int habitId, required SaveStatusEnum saveStatus}) async {
    try {
      await databaseImpl.updateHabitsValueSaveStatus(habitId: habitId, saveStatusEnum: saveStatus);
      return true;
    } catch (e) {
      Logger.log(message: "Error: ${e.toString()}");
      return false;
    }
  }


  Future<void> deleteUserData() async {
     const String userIdKey = 'userId';
      String? userId = SharedprefUtils.getString(userIdKey);
    try {
      FirebaseDatabase database = FirebaseDatabase.instance;
      database.databaseURL = AppUrls.firebaseDatabaseUrl;
      if (userId != '' && userId.isNotEmpty) {
      // Reference to the user's data
      DatabaseReference userRef = database.ref("users/$userId");

      // Remove the data
      await userRef.remove();

      Logger.log(message: "User data deleted successfully for userId: $userId");
      }
    } catch (e) {
      Logger.log(message: "Error deleting user data: $e");
      throw Exception("Failed to delete user data");
    }
  }
  
}

