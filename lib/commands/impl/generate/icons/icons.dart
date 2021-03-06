import 'dart:io';

import 'package:cli_dialog/cli_dialog.dart';
import 'package:cli_menu/cli_menu.dart';
import 'package:get_cli/common/utils/logger/LogUtils.dart';
import 'package:get_cli/common/utils/pubspec/pubspec_utils.dart';
import 'package:get_cli/common/utils/shell/shel.utils.dart';
import 'package:get_cli/functions/create/create_list_directory.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/cmd_run.dart';
import 'package:recase/recase.dart';

import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../interface/command.dart';
import '../../args_mixin.dart';

class GenerateIconsCommand extends Command with ArgsMixin {
  @override
  Future<void> execute() async {
    final installed = await isFontifyInstalled();

    String tipath = p.basenameWithoutExtension(withArgument).pascalCase;
    LogService.info('Use default SVG location (assets/icons)');
    final choice = Menu(['Yes', 'No']);
    final result = choice.choose();

    if (withArgument.isEmpty && result.index == 1) {
      final dialog = CLI_Dialog(questions: [
        ['Enter SVG directory path : ', 'tipath']
      ]);
      String result = dialog.ask()['tipath'];
      tipath = result.pascalCase;
    }

    if (installed) {
      await generateIcons(tipath);
      return;
    }

    final fontifyInstalled = await installFontify();

    if (fontifyInstalled) await generateIcons(tipath);
  }

  @override
  String get hint => LocaleKeys.hint_generate_icon.tr;

  @override
  bool validate() => true;

  Future<void> generateIcons(String tipath) async {
    var path = 'assets/icons/';

    if (tipath?.trim()?.isNotEmpty ?? false) {
      path = tipath.trim();
    }
    createListDirectory([
      Directory('fonts/icons/'),
      Directory('lib/app/core/icons/'),
    ]);
    final result = await ShellUtils.generateIcons(
      path,
      'fonts/icons/icon_font.otf',
      'lib/app/core/icons/icons.dart',
    );

    if (result) {
      // update pubspec yaml
      await PubspecUtils.addFont('fonts/icons/icon_font.otf', 'Custom Icons');
    }

    LogService.success('CustomIcons class Generated Successfully.');
  }

  Future<bool> isFontifyInstalled() async {
    final result = await run('fontify', []);
    return result.exitCode != 1;
  }

  Future<bool> installFontify() async {
    return ShellUtils.installFontify();
  }
}
