import 'dart:io';

import 'package:cli_menu/cli_menu.dart';
import 'package:version/version.dart';
import 'package:yaml/yaml.dart';

import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../../../exception_handler/exceptions/cli_exception.dart';
import '../logger/LogUtils.dart';
import '../pub_dev/pub_dev_api.dart';
import '../shell/shel.utils.dart';
import 'package:get_cli/extensions.dart';

class PubspecUtils {
  static final _pubspec = File('pubspec.yaml');
  static final Map<String, dynamic> _mapSep = {
    'separator': '',
    'isChecked': false
  };
  static final Map<String, dynamic> _mapName = {'name': '', 'isChecked': false};

  static String _getProjectName() {
    _mapName['isChecked'] = true;
    var lines = _pubspec.readAsLinesSync();
    String name = lines
        .firstWhere((line) => line.startsWith('name:'), orElse: () => null)
        ?.split(':')
        ?.last
        ?.trim();
    return name;
  }

  static String getProjectName() {
    if (!_mapName['isChecked']) {
      _mapName['name'] = _getProjectName();
    }
    return _mapName['name'];
  }

  static Future<bool> addDependencies(String package,
      {String version, bool isDev = false, bool runPubGet = true}) async {
    var lines = _pubspec.readAsLinesSync();
    if (containsPackage(package)) {
      print(Translation(LocaleKeys.ask_package_already_installed)
          .trArgs([package]));
      final menu = Menu([
        LocaleKeys.options_yes.tr,
        LocaleKeys.options_no.tr,
      ]);
      final result = menu.choose();
      if (result.index != 0) {
        return false;
      }
    }
    lines.removeWhere((element) => element.startsWith('  $package:'));
    var index = isDev
        ? lines.indexWhere((element) => element.trim() == 'dev_dependencies:')
        : lines.indexWhere((element) => element.trim() == 'dependencies:');
    index++;
    version = version == null || version.isEmpty
        ? await PubDevApi.getLatestVersionFromPackage(package)
        : '^$version';
    if (version == null) return false;
    lines.insert(index, '  $package: $version');
    _pubspec.writeAsStringSync(lines.join('\n'));
    if (runPubGet) await ShellUtils.pubGet();
    LogService.success(LocaleKeys.sucess_package_installed.trArgs([package]));
    return true;
  }

  static void removeDependencies(String package, {bool logger = true}) async {
    if (logger) LogService.info('Removing package: "$package"');

    var lines = _pubspec.readAsLinesSync();
    if (containsPackage(package)) {
      lines.removeWhere((element) => element.startsWith('  $package:'));
      _pubspec.writeAsStringSync(lines.join('\n'));
      if (logger) {
        LogService.success(LocaleKeys.sucess_package_removed.trArgs([package]));
      }
    } else if (logger) {
      LogService.info(LocaleKeys.info_package_not_installed.trArgs([package]));
    }
  }

  static bool containsPackage(String package) {
    var lines = _pubspec.readAsLinesSync();

    int i = lines.indexWhere((element) => element.startsWith('  $package:'));
    return i != -1;
  }

  static bool get isServerProject {
    // LogService.info('Checking project type');

    var lines = _pubspec.readAsLinesSync();
    final serverLine = lines.firstWhere(
        (element) => element.split(':').first.trim() == 'get_server',
        orElse: () => '');

    if (serverLine.isEmpty) {
      // LogService.info('Flutter project detected!');
      return false;
    } else {
      //LogService.info('Get Server project detected!');
      return true;
    }
  }

  static Future<bool> addAsset(String path) async {
    var lines = _pubspec.readAsLinesSync();

    lines.removeWhere((element) => element.startsWith('    - $path'));
    int type = 0;

    var index = lines.indexWhere((element) {
      var trimmed = element.trimRight();
      if (trimmed == '  assets:') {
        type = 0;
        return true;
      }
      if (trimmed == '  # assets:') {
        type = 1;
        return true;
      }
      return false;
    });

    if (index == -1) {
      var flutterIndex =
          lines.indexWhere((element) => element.trimRight() == 'flutter:');

      flutterIndex++;
      lines.insert(flutterIndex, '  assets:');
      flutterIndex++;
      index = flutterIndex;
    }

    if (type == 1) {
      lines[index] = '  assets:';
    }

    index++;

    lines.insert(index, '    - $path');
    _pubspec.writeAsStringSync(lines.join('\n'));

    LogService.success(LocaleKeys.sucess_asset_added.trArgs([path]));
    return true;
  }

  static Future<bool> addFont(String path, String fontName) async {
    var lines = _pubspec.readAsLinesSync();

    lines.removeWhere((element) => element.startsWith('    - $path'));
    int type = 0;

    var index = lines.indexWhere((element) {
      var trimmed = element.trimRight();
      if (trimmed == '  fonts:') {
        type = 0;
        return true;
      }
      if (trimmed == '  # fonts:') {
        type = 1;
        return true;
      }
      return false;
    });

    if (index == -1) {
      var flutterIndex =
          lines.indexWhere((element) => element.trimRight() == 'flutter:');

      flutterIndex++;
      lines.insert(flutterIndex, '  fonts:');
      flutterIndex++;
      index = flutterIndex;
    }

    if (type == 1) {
      lines[index] = '  fonts:';
    }

    final fontIndex =
        lines.indexWhere((element) => element.trim() == '- family: $fontName');

    if (fontIndex != -1) {
      lines.removeRange(fontIndex, fontIndex + 3);
    }

    index++;

    lines.insert(index, '''
    - family: $fontName
      fonts:
        - asset: $path
''');
    _pubspec.writeAsStringSync(lines.join('\n'));

    LogService.success(LocaleKeys.sucess_asset_added.trArgs([path]));
    return true;
  }

  static Future<void> installModuleDependencies(String path) async {
    var file = File(path);
    if (!file.existsSync()) {
      return;
    }
    final lines = file.readAsLinesSync();

    for (var line in lines) {
      final info = line.split(' ');

      final package = info[0].split(':');
      final name = package.first;
      final version = package.length > 1 ? null : package.last;
      final isDev = info.length == 2;

      await addDependencies(name,
          version: version, isDev: isDev, runPubGet: false);
    }

    ShellUtils.pubGet();
  }

  static String get getPackageImport => !isServerProject
      ? "import 'package:get/get.dart';"
      : "import 'package:get_server/get_server.dart';";

  static Version getPackageVersion(String package) {
    var lines = _pubspec.readAsLinesSync();
    int index =
        lines.indexWhere((element) => element.startsWith('  $package:'));
    if (index != -1) {
      try {
        Version version =
            Version.parse(lines[index].split(':').last.trim().removeAll('^'));
        return version;
      } on FormatException catch (_) {
        return null;
      } catch (e) {
        rethrow;
      }
    } else {
      throw CliException(
          LocaleKeys.info_package_not_installed.trArgs([package]));
    }
  }

  static String get separatorFileType {
    if (!_mapSep['isChecked']) {
      _mapSep['separator'] = _separatorFileType;
    }
    return _mapSep['separator'];
  }

  static String get _separatorFileType {
    _mapSep['isChecked'] = true;
    YamlMap yaml = loadYaml(_pubspec.readAsStringSync());
    if (yaml.containsKey('get_cli')) {
      if (yaml['get_cli'].containsKey('separator')) {
        return yaml['get_cli']['separator'] ?? '';
      }
    }

    return '';
  }
}
