// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryStateImpl _$$HistoryStateImplFromJson(Map<String, dynamic> json) =>
    _$HistoryStateImpl(
      rentalHistories: (json['rentalHistories'] as List<dynamic>?)
              ?.map((e) => RentalHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isLoading: json['isLoading'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$HistoryStateImplToJson(_$HistoryStateImpl instance) =>
    <String, dynamic>{
      'rentalHistories': instance.rentalHistories,
      'isLoading': instance.isLoading,
      'errorMessage': instance.errorMessage,
    };
