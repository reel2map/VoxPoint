import 'package:intl/intl.dart';

class MainI18n {
  static String get calendarEventBottomMenuItem => Intl.message(
    'Календарь',
    desc: 'Calendar events bottom menu item',
    name: 'MainI18n_calendarEventBottomMenuItem',
  );

  static String get homeBottomMenuItem => Intl.message(
    'Home',
    desc: 'Home bottom menu item',
    name: 'MainI18n_homeBottomMenuItem',
  );

  static String get usersBottomMenuItem => Intl.message(
    'Users',
    desc: 'Users bottom menu item',
    name: 'MainI18n_usersBottomMenuItem',
  );

  static String get settingsBottomMenuItem => Intl.message(
    'Settings',
    desc: 'Settings bottom menu item',
    name: 'MainI18n_settingsBottomMenuItem',
  );

  static String get confirmation => Intl.message(
    'Confirmation',
    desc: 'Confirmation',
    name: 'MainI18n_confirmation',
  );

  static String get confirmationDescription => Intl.message(
    'Are you sure you want to close the application?',
    desc: 'Are you sure you want to close the application?',
    name: 'MainI18n_confirmationDescription',
  );
}
