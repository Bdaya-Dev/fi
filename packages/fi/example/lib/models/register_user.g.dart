// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUserModel _$RegisterUserModelFromJson(Map<String, dynamic> json) =>
    RegisterUserModel(
      email: json['email'] == null
          ? null
          : EmailFieldState.fromJson(json['email'] as Map<String, dynamic>),
      password: json['password'] == null
          ? null
          : PasswordFieldState.fromJson(
              json['password'] as Map<String, dynamic>),
      phoneNumbers: json['phoneNumbers'] == null
          ? null
          : PhoneFieldStateList.fromJson(
              json['phoneNumbers'] as Map<String, dynamic>),
      addresses: json['addresses'] == null
          ? null
          : UserAddressFieldStateList.fromJson(
              json['addresses'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterUserModelToJson(RegisterUserModel instance) =>
    <String, dynamic>{
      'email': instance.email.toJson(),
      'password': instance.password.toJson(),
      'phoneNumbers': instance.phoneNumbers.toJson(),
      'addresses': instance.addresses.toJson(),
    };
