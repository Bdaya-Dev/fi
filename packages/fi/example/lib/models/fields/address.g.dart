// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAddress _$UserAddressFromJson(Map<String, dynamic> json) => UserAddress(
      country: json['country'] == null
          ? null
          : CountryFieldState.fromJson(json['country'] as Map<String, dynamic>),
      fullAddress: json['fullAddress'] == null
          ? null
          : RequiredStringFieldState.fromJson(
              json['fullAddress'] as Map<String, dynamic>),
      postalCode: json['postalCode'] == null
          ? null
          : FiState<String?, dynamic>.fromJson(
              json['postalCode'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserAddressToJson(UserAddress instance) =>
    <String, dynamic>{
      'country': instance.country.toJson(),
      'fullAddress': instance.fullAddress.toJson(),
      'postalCode': instance.postalCode.toJson(),
    };
