// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryStateImpl _$$HistoryStateImplFromJson(Map<String, dynamic> json) =>
    _$HistoryStateImpl(
      mySpaces: (json['mySpaces'] as List<dynamic>?)
              ?.map(
                  (e) => MySpaceReservation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      myRentals: (json['myRentals'] as List<dynamic>?)
              ?.map((e) =>
                  MyRentalReservation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isLoading: json['isLoading'] as bool? ?? false,
      selectedTab: (json['selectedTab'] as num?)?.toInt() ?? 0,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$HistoryStateImplToJson(_$HistoryStateImpl instance) =>
    <String, dynamic>{
      'mySpaces': instance.mySpaces,
      'myRentals': instance.myRentals,
      'isLoading': instance.isLoading,
      'selectedTab': instance.selectedTab,
      'errorMessage': instance.errorMessage,
    };
