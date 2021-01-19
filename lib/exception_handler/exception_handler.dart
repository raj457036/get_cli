import 'dart:io';

import '../common/utils/logger/LogUtils.dart';
import '../core/internationalization.dart';
import '../core/locales.g.dart';
import 'exceptions/cli_exception.dart';

class ExceptionHandler {
  void handle(dynamic e) {
    if (e is CliException) {
      LogService.error(e.message);
      if (e.codeSample.isNotEmpty) {
        LogService.info(LocaleKeys.example.tr, false, false);
        print(LogService.codeBold(e.codeSample));
      }
    } else if (e is FileSystemException) {
      if (e.osError.errorCode == 2) {
        LogService.error(LocaleKeys.error_file_not_found.trArgs([e.path]));
        return;
      } else if (e.osError.errorCode == 13) {
        LogService.error(LocaleKeys.error_access_denied.trArgs([e.path]));
        return;
      }
      _logException(e.message);
    } else {
      _logException(e.toString());
    }
    if (!Platform.isWindows) exit(0);
  }

  static void _logException(String msg) {
    LogService.error('${LocaleKeys.error_unexpected} $msg');
  }
}
