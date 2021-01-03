import 'dart:io';

import 'package:get_cli/samples/impl/getx_modular/core/translations/get_mod_translations.dart';

import '../../../../common/utils/logger/LogUtils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/create/create_list_directory.dart';
import '../../../../functions/create/create_main.dart';
import '../../../../samples/impl/getx_modular/getx_mod_samples.dart';
import '../../../../samples/impl/getx_modular/utils/overlays/get_mod_loader.dart';
import '../../commads_export.dart';
import '../../commads_export.dart';
import '../../install/install_get.dart';

Future<void> createInitGetXModuler() async {
  bool canContinue = await createMain();
  if (!canContinue) return;

  await installGet();

  List<Directory> initialDirs = [
    Directory(Structure.replaceAsExpected(path: 'assets/locales/')),
    Directory(Structure.replaceAsExpected(path: 'assets/secrets/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/controllers/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/core/environment')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/core/exceptions')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/core/failures')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/core/translations')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/data/models')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/data/providers')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/data/repositories')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/global')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/themes')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/utils/functions')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/utils/overlays')),
  ];
  GetXModMainSample().create();
  GetXModAssetLoaderSample().create();
  GetXModAssetLoaderSample().create();
  GetXModAssetLocalesSample().create();
  GetXModAssetSecretSample().create();
  GetXModCoreSample().create();
  GetXModDISample().create();
  GetXModDatabaseFailureSample().create();
  GetXModDbExceptionSample().create();
  GetXModEitherSample().create();
  GetXModEnvColorsSample().create();
  GetXModEnvEnvironmentsSample().create();
  GetXModEnvSample().create();
  GetXModEnvValuesSample().create();
  GetXModExceptionSample().create();
  GetXModFailureSample().create();
  GetXModNetworkFailureSample().create();
  GetXModGeneralExceptionSample().create();
  GetXModGeneralFailureSample().create();
  GetXModGlobalControllerSample().create();
  GetXModLogServiceSample().create();
  GetXModNetworkExceptionSample().create();
  GetXModNetworkFailureSample().create();
  GetXModRouteObserverSample().create();
  GetXModLoaderSample().create();
  GetXModTranslationsSample().create();
  await Future.wait([
    PubspecUtils.addAsset('assets/secrets/'),
    PubspecUtils.addAsset('assets/locales/'),
  ]);
  await Future.wait([
    CreatePageCommand().execute(),
    GenerateLocalesCommand().execute(),
  ]);
  createListDirectory(initialDirs);
  await ShellUtils.pubGet();
  LogService.success(Translation(LocaleKeys.sucess_getx_modular_generated));
}
