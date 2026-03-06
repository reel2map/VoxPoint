import 'dart:async';

import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

part 'profile_cubit.freezed.dart';
part 'profile_state.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState> {
  ProfileCubit(this._authManager, this._billingRepository, this._eventBus)
    : super(const ProfileState()) {
    init();
  }

  final AuthManager<UserEntity> _authManager;

  final BillingRepository _billingRepository;

  final EventBus _eventBus;

  StreamSubscription<BillingSubscriptionModified>? _billingModifiedSubscription;

  StreamSubscription<BillingSubscriptionCreated>? _billingCreatedSubscription;

  StreamSubscription<BillingSubscriptionDeleted>? _billingDeletedSubscription;

  Future<void> init() async {
    _billingModifiedSubscription ??= _eventBus
        .on<BillingSubscriptionModified>()
        .listen(_onBillingSubscriptionModified);

    _billingCreatedSubscription ??= _eventBus
        .on<BillingSubscriptionCreated>()
        .listen(_onBillingSubscriptionCreated);

    _billingDeletedSubscription ??= _eventBus
        .on<BillingSubscriptionDeleted>()
        .listen(_onBillingSubscriptionDeleted);

    emit(state.copyWith(user: _authManager.user.valueOrNull));

    final tenantId = _authManager.user.value.authenticatedOrNull?.tenant?.id;

    final response = await _billingRepository.getUsers(tenantId: tenantId);

    response.fold((failure) {}, (users) {
      emit(state.copyWith(users: users));
    });

    final result = await _billingRepository.getSubscriptions(
      tenantId: tenantId,
    );

    result.fold((failure) {}, (subscriptions) {
      emit(
        state.copyWith(
          status: FetchStatus.fetchingSuccess,
          subscriptions: subscriptions,
        ),
      );
    });
  }

  void _onBillingSubscriptionModified(BillingSubscriptionModified event) {
    final result =
        state.subscriptions.map((e) {
          if (event.data.id == e.id) {
            return event.data;
          } else {
            return e;
          }
        }).toList();

    emit(state.copyWith(subscriptions: result));
  }

  void _onBillingSubscriptionCreated(BillingSubscriptionCreated event) {
    emit(state.copyWith(subscriptions: [...state.subscriptions, event.data]));
  }

  void _onBillingSubscriptionDeleted(BillingSubscriptionDeleted event) {
    emit(
      state.copyWith(
        subscriptions:
            state.subscriptions.where((e) => e.id != event.data.id).toList(),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _billingModifiedSubscription?.cancel();

    await _billingCreatedSubscription?.cancel();

    await _billingDeletedSubscription?.cancel();

    await super.close();
  }

  Future<void> logout() async {
    //TODO: logout on web
    await _authManager.signOut();
  }
}
