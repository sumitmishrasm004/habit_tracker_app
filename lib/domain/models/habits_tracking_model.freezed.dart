// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habits_tracking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

HabitsTrackingModel _$HabitsTrackingModelFromJson(Map<String, dynamic> json) {
  return _HabitsTrackingModel.fromJson(json);
}

/// @nodoc
mixin _$HabitsTrackingModel {
  int? get id => throw _privateConstructorUsedError;
  set id(int? value) => throw _privateConstructorUsedError;
  int? get isDataUploaded => throw _privateConstructorUsedError;
  set isDataUploaded(int? value) => throw _privateConstructorUsedError;
  int get habitId => throw _privateConstructorUsedError;
  set habitId(int value) => throw _privateConstructorUsedError;
  int get habitTrackingDate => throw _privateConstructorUsedError;
  set habitTrackingDate(int value) => throw _privateConstructorUsedError;
  String get habitCompletedValue => throw _privateConstructorUsedError;
  set habitCompletedValue(String value) => throw _privateConstructorUsedError;
  String? get habitMemo => throw _privateConstructorUsedError;
  set habitMemo(String? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HabitsTrackingModelCopyWith<HabitsTrackingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitsTrackingModelCopyWith<$Res> {
  factory $HabitsTrackingModelCopyWith(
          HabitsTrackingModel value, $Res Function(HabitsTrackingModel) then) =
      _$HabitsTrackingModelCopyWithImpl<$Res, HabitsTrackingModel>;
  @useResult
  $Res call(
      {int? id,
      int? isDataUploaded,
      int habitId,
      int habitTrackingDate,
      String habitCompletedValue,
      String? habitMemo});
}

/// @nodoc
class _$HabitsTrackingModelCopyWithImpl<$Res, $Val extends HabitsTrackingModel>
    implements $HabitsTrackingModelCopyWith<$Res> {
  _$HabitsTrackingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? isDataUploaded = freezed,
    Object? habitId = null,
    Object? habitTrackingDate = null,
    Object? habitCompletedValue = null,
    Object? habitMemo = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      isDataUploaded: freezed == isDataUploaded
          ? _value.isDataUploaded
          : isDataUploaded // ignore: cast_nullable_to_non_nullable
              as int?,
      habitId: null == habitId
          ? _value.habitId
          : habitId // ignore: cast_nullable_to_non_nullable
              as int,
      habitTrackingDate: null == habitTrackingDate
          ? _value.habitTrackingDate
          : habitTrackingDate // ignore: cast_nullable_to_non_nullable
              as int,
      habitCompletedValue: null == habitCompletedValue
          ? _value.habitCompletedValue
          : habitCompletedValue // ignore: cast_nullable_to_non_nullable
              as String,
      habitMemo: freezed == habitMemo
          ? _value.habitMemo
          : habitMemo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HabitsTrackingModelImplCopyWith<$Res>
    implements $HabitsTrackingModelCopyWith<$Res> {
  factory _$$HabitsTrackingModelImplCopyWith(_$HabitsTrackingModelImpl value,
          $Res Function(_$HabitsTrackingModelImpl) then) =
      __$$HabitsTrackingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? isDataUploaded,
      int habitId,
      int habitTrackingDate,
      String habitCompletedValue,
      String? habitMemo});
}

/// @nodoc
class __$$HabitsTrackingModelImplCopyWithImpl<$Res>
    extends _$HabitsTrackingModelCopyWithImpl<$Res, _$HabitsTrackingModelImpl>
    implements _$$HabitsTrackingModelImplCopyWith<$Res> {
  __$$HabitsTrackingModelImplCopyWithImpl(_$HabitsTrackingModelImpl _value,
      $Res Function(_$HabitsTrackingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? isDataUploaded = freezed,
    Object? habitId = null,
    Object? habitTrackingDate = null,
    Object? habitCompletedValue = null,
    Object? habitMemo = freezed,
  }) {
    return _then(_$HabitsTrackingModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      isDataUploaded: freezed == isDataUploaded
          ? _value.isDataUploaded
          : isDataUploaded // ignore: cast_nullable_to_non_nullable
              as int?,
      habitId: null == habitId
          ? _value.habitId
          : habitId // ignore: cast_nullable_to_non_nullable
              as int,
      habitTrackingDate: null == habitTrackingDate
          ? _value.habitTrackingDate
          : habitTrackingDate // ignore: cast_nullable_to_non_nullable
              as int,
      habitCompletedValue: null == habitCompletedValue
          ? _value.habitCompletedValue
          : habitCompletedValue // ignore: cast_nullable_to_non_nullable
              as String,
      habitMemo: freezed == habitMemo
          ? _value.habitMemo
          : habitMemo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitsTrackingModelImpl
    with DiagnosticableTreeMixin
    implements _HabitsTrackingModel {
  _$HabitsTrackingModelImpl(
      {this.id,
      this.isDataUploaded,
      required this.habitId,
      required this.habitTrackingDate,
      required this.habitCompletedValue,
      this.habitMemo});

  factory _$HabitsTrackingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitsTrackingModelImplFromJson(json);

  @override
  int? id;
  @override
  int? isDataUploaded;
  @override
  int habitId;
  @override
  int habitTrackingDate;
  @override
  String habitCompletedValue;
  @override
  String? habitMemo;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HabitsTrackingModel(id: $id, isDataUploaded: $isDataUploaded, habitId: $habitId, habitTrackingDate: $habitTrackingDate, habitCompletedValue: $habitCompletedValue, habitMemo: $habitMemo)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'HabitsTrackingModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('isDataUploaded', isDataUploaded))
      ..add(DiagnosticsProperty('habitId', habitId))
      ..add(DiagnosticsProperty('habitTrackingDate', habitTrackingDate))
      ..add(DiagnosticsProperty('habitCompletedValue', habitCompletedValue))
      ..add(DiagnosticsProperty('habitMemo', habitMemo));
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitsTrackingModelImplCopyWith<_$HabitsTrackingModelImpl> get copyWith =>
      __$$HabitsTrackingModelImplCopyWithImpl<_$HabitsTrackingModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitsTrackingModelImplToJson(
      this,
    );
  }
}

abstract class _HabitsTrackingModel implements HabitsTrackingModel {
  factory _HabitsTrackingModel(
      {int? id,
      int? isDataUploaded,
      required int habitId,
      required int habitTrackingDate,
      required String habitCompletedValue,
      String? habitMemo}) = _$HabitsTrackingModelImpl;

  factory _HabitsTrackingModel.fromJson(Map<String, dynamic> json) =
      _$HabitsTrackingModelImpl.fromJson;

  @override
  int? get id;
  set id(int? value);
  @override
  int? get isDataUploaded;
  set isDataUploaded(int? value);
  @override
  int get habitId;
  set habitId(int value);
  @override
  int get habitTrackingDate;
  set habitTrackingDate(int value);
  @override
  String get habitCompletedValue;
  set habitCompletedValue(String value);
  @override
  String? get habitMemo;
  set habitMemo(String? value);
  @override
  @JsonKey(ignore: true)
  _$$HabitsTrackingModelImplCopyWith<_$HabitsTrackingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
