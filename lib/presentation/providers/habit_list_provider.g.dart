// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getHabitsListHash() => r'e4f8cf52701dc5abe3fc8152110f3b3ee7e53ab0';

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

/// See also [getHabitsList].
@ProviderFor(getHabitsList)
const getHabitsListProvider = GetHabitsListFamily();

/// See also [getHabitsList].
class GetHabitsListFamily extends Family<AsyncValue<List<HabitsModel>>> {
  /// See also [getHabitsList].
  const GetHabitsListFamily();

  /// See also [getHabitsList].
  GetHabitsListProvider call(
    String assetPath,
  ) {
    return GetHabitsListProvider(
      assetPath,
    );
  }

  @override
  GetHabitsListProvider getProviderOverride(
    covariant GetHabitsListProvider provider,
  ) {
    return call(
      provider.assetPath,
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
  String? get name => r'getHabitsListProvider';
}

/// See also [getHabitsList].
class GetHabitsListProvider
    extends AutoDisposeFutureProvider<List<HabitsModel>> {
  /// See also [getHabitsList].
  GetHabitsListProvider(
    String assetPath,
  ) : this._internal(
          (ref) => getHabitsList(
            ref as GetHabitsListRef,
            assetPath,
          ),
          from: getHabitsListProvider,
          name: r'getHabitsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getHabitsListHash,
          dependencies: GetHabitsListFamily._dependencies,
          allTransitiveDependencies:
              GetHabitsListFamily._allTransitiveDependencies,
          assetPath: assetPath,
        );

  GetHabitsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetPath,
  }) : super.internal();

  final String assetPath;

  @override
  Override overrideWith(
    FutureOr<List<HabitsModel>> Function(GetHabitsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetHabitsListProvider._internal(
        (ref) => create(ref as GetHabitsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetPath: assetPath,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<HabitsModel>> createElement() {
    return _GetHabitsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetHabitsListProvider && other.assetPath == assetPath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetPath.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetHabitsListRef on AutoDisposeFutureProviderRef<List<HabitsModel>> {
  /// The parameter `assetPath` of this provider.
  String get assetPath;
}

class _GetHabitsListProviderElement
    extends AutoDisposeFutureProviderElement<List<HabitsModel>>
    with GetHabitsListRef {
  _GetHabitsListProviderElement(super.provider);

  @override
  String get assetPath => (origin as GetHabitsListProvider).assetPath;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
