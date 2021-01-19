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

    if (path == null) {
      LogService.error('Are you sure VS Code is installed in this device?');
      final tryAgain = Menu([
        'Yes, It is.',
        'No, It isn\'t.',
      ]);
      path = 'code';
      if (tryAgain.choose().index == 1) {
        LogService.info('Skipping VS CODE Extension as it is not installed.');
        return;
      }
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
