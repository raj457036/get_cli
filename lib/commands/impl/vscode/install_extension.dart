import 'dart:io';

import '../../../common/utils/logger/LogUtils.dart';
import '../../../common/utils/shell/shel.utils.dart';
import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../../interface/command.dart';

class VSCodeExtensionCommand extends Command {
  @override
  Future<void> execute() async {
    String path;
    if (Platform.script.path.contains('code')) {
      path = 'code';
    } else if (Platform.script.path.contains('vscode')) path = 'vscode';

    if (path != null) {
      ShellUtils.installVSCodePlugins(path, [
        'bendixma.dart-data-class-generator',
        'redhat.vscode-yaml',
      ]);
    } else {
      LogService.error('VS Code not found in your path!!!');
    }
  }

  @override
  String get hint => Translation(LocaleKeys.vscode_extension).tr;

  @override
  bool validate() {
    return true;
  }
}
