import 'dart:io';

import 'package:get_cli/commands/impl/vscode/install_extension.dart';
import 'package:io/io.dart';

import '../../../../common/utils/logger/LogUtils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/create/create_list_directory.dart';
import '../../../../functions/create/create_main.dart';
import '../../commads_export.dart';
import '../../install/install_get.dart';

Future<void> createInitGetXModulerUpdate([String version = 'master']) async {
  bool canContinue = await createMain();
  if (!canContinue) return;

  await installGet();

  List<Directory> initialDirs = [
    Directory(Structure.replaceAsExpected(path: 'temp/module/')),
  ];

  createListDirectory(initialDirs);

  await ShellUtils.loadBranchFolder(version, extractedPath: 'temp/extracted/');

  await Future.wait([
    PubspecUtils.addAsset('assets/secrets/'),
    PubspecUtils.addAsset('assets/locales/'),
  ]);

  await copyPath(
    'temp/extracted/lib/',
    'lib/',
  );

  await copyPath(
    'temp/extracted/assets/',
    'assets/',
  );

  LogService.info('Extraction Complete...');

  LogService.info('Installing Dependencies');
  await PubspecUtils.installModuleDependencies(
    'temp/extracted/install.txt',
  );

  await Future.wait([
    CreatePageCommand().execute(dontAskIfExist: true),
    GenerateLocalesCommand().execute(),
  ]);

  await VSCodeExtensionCommand().execute();

  await ShellUtils.clearTemp();

  await ShellUtils.pubGet();
  LogService.success(Translation(LocaleKeys.sucess_getx_modular_generated));
}
