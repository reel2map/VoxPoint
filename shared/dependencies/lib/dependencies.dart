/// {@template dependencies}
/// Dependencies package for JNP.
/// {@endtemplate}
library dependencies;

import 'package:dependencies/dependencies.dart';

export 'package:collection/collection.dart';
export 'package:cookie_jar/cookie_jar.dart';
export 'package:dartz/dartz.dart' show Either, Left, Right;
export 'package:dio/dio.dart';
export 'package:dio_cookie_manager/dio_cookie_manager.dart';
export 'package:event_bus/event_bus.dart';
export 'package:file_saver/file_saver.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_messaging/firebase_messaging.dart';
export 'package:flutter_appauth/flutter_appauth.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:get_it/get_it.dart';
export 'package:injectable/injectable.dart';
export 'package:intl/intl.dart';
export 'package:path_provider/path_provider.dart';
export 'package:permission_handler/permission_handler.dart';
export 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
export 'package:reactive_forms/reactive_forms.dart';
export 'package:rxdart/rxdart.dart';
export 'package:share_plus/share_plus.dart';
export 'package:uri/uri.dart';
export 'package:url_launcher/url_launcher.dart';

final sl = GetIt.I;
