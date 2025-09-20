import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hankan/app/model/channel_model.dart';
import 'package:hankan/app/model/sendbird_user_model.dart';

part 'message_state.freezed.dart';

@freezed
class MessageState with _$MessageState {
  const factory MessageState({
    @Default(false) bool isLoading,
    @Default(false) bool isConnected,
    @Default([]) List<ChannelModel> channels,
    SendbirdUserModel? currentUser,
    String? errorMessage,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = _MessageState;
}