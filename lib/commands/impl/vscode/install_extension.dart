import 'dart:io';

import 'package:cli_menu/cli_menu.dart';

import '../../../common/utils/logger/LogUtils.dart';
import '../../../common/utils/shell/shel.utils.dart';
import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../../interface/command.dart';

class VSCodeExtensionCommand extends Command {
  @override
  Future<void> execute() async {
    String path;
    if (Platform.script.path.contains('code') ||
        Platform.script.path.contains('Microsoft VS Code')) {
      path = 'code';
    } else if (Platform.script.path.contains('vscode')) path = 'vscode';

    if (path == null) {
      LogService.error('VS Code not found in your path!!!');
      final tryAgain = Menu([
        'force install',
        'No Thanks',
      ]);
      path = 'code';
      if (tryAgain.choose().index == 1) return;
    }

    if (path != null) {
      ShellUtils.installVSCodePlugins(path, [
        'bendixma.dart-data-class-generator',
        'redhat.vscode-yaml',
        'luanpotter.dart-import',
      ]);
    }
  }

  @override
  String get hint => Translation(LocaleKeys.vscode_extension).tr;

  @override
  bool validate() {
    return true;
  }
}
