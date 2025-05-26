

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habit_tracker/data/ht_tracker_database_impl.dart';
part 'database_provider.g.dart';


@riverpod
HtDatabaseImpl databaseImpl(DatabaseImplRef ref){
  final HtDatabaseImpl htDatabaseImpl = HtDatabaseImpl();
  return htDatabaseImpl;
}