// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Request _$RequestFromJson(Map<String, dynamic> json) {
  return _Request.fromJson(json);
}

/// @nodoc
mixin _$Request {
  String? get id => throw _privateConstructorUsedError;
  String get artist => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  String get requesterId => throw _privateConstructorUsedError;
  String get requesterUsername => throw _privateConstructorUsedError;
  String get requesterPhotoUrl => throw _privateConstructorUsedError;
  String get entertainerId => throw _privateConstructorUsedError;
  bool get played => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RequestCopyWith<Request> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestCopyWith<$Res> {
  factory $RequestCopyWith(Request value, $Res Function(Request) then) =
      _$RequestCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      String artist,
      String title,
      String notes,
      String requesterId,
      String requesterUsername,
      String requesterPhotoUrl,
      String entertainerId,
      bool played,
      @TimestampConverter() DateTime timestamp});
}

/// @nodoc
class _$RequestCopyWithImpl<$Res> implements $RequestCopyWith<$Res> {
  _$RequestCopyWithImpl(this._value, this._then);

  final Request _value;
  // ignore: unused_field
  final $Res Function(Request) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? artist = freezed,
    Object? title = freezed,
    Object? notes = freezed,
    Object? requesterId = freezed,
    Object? requesterUsername = freezed,
    Object? requesterPhotoUrl = freezed,
    Object? entertainerId = freezed,
    Object? played = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      artist: artist == freezed
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      notes: notes == freezed
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: requesterId == freezed
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      requesterUsername: requesterUsername == freezed
          ? _value.requesterUsername
          : requesterUsername // ignore: cast_nullable_to_non_nullable
              as String,
      requesterPhotoUrl: requesterPhotoUrl == freezed
          ? _value.requesterPhotoUrl
          : requesterPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      entertainerId: entertainerId == freezed
          ? _value.entertainerId
          : entertainerId // ignore: cast_nullable_to_non_nullable
              as String,
      played: played == freezed
          ? _value.played
          : played // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$RequestCopyWith<$Res> implements $RequestCopyWith<$Res> {
  factory _$RequestCopyWith(_Request value, $Res Function(_Request) then) =
      __$RequestCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      String artist,
      String title,
      String notes,
      String requesterId,
      String requesterUsername,
      String requesterPhotoUrl,
      String entertainerId,
      bool played,
      @TimestampConverter() DateTime timestamp});
}

/// @nodoc
class __$RequestCopyWithImpl<$Res> extends _$RequestCopyWithImpl<$Res>
    implements _$RequestCopyWith<$Res> {
  __$RequestCopyWithImpl(_Request _value, $Res Function(_Request) _then)
      : super(_value, (v) => _then(v as _Request));

  @override
  _Request get _value => super._value as _Request;

  @override
  $Res call({
    Object? id = freezed,
    Object? artist = freezed,
    Object? title = freezed,
    Object? notes = freezed,
    Object? requesterId = freezed,
    Object? requesterUsername = freezed,
    Object? requesterPhotoUrl = freezed,
    Object? entertainerId = freezed,
    Object? played = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_Request(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      artist: artist == freezed
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      notes: notes == freezed
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: requesterId == freezed
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      requesterUsername: requesterUsername == freezed
          ? _value.requesterUsername
          : requesterUsername // ignore: cast_nullable_to_non_nullable
              as String,
      requesterPhotoUrl: requesterPhotoUrl == freezed
          ? _value.requesterPhotoUrl
          : requesterPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      entertainerId: entertainerId == freezed
          ? _value.entertainerId
          : entertainerId // ignore: cast_nullable_to_non_nullable
              as String,
      played: played == freezed
          ? _value.played
          : played // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Request extends _Request {
  const _$_Request(
      {this.id,
      required this.artist,
      required this.title,
      required this.notes,
      required this.requesterId,
      required this.requesterUsername,
      required this.requesterPhotoUrl,
      required this.entertainerId,
      this.played = false,
      @TimestampConverter() required this.timestamp})
      : super._();

  factory _$_Request.fromJson(Map<String, dynamic> json) =>
      _$$_RequestFromJson(json);

  @override
  final String? id;
  @override
  final String artist;
  @override
  final String title;
  @override
  final String notes;
  @override
  final String requesterId;
  @override
  final String requesterUsername;
  @override
  final String requesterPhotoUrl;
  @override
  final String entertainerId;
  @override
  @JsonKey()
  final bool played;
  @override
  @TimestampConverter()
  final DateTime timestamp;

  @override
  String toString() {
    return 'Request(id: $id, artist: $artist, title: $title, notes: $notes, requesterId: $requesterId, requesterUsername: $requesterUsername, requesterPhotoUrl: $requesterPhotoUrl, entertainerId: $entertainerId, played: $played, timestamp: $timestamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Request &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.artist, artist) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.notes, notes) &&
            const DeepCollectionEquality()
                .equals(other.requesterId, requesterId) &&
            const DeepCollectionEquality()
                .equals(other.requesterUsername, requesterUsername) &&
            const DeepCollectionEquality()
                .equals(other.requesterPhotoUrl, requesterPhotoUrl) &&
            const DeepCollectionEquality()
                .equals(other.entertainerId, entertainerId) &&
            const DeepCollectionEquality().equals(other.played, played) &&
            const DeepCollectionEquality().equals(other.timestamp, timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(artist),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(notes),
      const DeepCollectionEquality().hash(requesterId),
      const DeepCollectionEquality().hash(requesterUsername),
      const DeepCollectionEquality().hash(requesterPhotoUrl),
      const DeepCollectionEquality().hash(entertainerId),
      const DeepCollectionEquality().hash(played),
      const DeepCollectionEquality().hash(timestamp));

  @JsonKey(ignore: true)
  @override
  _$RequestCopyWith<_Request> get copyWith =>
      __$RequestCopyWithImpl<_Request>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RequestToJson(this);
  }
}

abstract class _Request extends Request {
  const factory _Request(
      {final String? id,
      required final String artist,
      required final String title,
      required final String notes,
      required final String requesterId,
      required final String requesterUsername,
      required final String requesterPhotoUrl,
      required final String entertainerId,
      final bool played,
      @TimestampConverter() required final DateTime timestamp}) = _$_Request;
  const _Request._() : super._();

  factory _Request.fromJson(Map<String, dynamic> json) = _$_Request.fromJson;

  @override
  String? get id => throw _privateConstructorUsedError;
  @override
  String get artist => throw _privateConstructorUsedError;
  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get notes => throw _privateConstructorUsedError;
  @override
  String get requesterId => throw _privateConstructorUsedError;
  @override
  String get requesterUsername => throw _privateConstructorUsedError;
  @override
  String get requesterPhotoUrl => throw _privateConstructorUsedError;
  @override
  String get entertainerId => throw _privateConstructorUsedError;
  @override
  bool get played => throw _privateConstructorUsedError;
  @override
  @TimestampConverter()
  DateTime get timestamp => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$RequestCopyWith<_Request> get copyWith =>
      throw _privateConstructorUsedError;
}
