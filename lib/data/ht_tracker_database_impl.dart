import 'package:habit_tracker/domain/repositories/database_repository.dart';
import 'package:habit_tracker/utils/enum/SaveStatusEnum.dart';
import 'package:habit_tracker/utils/helpers/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HtDatabaseImpl extends DatabaseRepository {
  static Database? _database;
  static const _databaseName = 'ht_database';
  static const _databaseVersion = 1;

  /// Habits Table Columns
  static const habitTableName = 'habits_table';
  static const habitPrimaryKey = 'id';
  static const _habitName = 'habitName';
  static const _habitDescription = 'habitDescription';
  static const _habitIcon = 'habitIcon';
  static const _habitColor = 'habitColor';
  static const _habitType = 'habitType';
  static const _habitCategory = 'habitCategory';
  static const _tags = 'tags';
  static const _valueType = 'valueType';
  static const _goal = 'goal';
  static const _goalUnit = 'goalUnit';
  static const _goalPeriod = 'goalPeriod';
  static const _everydayFrequency = 'everydayFrequency';
  static const _habitTimeRange = 'habitTimeRange';
  static const _reminderTime = 'reminderTime';
  static const _habitEndNotificationID = 'habitEndNotificationID';
  static const _remindedMessage = 'reminderMessage';
  static const _showHabitMemo = 'showHabitMemo';
  static const _habitGesture = 'habitGesture';
  static const _chartType = 'chartType';
  static const _habitStartDate = 'habitStartDate';
  static const _habitEndDate = 'habitEndDate';
  static const _habitHealthApp = 'healthApp';
  static const _habitHealthLastSync = 'lastHealthSync';
  static const _habitSaveStatus = "saveStatus";

  /// Habits Tracking Table Columns
  static const habitTrackingTableName = 'habits_tracking_table';
  static const htPrimaryKey = 'htId';
  static const _habitId = 'habitId';
  static const _trackingDate = 'habitTrackingDate';
  static const _habitCompletedValue = 'habitCompletedValue';
  static const _habitMemo = 'habitMemo';

  /// Habits & Tracking Junction Table Columns
  static const habitTrackingJunctionTableName =
      'habits_tracking_junction_table';
  static const hjtPrimaryKey = 'hjtId';
  static const _habitTableId = 'habitTableId';
  static const _habitTrackingTableId = 'habitTrackingTableId';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, _) {
        db.execute('''
          CREATE TABLE $habitTableName(
            $habitPrimaryKey INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $_habitName TEXT NOT NULL,
            $_habitDescription TEXT,
            $_habitIcon TEXT,
            $_habitColor TEXT,
            $_habitType TEXT NOT NULL,
            $_habitCategory TEXT NOT NULL,
            $_tags TEXT,
            $_valueType TEXT NOT NULL,
            $_goal TEXT NOT NULL,
            $_goalUnit TEXT NOT NULL,
            $_goalPeriod TEXT NOT NULL,
            $_everydayFrequency TEXT NOT NULL,
            $_habitTimeRange TEXT,
            $_reminderTime TEXT,
            $_habitEndNotificationID TEXT,
            $_remindedMessage TEXT,
            $_showHabitMemo INTEGER,
            $_habitGesture TEXT,
            $_chartType TEXT,
            $_habitStartDate INTEGER NOT NULL,
            $_habitEndDate INTEGER NOT NULL,
            $_habitHealthApp INTEGER NOT NULL,
            $_habitHealthLastSync INTEGER,
            $_habitSaveStatus TEXT
          )
        ''');

        db.execute('''
          CREATE TABLE $habitTrackingTableName(
            $htPrimaryKey INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $_habitId INTEGER NOT NULL,
            $_trackingDate INTEGER NOT NULL,
            $_habitCompletedValue INTEGER DEFAULT 0,
            $_habitMemo TEXT,
            $_habitSaveStatus TEXT
          )
        ''');

        db.execute('''
          CREATE TABLE $habitTrackingJunctionTableName(
            $hjtPrimaryKey INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $_habitTableId TEXT NOT NULL,
            $_habitTrackingTableId TEXT
          )
        ''');
      },
      version: _databaseVersion,
    );
  }

  @override
  Future<int?> insert(
      {required String tableName,
      required Map<String, dynamic> data,
      ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace}) async {
    try {
      if (_database != null && _database!.isOpen) {
        int id = await _database!
            .insert(tableName, data, conflictAlgorithm: conflictAlgorithm);
        return id;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Data is not saved to database - insert data ${e.toString()}");
    }
  }

  @override
  Future<int?> update(
      {required String tableName,
      required Map<String, dynamic> data,
      required String whereCondition,
      ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace}) async {
    try {
      if (_database != null && _database!.isOpen) {
        int id = await _database!.update(tableName, data,
            where: whereCondition, conflictAlgorithm: conflictAlgorithm);
        return id;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Data is not saved to database - update data ${e.toString()}");
    }
  }

  @override
  Future<List<Map>> fetchAll({required String tableName}) async {
    try {
      if (_database != null && _database!.isOpen) {
        List<Map> allData = await _database!.query(tableName);
        return allData;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Failed to get data from local database");
    }
  }

  @override
  Future<Map> fetchById(
      {required String tableName, required int columnId}) async {
    try {
      if (_database != null && _database!.isOpen) {
        List<Map> allData = await _database!.query(tableName,
            where: "$habitPrimaryKey = ?", whereArgs: [columnId]);
        return allData.first;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Failed to get data from local database");
    }
  }

  @override
  Future<List<Map>> getHabitsValueByDate({required int currentDate}) async {
    try {
      if (_database != null && _database!.isOpen) {
        String query =
            "Select * from $habitTableName as h left join $habitTrackingTableName as hjt ON h.$habitPrimaryKey = hjt.$_habitId AND (hjt.$_trackingDate = $currentDate) where h.$_habitStartDate <= $currentDate AND (h.$_habitEndDate >= $currentDate OR h.$_habitEndDate == 0)";

        List<Map> allData = await _database!.rawQuery(query);
        return allData;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Failed to get data from local database");
    }
  }

  @override
  Future<List<Map>> getAllHabitsBetweenDates(
      {required int startDate, required int endDate}) async {
    try {
      if (_database != null && _database!.isOpen) {
        String query =
            "SELECT * FROM $habitTableName as h WHERE (h.$_habitStartDate >= $startDate AND h.$_habitStartDate <= $endDate) OR (h.$_habitEndDate <= $endDate AND (h.$_habitEndDate >= $startDate OR h.$_habitEndDate == 0) ) OR (h.$_habitStartDate <= $startDate AND (h.$_habitEndDate >= $endDate OR h.$_habitEndDate == 0))";
        Logger.log(message: "Query : $query");
        List<Map> allData = await _database!.rawQuery(query);
        return allData;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Failed to get data from local database");
    }
  }

  @override
  Future<List<Map>> getHabitsValueBetweenDates(
      {required String habitId,
      required int startDate,
      required int endDate}) async {
    try {
      if (_database != null && _database!.isOpen) {
        String query =
            "Select SUM($_habitCompletedValue) from $habitTrackingTableName where $_habitId = $habitId AND $_trackingDate >= $startDate AND $_trackingDate <= $endDate";
        Logger.log(message: "Query : $query");
        List<Map> allData = await _database!.rawQuery(query);
        return allData;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Failed to get data from local database");
    }
  }

  @override
  Future<List<Map>> getHabitsAllValuesBetweenDates(
      {required String habitId,
      required int startDate,
      required int endDate}) async {
    try {
      if (_database != null && _database!.isOpen) {
        String query =
            "Select * from $habitTrackingTableName where $_habitId = $habitId AND $_trackingDate >= $startDate AND $_trackingDate <= $endDate";
        Logger.log(message: "Query : $query");
        List<Map> allData = await _database!.rawQuery(query);
        return allData;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Failed to get data from local database");
    }
  }

  @override
  Future<List<Map>> getAllHabitsName() async {
    try {
      if (_database != null && _database!.isOpen) {
        String query = "Select * from $habitTableName";
        List<Map> allData = await _database!.rawQuery(query);
        return allData;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Failed to get data from local database");
    }
  }

  Future<void> deleteHabit(int habitID) async {
    String query = "DELETE FROM $habitTableName WHERE $habitPrimaryKey = ?";
    String deleteTrackingTableQuery =
        "DELETE FROM $habitTrackingTableName WHERE $_habitId = ?";

    try {
      int rowsAffected = await _database!.rawDelete(query, [habitID]);
      int rowsTrackingTable =
          await _database!.rawDelete(deleteTrackingTableQuery, [habitID]);

      if (rowsAffected > 0) {
        Logger.log(message: 'Habit deleted successfully');
      } else {
        Logger.log(message: 'Habit not found or failed to delete');
      }
    } catch (error) {
      Logger.log(message: 'Error deleting habit: $error');
    }
  }

  @override
  Future<List<Map>> getHabitByStatus(
      {required SaveStatusEnum saveStatusEnum}) async {
    try {
      if (_database != null && _database!.isOpen) {
        String query =
            "Select * from $habitTableName where $_habitSaveStatus = '${saveStatusEnum.name}'";

        List<Map> allData = await _database!.rawQuery(query);
        return allData;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Failed to get data from local database");
    }
  }

  Future<List<Map>> getHabitsValuesByStatus(
      {required SaveStatusEnum saveStatusEnum}) async {
    try {
      if (_database != null && _database!.isOpen) {
        String query =
            "Select * from $habitTrackingTableName where $_habitSaveStatus = '${saveStatusEnum.name}' OR $_habitSaveStatus = '${SaveStatusEnum.updated.name}'";

        List<Map> allData = await _database!.rawQuery(query);
        return allData;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Failed to get data from local database");
    }
  }

  Future<List<Map>> updateHabitsSaveStatus(
      {required int habitId, required SaveStatusEnum saveStatusEnum}) async {
    try {
      if (_database != null && _database!.isOpen) {
        String query =
            "Update $habitTableName SET $_habitSaveStatus = '${saveStatusEnum.name}' where $habitPrimaryKey = $habitId";
        Logger.log(message: "Query : $query");
        List<Map> allData = await _database!.rawQuery(query);
        return allData;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Failed to get data from local database");
    }
  }

  Future<List<Map>> updateHabitsValueSaveStatus(
      {required int habitId, required SaveStatusEnum saveStatusEnum}) async {
    try {
      if (_database != null && _database!.isOpen) {
        String query =
            "Update $habitTrackingTableName SET $_habitSaveStatus = '${saveStatusEnum.name}' where $_habitId = $habitId";
        Logger.log(message: "Query : $query");
        List<Map> allData = await _database!.rawQuery(query);
        return allData;
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: e.toString());
      throw Exception("Failed to get data from local database");
    }
  }


  /// Function to delete all data from the database
  Future<void> deleteAllData() async {
    try {
      if (_database != null && _database!.isOpen) {
        await _database!.transaction((txn) async {
          await txn.rawDelete("DELETE FROM $habitTableName");
          await txn.rawDelete("DELETE FROM $habitTrackingTableName");
          await txn.rawDelete("DELETE FROM $habitTrackingJunctionTableName");
        });

        Logger.log(message: 'All data deleted successfully');
      } else {
        throw Exception("Database is not open");
      }
    } catch (e) {
      Logger.log(message: 'Error deleting all data: $e');
      throw Exception("Failed to delete all data from the database");
    }
  }
}
