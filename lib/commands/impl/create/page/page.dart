import 'dart:io';

import 'package:cli_menu/cli_menu.dart';
import 'package:recase/recase.dart';

import '../../../../common/utils/logger/LogUtils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/generator.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../functions/routes/get_add_route.dart';
import '../../../../models/file_model.dart';
import '../../../../samples/impl/get_binding.dart';
import '../../../../samples/impl/get_controller.dart';
import '../../../../samples/impl/get_view.dart';
import '../../../interface/command.dart';
import '../../args_mixin.dart';

class CreatePageCommand extends Command with ArgsMixin {
  @override
  Future<void> execute({bool dontAskIfExist}) async {
    bool isProject = false;
    if (GetCli.arguments[0] == 'create') {
      isProject = GetCli.arguments[1].split(':').first == 'project';
    }
    FileModel _fileModel = Structure.model(
        isProject ? 'home' : name, 'page', true,
        on: onCommand, folderName: isProject ? 'home' : name);
    List<String> pathSplit = Structure.safeSplitPath(_fileModel.path);

    pathSplit.removeLast();
    String path = pathSplit.join('/');
    path = Structure.replaceAsExpected(path: path);
    if (Directory(path).existsSync()) {
      if (dontAskIfExist == true) {
        return;
      }

      LogService.info(Translation(LocaleKeys.ask_existing_page.trArgs([name])));
      final menu = Menu([
        LocaleKeys.options_yes.tr,
        LocaleKeys.options_no.tr,
      ]);
      final result = menu.choose();
      if (result.index == 0) {
        await _writeFiles(path, isProject ? 'home' : name, overwrite: true);
      }
    } else {
      Directory(path).createSync(recursive: true);
      await _writeFiles(path, isProject ? 'home' : name, overwrite: false);
    }
  }

  @override
  String get hint => LocaleKeys.hint_create_page.tr;

  @override
  bool validate() {
    return true;
  }

  Future<void> _writeFiles(String path, String name,
      {bool overwrite = false}) async {
    bool isServer = PubspecUtils.isServerProject;

    File controllerFile = handleFileCreate(
      name,
      'controller',
      path,
      true,
      ControllerSample('', name, isServer),
      'controllers',
    );
    String controllerDir = Structure.pathToDirImport(controllerFile.path);
    File viewFile = handleFileCreate(
      name,
      'view',
      path,
      true,
      GetViewSample('', name.pascalCase + 'View',
          name.pascalCase + 'Controller', controllerDir, isServer),
      'views',
    );
    File bindingFile = handleFileCreate(
      name,
      'binding',
      path,
      true,
      BindingSample(
        '',
        name,
        name.pascalCase + 'Binding',
        controllerDir,
        isServer,
        overwrite: overwrite,
      ),
      'bindings',
    );

    await addRoute(
      name,
      Structure.pathToDirImport(bindingFile.path),
      Structure.pathToDirImport(viewFile.path),
    );
    LogService.success(LocaleKeys.sucess_page_create.trArgs([name.pascalCase]));
    return;
  }
}
