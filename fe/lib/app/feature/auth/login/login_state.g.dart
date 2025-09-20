// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginStateImpl _$$LoginStateImplFromJson(Map<String, dynamic> json) =>
    _$LoginStateImpl(
      phone: json['phone'] as String? ?? '',
      otp: json['otp'] as String? ?? '',
      isLoading: json['isLoading'] as bool? ?? false,
      otpSent: json['otpSent'] as bool? ?? false,
      resendTimer: (json['resendTimer'] as num?)?.toInt() ?? 60,
      canResend: json['canResend'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$LoginStateImplToJson(_$LoginStateImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'otp': instance.otp,
      'isLoading': instance.isLoading,
      'otpSent': instance.otpSent,
      'resendTimer': instance.resendTimer,
      'canResend': instance.canResend,
      'errorMessage': instance.errorMessage,
    };
