import 'package:config/config.dart';
import 'package:config/src/env/env.dart';

/// This class is used to map the generated env from
/// envied generator based on the app flavor.
class Env {
  const Env._();

  static String apiUrl = switch (Flavor.status) {
    FlavorStatus.development => EnvDev.apiUrl,
    FlavorStatus.testing => EnvTst.apiUrl,
    FlavorStatus.production => EnvProd.apiUrl,
    FlavorStatus.demo => EnvProd.apiUrl,
  };

  static String title = switch (Flavor.status) {
    FlavorStatus.development => EnvDev.title,
    FlavorStatus.testing => EnvTst.title,
    FlavorStatus.production => EnvProd.title,
    FlavorStatus.demo => EnvDemo.title,
  };

  static Duration blockSeconds = switch (Flavor.status) {
    FlavorStatus.development => Duration(seconds: EnvDev.blockSeconds),
    FlavorStatus.testing => Duration(seconds: EnvTst.blockSeconds),
    FlavorStatus.production => Duration(seconds: EnvProd.blockSeconds),
    FlavorStatus.demo => Duration(seconds: EnvDemo.blockSeconds),
  };

  static int pinCodeLength = switch (Flavor.status) {
    FlavorStatus.development => 4,
    FlavorStatus.testing => 4,
    FlavorStatus.production => 4,
    FlavorStatus.demo => 4,
  };

  static String secureKey = switch (Flavor.status) {
    FlavorStatus.development => EnvDev.secureKey,
    FlavorStatus.testing => EnvTst.secureKey,
    FlavorStatus.production => EnvProd.secureKey,
    FlavorStatus.demo => EnvDemo.secureKey,
  };

  static String oauth2Issuer = switch (Flavor.status) {
    FlavorStatus.development => EnvDev.oauth2Issuer,
    FlavorStatus.testing => EnvTst.oauth2Issuer,
    FlavorStatus.production => EnvProd.oauth2Issuer,
    FlavorStatus.demo => EnvDemo.oauth2Issuer,
  };

  static String oauth2ClientId = switch (Flavor.status) {
    FlavorStatus.development => EnvDev.oauth2ClientId,
    FlavorStatus.testing => EnvTst.oauth2ClientId,
    FlavorStatus.production => EnvProd.oauth2ClientId,
    FlavorStatus.demo => EnvDemo.oauth2ClientId,
  };

  static String oauth2RedirectUri = switch (Flavor.status) {
    FlavorStatus.development => EnvDev.oauth2RedirectUri,
    FlavorStatus.testing => EnvTst.oauth2RedirectUri,
    FlavorStatus.production => EnvProd.oauth2RedirectUri,
    FlavorStatus.demo => EnvDemo.oauth2RedirectUri,
  };

  static String termOfServiceUrl = switch (Flavor.status) {
    FlavorStatus.development => EnvDev.termOfServiceUrl,
    FlavorStatus.testing => EnvTst.termOfServiceUrl,
    FlavorStatus.production => EnvProd.termOfServiceUrl,
    FlavorStatus.demo => EnvDemo.termOfServiceUrl,
  };

  static String privacyPolicyUrl = switch (Flavor.status) {
    FlavorStatus.development => EnvDev.privacyPolicyUrl,
    FlavorStatus.testing => EnvTst.privacyPolicyUrl,
    FlavorStatus.production => EnvProd.privacyPolicyUrl,
    FlavorStatus.demo => EnvDemo.privacyPolicyUrl,
  };
}
