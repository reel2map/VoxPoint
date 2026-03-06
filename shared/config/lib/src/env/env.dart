import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true, useConstantCase: true, name: 'EnvProd')
abstract class EnvProd {
  @EnviedField(varName: 'API_URL')
  static final String apiUrl = _EnvProd.apiUrl;

  @EnviedField(varName: 'TITLE')
  static final String title = _EnvProd.title;

  @EnviedField(varName: 'BLOCK_SECONDS')
  static final int blockSeconds = _EnvProd.blockSeconds;

  @EnviedField(varName: 'SECURE_KEY')
  static final String secureKey = _EnvProd.secureKey;

  @EnviedField(varName: 'OAUTH2_CLIENT_ID')
  static final String oauth2ClientId = _EnvProd.oauth2ClientId;

  @EnviedField(varName: 'OAUTH2_ISSUER')
  static final String oauth2Issuer = _EnvProd.oauth2Issuer;

  @EnviedField(varName: 'OAUTH2_REDIRECT_URI')
  static final String oauth2RedirectUri = _EnvProd.oauth2RedirectUri;

  @EnviedField(varName: 'TERM_OF_SERVICE_URL')
  static final String termOfServiceUrl = _EnvProd.termOfServiceUrl;

  @EnviedField(varName: 'PRIVACY_POLICE_URL')
  static final String privacyPolicyUrl = _EnvProd.privacyPolicyUrl;
}

@Envied(
  path: '.env.development',
  obfuscate: true,
  useConstantCase: true,
  name: 'EnvDev',
)
abstract class EnvDev {
  @EnviedField(varName: 'API_URL')
  static final String apiUrl = _EnvDev.apiUrl;

  @EnviedField(varName: 'TITLE')
  static final String title = _EnvDev.title;

  @EnviedField(varName: 'BLOCK_SECONDS')
  static final int blockSeconds = _EnvDev.blockSeconds;

  @EnviedField(varName: 'SECURE_KEY')
  static final String secureKey = _EnvDev.secureKey;

  @EnviedField(varName: 'OAUTH2_CLIENT_ID')
  static final String oauth2ClientId = _EnvDev.oauth2ClientId;

  @EnviedField(varName: 'OAUTH2_ISSUER')
  static final String oauth2Issuer = _EnvDev.oauth2Issuer;

  @EnviedField(varName: 'OAUTH2_REDIRECT_URI')
  static final String oauth2RedirectUri = _EnvDev.oauth2RedirectUri;

  @EnviedField(varName: 'TERM_OF_SERVICE_URL')
  static final String termOfServiceUrl = _EnvDev.termOfServiceUrl;

  @EnviedField(varName: 'PRIVACY_POLICE_URL')
  static final String privacyPolicyUrl = _EnvDev.privacyPolicyUrl;
}

@Envied(
  path: '.env.testing',
  obfuscate: true,
  useConstantCase: true,
  name: 'EnvTst',
)
abstract class EnvTst {
  @EnviedField(varName: 'API_URL')
  static final String apiUrl = _EnvTst.apiUrl;

  @EnviedField(varName: 'TITLE')
  static final String title = _EnvTst.title;

  @EnviedField(varName: 'BLOCK_SECONDS')
  static final int blockSeconds = _EnvTst.blockSeconds;

  @EnviedField(varName: 'SECURE_KEY')
  static final String secureKey = _EnvTst.secureKey;

  @EnviedField(varName: 'OAUTH2_CLIENT_ID')
  static final String oauth2ClientId = _EnvTst.oauth2ClientId;

  @EnviedField(varName: 'OAUTH2_ISSUER')
  static final String oauth2Issuer = _EnvTst.oauth2Issuer;

  @EnviedField(varName: 'OAUTH2_REDIRECT_URI')
  static final String oauth2RedirectUri = _EnvTst.oauth2RedirectUri;

  @EnviedField(varName: 'TERM_OF_SERVICE_URL')
  static final String termOfServiceUrl = _EnvTst.termOfServiceUrl;

  @EnviedField(varName: 'PRIVACY_POLICE_URL')
  static final String privacyPolicyUrl = _EnvTst.privacyPolicyUrl;
}

@Envied(
  path: '.env.demo',
  obfuscate: true,
  useConstantCase: true,
  name: 'EnvDemo',
)
abstract class EnvDemo {
  @EnviedField(varName: 'API_URL')
  static final String apiUrl = _EnvDemo.apiUrl;

  @EnviedField(varName: 'TITLE')
  static final String title = _EnvDemo.title;

  @EnviedField(varName: 'BLOCK_SECONDS')
  static final int blockSeconds = _EnvDemo.blockSeconds;

  @EnviedField(varName: 'SECURE_KEY')
  static final String secureKey = _EnvDemo.secureKey;

  @EnviedField(varName: 'OAUTH2_CLIENT_ID')
  static final String oauth2ClientId = _EnvDemo.oauth2ClientId;

  @EnviedField(varName: 'OAUTH2_ISSUER')
  static final String oauth2Issuer = _EnvDemo.oauth2Issuer;

  @EnviedField(varName: 'OAUTH2_REDIRECT_URI')
  static final String oauth2RedirectUri = _EnvDemo.oauth2RedirectUri;

  @EnviedField(varName: 'TERM_OF_SERVICE_URL')
  static final String termOfServiceUrl = _EnvDemo.termOfServiceUrl;

  @EnviedField(varName: 'PRIVACY_POLICE_URL')
  static final String privacyPolicyUrl = _EnvDemo.privacyPolicyUrl;
}
