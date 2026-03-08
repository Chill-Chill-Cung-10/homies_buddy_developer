// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    _RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
      fullName: json['fullName'] as String,
      username: json['username'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      acceptTerms: json['acceptTerms'] as bool? ?? false,
    );

Map<String, dynamic> _$RegisterRequestToJson(_RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'fullName': instance.fullName,
      'username': instance.username,
      'phoneNumber': instance.phoneNumber,
      'acceptTerms': instance.acceptTerms,
    };
