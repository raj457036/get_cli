import 'dart:io';

import 'package:get_cli/commands/impl/vscode/install_extension.dart';
import 'package:get_cli/samples/impl/getx_modular/core/translations/get_mod_translations.dart';
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

Future<void> createInitGetXModulerUpdate([String version]) async {
  bool canContinue = await createMain();
  if (!canContinue) return;

  await installGet();

  List<Directory> initialDirs = [
    Directory(Structure.replaceAsExpected(path: 'temp/module/')),
  ];

  createListDirectory(initialDirs);

  LogService.info(
    'Downloading latest getx modular boilerplate from'
    ' `https://github.com/raj457036/flutter_getx_boiler_plate.git`',
  );
  String path =
      'https://github.com/raj457036/flutter_getx_boiler_plate/archive/master.zip';

  if (version != null) {
    path =
        'https://github.com/raj457036/flutter_getx_boiler_plate/archive/refs/heads/feature/$path.zip';
  }

  final done = await ShellUtils.loadAndExtractZip(
    path,
    entryPath: 'module/',
  );

  if (!done) {
    LogService.error('Extraction Failed');
    return false;
  }

  await Future.wait([
    PubspecUtils.addAsset('assets/secrets/'),
    PubspecUtils.addAsset('assets/locales/'),
  ]);

  await copyPath(
    'temp/extracted/flutter_getx_boiler_plate-master/lib/',
    'lib/',
  );

  await copyPath(
    'temp/extracted/flutter_getx_boiler_plate-master/assets/',
    'assets/',
  );

  LogService.info('Extraction Complete...');

  LogService.info('Installing Dependencies');
  await PubspecUtils.installModuleDependencies(
    'temp/extracted/flutter_getx_boiler_plate-master/install.txt',
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
