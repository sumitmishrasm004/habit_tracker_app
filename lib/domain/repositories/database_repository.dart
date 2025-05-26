import 'package:habit_tracker/domain/models/habits_model.dart';
import 'package:habit_tracker/utils/enum/SaveStatusEnum.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseRepository {
  Future<int?> insert(
      {required String tableName,
      required Map<String, dynamic> data,
      ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace});

  Future<int?> update(
      {required String tableName,
        required Map<String, dynamic> data,
        required String whereCondition,
        ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace});

  Future<Map> fetchById({required String tableName, required int columnId});

  Future<List<Map>> fetchAll({required String tableName});

  Future<List<Map>> getHabitsValueByDate({required int currentDate});

  Future<List<Map>> getAllHabitsBetweenDates({required int startDate, required int endDate});

  Future<List<Map>> getHabitsValueBetweenDates({required String habitId, required int startDate, required int endDate});

  Future<List<Map>> getHabitByStatus({required SaveStatusEnum saveStatusEnum});


}
