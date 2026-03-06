import 'package:auth/src/domain/models/auth/tenant/tenant_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

enum Role {
  @JsonValue('CLIENT_ADMIN')
  clientAdmin,
  @JsonValue('TENANT_ADMIN')
  tenantAdmin,
  @JsonValue('TENANT_USER')
  tenantUser,
  @JsonValue('TENANT_VIEWER')
  tenantViewer,
  @JsonValue('UNKNOWN')
  unknown;

  bool get isClientAdmin => this == clientAdmin;

  bool get isTenantAdmin => this == tenantAdmin;

  bool get isTenantUser => this == tenantUser;

  bool get isTenantViewer => this == tenantViewer;
}

@immutable
abstract class UserEntity {
  @literal
  const factory UserEntity.notAuthenticated() = NotAuthenticatedUser;

  const factory UserEntity.authenticated({
    required DateTime createdOn,
    required String createdBy,
    required DateTime modifiedOn,
    required String modifiedBy,
    required String id,
    required String name,
    required String email,
    required Role role,
    required bool isLightUi,
    String? phone,
    TenantEntity? tenant,
  }) = AuthenticatedUser;

  bool get isAuthenticated;
  bool get isNotAuthenticated;
  AuthenticatedUser? get authenticatedOrNull;

  T when<T extends Object?>({
    required T Function(AuthenticatedUser user) authenticated,
    required T Function() notAuthenticated,
  });

  bool get isDemo => isAuthenticated;
}

@immutable
class NotAuthenticatedUser implements UserEntity {
  @literal
  const NotAuthenticatedUser();

  @override
  bool get isAuthenticated => false;

  @override
  bool get isNotAuthenticated => true;

  @override
  AuthenticatedUser? get authenticatedOrNull => null;

  @override
  T when<T extends Object?>({
    required T Function(AuthenticatedUser user) authenticated,
    required T Function() notAuthenticated,
  }) => notAuthenticated();

  @override
  String toString() => 'User is not authenticated';

  @override
  bool operator ==(Object other) => other is NotAuthenticatedUser;

  @override
  int get hashCode => 0;

  @override
  bool get isDemo => false;
}

@freezed
abstract class AuthenticatedUser
    with _$AuthenticatedUser
    implements UserEntity {
  const factory AuthenticatedUser({
    @JsonKey(name: 'created_on') required DateTime createdOn,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'modified_on') required DateTime modifiedOn,
    @JsonKey(name: 'modified_by') required String modifiedBy,
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'role', unknownEnumValue: Role.unknown) required Role role,
    @JsonKey(name: 'is_light_ui') required bool isLightUi,
    @Default(MobilePushConfig())
    @JsonKey(name: 'mobile_push_config')
    MobilePushConfig mobilePushConfig,
    String? phone,
    TenantEntity? tenant,
  }) = _AuthenticatedUser;

  factory AuthenticatedUser.fromJson(Object? json) =>
      _$AuthenticatedUserFromJson(json! as Map<String, dynamic>);

  const AuthenticatedUser._();

  @override
  Map<String, dynamic> toJson();

  @override
  AuthenticatedUser? get authenticatedOrNull =>
      isNotAuthenticated ? null : this;

  @override
  bool get isAuthenticated => !isNotAuthenticated;

  @override
  bool get isNotAuthenticated => false;

  @override
  T when<T extends Object?>({
    required T Function(AuthenticatedUser user) authenticated,
    required T Function() notAuthenticated,
  }) {
    throw UnimplementedError();
  }

  @override
  bool get isDemo => email == 'demo';

  static AuthenticatedUser empty = AuthenticatedUser(
    id: '-1',
    email: '',
    createdOn: DateTime(2000),
    createdBy: '',
    modifiedOn: DateTime(2000),
    modifiedBy: '',
    name: 'empty',
    role: Role.unknown,
    isLightUi: true,
  );

  static AuthenticatedUser demo = AuthenticatedUser(
    id: '-2',
    email: 'demo',
    createdOn: DateTime(2000),
    createdBy: '',
    modifiedOn: DateTime(2000),
    modifiedBy: '',
    name: 'demo',
    role: Role.unknown,
    isLightUi: true,
  );

  String get fullName => name;

  String get shortName {
    return name;
  }
}

@freezed
abstract class MobilePushConfig with _$MobilePushConfig {
  const factory MobilePushConfig({
    @Default(false) @JsonKey(name: 'system_enabled') bool systemEnabled,
    @Default(false) @JsonKey(name: 'agents_enabled') bool agentsEnabled,
    @Default([]) List<BotSubscription> subscriptions,
  }) = _MobilePushConfig;

  factory MobilePushConfig.fromJson(Object? json) =>
      _$MobilePushConfigFromJson(json! as Map<String, dynamic>);

  @override
  Map<String, dynamic> toJson();
}

@freezed
abstract class BotSubscription with _$BotSubscription {
  const factory BotSubscription({
    @JsonKey(name: 'bot_id') required String botId,
    @Default([]) List<MobilePushConfigSettings> events,
  }) = _BotSubscription;

  factory BotSubscription.fromJson(Object? json) =>
      _$BotSubscriptionFromJson(json! as Map<String, dynamic>);

  @override
  Map<String, dynamic> toJson();
}

enum MobilePushConfigSettings {
  @JsonValue('new_session')
  newSession,
  @JsonValue('message_from_ai')
  messageFromAi,
  @JsonValue('message_from_human')
  messageFormHuman,
  @JsonValue('transferred_to_operator')
  transferredToOperator,
}
