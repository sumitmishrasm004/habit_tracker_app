// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homepage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllHabitsFromDatabaseHash() =>
    r'bb5b9c38a034c2f6933ae3b31b242acfdcc653b1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getAllHabitsFromDatabase].
@ProviderFor(getAllHabitsFromDatabase)
const getAllHabitsFromDatabaseProvider = GetAllHabitsFromDatabaseFamily();

/// See also [getAllHabitsFromDatabase].
class GetAllHabitsFromDatabaseFamily
    extends Family<AsyncValue<List<HabitsModel>?>> {
  /// See also [getAllHabitsFromDatabase].
  const GetAllHabitsFromDatabaseFamily();

  /// See also [getAllHabitsFromDatabase].
  GetAllHabitsFromDatabaseProvider call({
    required int currentDate,
  }) {
    return GetAllHabitsFromDatabaseProvider(
      currentDate: currentDate,
    );
  }

  @override
  GetAllHabitsFromDatabaseProvider getProviderOverride(
    covariant GetAllHabitsFromDatabaseProvider provider,
  ) {
    return call(
      currentDate: provider.currentDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getAllHabitsFromDatabaseProvider';
}

/// See also [getAllHabitsFromDatabase].
class GetAllHabitsFromDatabaseProvider
    extends AutoDisposeFutureProvider<List<HabitsModel>?> {
  /// See also [getAllHabitsFromDatabase].
  GetAllHabitsFromDatabaseProvider({
    required int currentDate,
  }) : this._internal(
          (ref) => getAllHabitsFromDatabase(
            ref as GetAllHabitsFromDatabaseRef,
            currentDate: currentDate,
          ),
          from: getAllHabitsFromDatabaseProvider,
          name: r'getAllHabitsFromDatabaseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllHabitsFromDatabaseHash,
          dependencies: GetAllHabitsFromDatabaseFamily._dependencies,
          allTransitiveDependencies:
              GetAllHabitsFromDatabaseFamily._allTransitiveDependencies,
          currentDate: currentDate,
        );

  GetAllHabitsFromDatabaseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currentDate,
  }) : super.internal();

  final int currentDate;

  @override
  Override overrideWith(
    FutureOr<List<HabitsModel>?> Function(GetAllHabitsFromDatabaseRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAllHabitsFromDatabaseProvider._internal(
        (ref) => create(ref as GetAllHabitsFromDatabaseRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currentDate: currentDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<HabitsModel>?> createElement() {
    return _GetAllHabitsFromDatabaseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllHabitsFromDatabaseProvider &&
        other.currentDate == currentDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currentDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetAllHabitsFromDatabaseRef
    on AutoDisposeFutureProviderRef<List<HabitsModel>?> {
  /// The parameter `currentDate` of this provider.
  int get currentDate;
}

class _GetAllHabitsFromDatabaseProviderElement
    extends AutoDisposeFutureProviderElement<List<HabitsModel>?>
    with GetAllHabitsFromDatabaseRef {
  _GetAllHabitsFromDatabaseProviderElement(super.provider);

  @override
  int get currentDate =>
      (origin as GetAllHabitsFromDatabaseProvider).currentDate;
}

String _$saveDataForHomeWidgetHash() =>
    r'1c643c10faa40c4bee0c586e263294b8ae35c5ec';

/// See also [saveDataForHomeWidget].
@ProviderFor(saveDataForHomeWidget)
final saveDataForHomeWidgetProvider = AutoDisposeFutureProvider<void>.internal(
  saveDataForHomeWidget,
  name: r'saveDataForHomeWidgetProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$saveDataForHomeWidgetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SaveDataForHomeWidgetRef = AutoDisposeFutureProviderRef<void>;
String _$uploadHabitsToFirebaseDatabaseHash() =>
    r'070a0b493e607073e776a1780a70e42e55f0b9ce';

/// See also [uploadHabitsToFirebaseDatabase].
@ProviderFor(uploadHabitsToFirebaseDatabase)
final uploadHabitsToFirebaseDatabaseProvider =
    AutoDisposeFutureProvider<void>.internal(
  uploadHabitsToFirebaseDatabase,
  name: r'uploadHabitsToFirebaseDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$uploadHabitsToFirebaseDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UploadHabitsToFirebaseDatabaseRef = AutoDisposeFutureProviderRef<void>;
String _$uploadHabitsValuesToFirebaseDatabaseHash() =>
    r'ad8f36220040c07aab74ce2e972cf6964e40a2b1';

/// See also [uploadHabitsValuesToFirebaseDatabase].
@ProviderFor(uploadHabitsValuesToFirebaseDatabase)
final uploadHabitsValuesToFirebaseDatabaseProvider =
    AutoDisposeFutureProvider<void>.internal(
  uploadHabitsValuesToFirebaseDatabase,
  name: r'uploadHabitsValuesToFirebaseDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$uploadHabitsValuesToFirebaseDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UploadHabitsValuesToFirebaseDatabaseRef
    = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
