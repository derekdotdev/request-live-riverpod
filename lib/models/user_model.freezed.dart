// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String get photoUrl => throw _privateConstructorUsedError;
  bool get isEntertainer => throw _privateConstructorUsedError;
  UserLocation get location => throw _privateConstructorUsedError;
  bool? get podcastMode => throw _privateConstructorUsedError;
  bool get isLive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String email,
      String username,
      String? displayName,
      String? phoneNumber,
      String? bio,
      String? website,
      String photoUrl,
      bool isEntertainer,
      UserLocation location,
      bool? podcastMode,
      bool isLive});

  $UserLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? username = freezed,
    Object? displayName = freezed,
    Object? phoneNumber = freezed,
    Object? bio = freezed,
    Object? website = freezed,
    Object? photoUrl = freezed,
    Object? isEntertainer = freezed,
    Object? location = freezed,
    Object? podcastMode = freezed,
    Object? isLive = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: displayName == freezed
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: phoneNumber == freezed
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: bio == freezed
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      website: website == freezed
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: photoUrl == freezed
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isEntertainer: isEntertainer == freezed
          ? _value.isEntertainer
          : isEntertainer // ignore: cast_nullable_to_non_nullable
              as bool,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as UserLocation,
      podcastMode: podcastMode == freezed
          ? _value.podcastMode
          : podcastMode // ignore: cast_nullable_to_non_nullable
              as bool?,
      isLive: isLive == freezed
          ? _value.isLive
          : isLive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $UserLocationCopyWith<$Res> get location {
    return $UserLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value));
    });
  }
}

/// @nodoc
abstract class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) then) =
      __$UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String email,
      String username,
      String? displayName,
      String? phoneNumber,
      String? bio,
      String? website,
      String photoUrl,
      bool isEntertainer,
      UserLocation location,
      bool? podcastMode,
      bool isLive});

  @override
  $UserLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(_User _value, $Res Function(_User) _then)
      : super(_value, (v) => _then(v as _User));

  @override
  _User get _value => super._value as _User;

  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? username = freezed,
    Object? displayName = freezed,
    Object? phoneNumber = freezed,
    Object? bio = freezed,
    Object? website = freezed,
    Object? photoUrl = freezed,
    Object? isEntertainer = freezed,
    Object? location = freezed,
    Object? podcastMode = freezed,
    Object? isLive = freezed,
  }) {
    return _then(_User(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: displayName == freezed
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: phoneNumber == freezed
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: bio == freezed
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      website: website == freezed
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: photoUrl == freezed
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isEntertainer: isEntertainer == freezed
          ? _value.isEntertainer
          : isEntertainer // ignore: cast_nullable_to_non_nullable
              as bool,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as UserLocation,
      podcastMode: podcastMode == freezed
          ? _value.podcastMode
          : podcastMode // ignore: cast_nullable_to_non_nullable
              as bool?,
      isLive: isLive == freezed
          ? _value.isLive
          : isLive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_User extends _User {
  const _$_User(
      {required this.id,
      required this.email,
      required this.username,
      this.displayName,
      this.phoneNumber,
      this.bio,
      this.website,
      required this.photoUrl,
      required this.isEntertainer,
      required this.location,
      this.podcastMode,
      this.isLive = false})
      : super._();

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String username;
  @override
  final String? displayName;
  @override
  final String? phoneNumber;
  @override
  final String? bio;
  @override
  final String? website;
  @override
  final String photoUrl;
  @override
  final bool isEntertainer;
  @override
  final UserLocation location;
  @override
  final bool? podcastMode;
  @override
  @JsonKey()
  final bool isLive;

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, displayName: $displayName, phoneNumber: $phoneNumber, bio: $bio, website: $website, photoUrl: $photoUrl, isEntertainer: $isEntertainer, location: $location, podcastMode: $podcastMode, isLive: $isLive)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _User &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.username, username) &&
            const DeepCollectionEquality()
                .equals(other.displayName, displayName) &&
            const DeepCollectionEquality()
                .equals(other.phoneNumber, phoneNumber) &&
            const DeepCollectionEquality().equals(other.bio, bio) &&
            const DeepCollectionEquality().equals(other.website, website) &&
            const DeepCollectionEquality().equals(other.photoUrl, photoUrl) &&
            const DeepCollectionEquality()
                .equals(other.isEntertainer, isEntertainer) &&
            const DeepCollectionEquality().equals(other.location, location) &&
            const DeepCollectionEquality()
                .equals(other.podcastMode, podcastMode) &&
            const DeepCollectionEquality().equals(other.isLive, isLive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(username),
      const DeepCollectionEquality().hash(displayName),
      const DeepCollectionEquality().hash(phoneNumber),
      const DeepCollectionEquality().hash(bio),
      const DeepCollectionEquality().hash(website),
      const DeepCollectionEquality().hash(photoUrl),
      const DeepCollectionEquality().hash(isEntertainer),
      const DeepCollectionEquality().hash(location),
      const DeepCollectionEquality().hash(podcastMode),
      const DeepCollectionEquality().hash(isLive));

  @JsonKey(ignore: true)
  @override
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(this);
  }
}

abstract class _User extends User {
  const factory _User(
      {required final String id,
      required final String email,
      required final String username,
      final String? displayName,
      final String? phoneNumber,
      final String? bio,
      final String? website,
      required final String photoUrl,
      required final bool isEntertainer,
      required final UserLocation location,
      final bool? podcastMode,
      final bool isLive}) = _$_User;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get email => throw _privateConstructorUsedError;
  @override
  String get username => throw _privateConstructorUsedError;
  @override
  String? get displayName => throw _privateConstructorUsedError;
  @override
  String? get phoneNumber => throw _privateConstructorUsedError;
  @override
  String? get bio => throw _privateConstructorUsedError;
  @override
  String? get website => throw _privateConstructorUsedError;
  @override
  String get photoUrl => throw _privateConstructorUsedError;
  @override
  bool get isEntertainer => throw _privateConstructorUsedError;
  @override
  UserLocation get location => throw _privateConstructorUsedError;
  @override
  bool? get podcastMode => throw _privateConstructorUsedError;
  @override
  bool get isLive => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserCopyWith<_User> get copyWith => throw _privateConstructorUsedError;
}
