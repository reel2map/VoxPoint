import 'package:intl/intl.dart';

class AuthI18n {
  static String get signIn =>
      Intl.message('Sign In', desc: 'Sign In title', name: 'AuthI18n_signIn');

  static String get login =>
      Intl.message('Log in', desc: 'Log in', name: 'AuthI18n_login');

  static String get loginRequired => Intl.message(
    'Login required',
    desc: 'Login required',
    name: 'AuthI18n_loginRequired',
  );

  static String get password =>
      Intl.message('Password', desc: 'Password', name: 'AuthI18n_password');

  static String get passwordRequired => Intl.message(
    'The password must not be empty',
    desc: 'Password validation message',
    name: 'AuthI18n_passwordRequired',
  );

  static String get userNotFound => Intl.message(
    'Incorrect username or password',
    desc: 'Incorrect username or password message',
    name: 'AuthI18n_userNotFound',
  );

  static String get minimumPassword => Intl.message(
    'Password must have at least 6 characters',
    desc: 'Password must have at least 6 characters',
    name: 'AuthI18n_minimumPassword',
  );

  static String get checkInternetConnection => Intl.message(
    'Check internet connection',
    desc: 'Check internet connection',
    name: 'AuthI18n_checkInternetConnection',
  );

  static String get enterPinCode => Intl.message(
    'Enter pin code',
    desc: 'Enter pin code',
    name: 'AuthI18n_enterPinCode',
  );

  static String get repeatPinCode => Intl.message(
    'Repeat pin code',
    desc: 'Repeat pin code',
    name: 'AuthI18n_repeatPinCode',
  );

  static String get settingPinCode => Intl.message(
    'Setting pin code',
    desc: 'Setting pin code',
    name: 'AuthI18n_settingPinCode',
  );

  static String pinCodeMustContain(int number) {
    return Intl.plural(
      number,
      one: 'Pin code must contain $number character',
      other: 'Pin code must contain $number characters',
      args: [number],
      desc: 'Pin codes must contain {number} character(s)',
      name: 'AuthI18n_pinCodeMustContain',
    );
  }

  static String get pinCodesDoNotMatch => Intl.message(
    'Pin codes do not match',
    desc: 'Pin codes do not match',
    name: 'AuthI18n_pinCodesDoNotMatch',
  );

  static String get invalidPin => Intl.message(
    'Invalid PIN',
    desc: 'Invalid PIN',
    name: 'AuthI18n_invalidPin',
  );

  static String get unknownError => Intl.message(
    'Unknown error. Please try later',
    desc: 'Unknown error. Please try later',
    name: 'AuthI18n_unknownError',
  );

  static String get signInToAccessTheApp => Intl.message(
    'Sign in to access the app',
    desc: 'Sign in to access the app',
    name: 'AuthI18n_signInToAccessTheApp',
  );

  static String get reset =>
      Intl.message('Reset', desc: 'Reset', name: 'AuthI18n_reset');

  static String get delete =>
      Intl.message('Delete', desc: 'Delete', name: 'AuthI18n_delete');

  static String get useBiometricsToLogin => Intl.message(
    'Use biometrics to login?',
    desc: 'Use biometrics to login?',
    name: 'AuthI18n_useBiometricsToLogin',
  );

  static String get resetTitle => Intl.message(
    'Are you sure?',
    desc: 'Are you sure?',
    name: 'AuthI18n_resetTitle',
  );

  static String get resetDescription => Intl.message(
    'After resetting the PIN-code, you will need to log in.',
    desc: 'After resetting the PIN-code, you will need to log in.',
    name: 'AuthI18n_resetDescription',
  );

  static String get aiHuman => Intl.message(
    'AI CUSTOMER\nENGAGEMENT\nPLATFORM',
    desc: 'AI Customer',
    name: 'AuthI18n_aiHuman',
  );

  static String get communication => Intl.message(
    'Engagement',
    desc: 'Engagement',
    name: 'AuthI18n_communication',
  );

  static String get platform =>
      Intl.message('Platform', desc: 'Platform', name: 'AuthI18n_platform');

  static String get description => Intl.message(
    'Boost revenue with AI agents that drive dynamic, two-way conversations — revealing customer needs and driving conversions at every step.',
    desc:
        'Enable your team to create AI Agents, launch campaigns, and handle exceptions in an AI-powered interface',
    name: 'AuthI18n_description',
  );

  static String get youAgree => Intl.message(
    'By signing up, you agree to our',
    desc: 'By signing up, you agree to our',
    name: 'AuthI18n_youAgree',
  );

  static String get termOfService => Intl.message(
    '`Terms of Service` and `Privacy Policy`',
    desc: '`Terms of Service` and `Privacy Policy`',
    name: 'AuthI18n_termOfService',
  );

  static String get personalInformation => Intl.message(
    'Personal Information',
    desc: 'Personal Information',
    name: 'AuthI18n_personalInformation',
  );

  static String get email =>
      Intl.message('Email', desc: 'Email', name: 'AuthI18n_email');

  static String get fullname =>
      Intl.message('Fullname', desc: 'Fullname', name: 'AuthI18n_fullname');

  static String get jobTitle =>
      Intl.message('Job Title', desc: 'Job Title', name: 'AuthI18n_jobTitle');

  static String get phoneNumber => Intl.message(
    'Phone number',
    desc: 'Phone number',
    name: 'AuthI18n_phoneNumber',
  );

  static String get organizationName => Intl.message(
    'Organization Name',
    desc: 'Organization Name',
    name: 'AuthI18n_organizationName',
  );

  static String get descriptionOrg => Intl.message(
    'Description',
    desc: 'Description',
    name: 'AuthI18n_descriptionOrg',
  );

  static String get phone =>
      Intl.message('Phone', desc: 'Phone', name: 'AuthI18n_phone');

  static String get billingEmail => Intl.message(
    'Billing email',
    desc: 'Billing email',
    name: 'AuthI18n_billingEmail',
  );

  static String get country =>
      Intl.message('Country', desc: 'Country', name: 'AuthI18n_country');

  static String get street =>
      Intl.message('Street', desc: 'Street', name: 'AuthI18n_street');

  static String get zipCode =>
      Intl.message('ZIP code', desc: 'ZIP code', name: 'AuthI18n_zipCode');

  static String get website =>
      Intl.message('Website', desc: 'Website', name: 'AuthI18n_website');

  static String get subscriptionInfo => Intl.message(
    'Subscription Info',
    desc: 'Subscription Info',
    name: 'AuthI18n_subscriptionInfo',
  );

  static String get name =>
      Intl.message('Name', desc: 'Name', name: 'AuthI18n_name');

  static String get sessionLimit => Intl.message(
    'Session Limit',
    desc: 'Session Limit',
    name: 'AuthI18n_sessionLimit',
  );

  static String get unlimited =>
      Intl.message('Unlimited', desc: 'Unlimited', name: 'AuthI18n_unlimited');

  static String get sessionCount => Intl.message(
    'Session count',
    desc: 'Session count',
    name: 'AuthI18n_sessionCount',
  );

  static String get subscriptionStatus => Intl.message(
    'Subscription status',
    desc: 'Subscription status',
    name: 'AuthI18n_subscriptionStatus',
  );

  static String get nextBillingDate => Intl.message(
    'Next billing date',
    desc: 'Next billing date',
    name: 'AuthI18n_nextBillingDate',
  );

  static String get extraSessionSubscription => Intl.message(
    'Extra session subscription',
    desc: 'Extra session subscription',
    name: 'AuthI18n_extraSessionSubscription',
  );

  static String get account =>
      Intl.message('Account', desc: 'Account', name: 'AuthI18n_account');

  static String get billing =>
      Intl.message('Billing', desc: 'Billing', name: 'AuthI18n_billing');

  static String get support =>
      Intl.message('Chat', desc: 'S', name: 'AuthI18n_support');

  static String get settings =>
      Intl.message('Settings', desc: 'S', name: 'AuthI18n_settings');

  static String get profile =>
      Intl.message('Profile', desc: 'Profile', name: 'AuthI18n_profile');

  static String get on => Intl.message('on', desc: 'on', name: 'AuthI18n_on');

  static String get off =>
      Intl.message('off', desc: 'off', name: 'AuthI18n_off');

  static String get deleteAccount => Intl.message(
    'Manage or delete your account at',
    name: 'AuthI18n_deleteAccount',
  );
}
