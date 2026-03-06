part of 'profile_cubit.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(FetchStatus.pure) FetchStatus status,
    UserEntity? user,
    @Default([]) List<SubscriptionEntity> subscriptions,
    @Default([]) List<UserEntity> users,
    String? error,
  }) = _ProfileState;

  const ProfileState._();
}
