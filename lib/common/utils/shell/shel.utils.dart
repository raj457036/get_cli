import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:process_run/process_run.dart';

import '../../../core/generator.dart';
import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../logger/LogUtils.dart';
import '../pub_dev/pub_dev_api.dart';
import '../pubspec/pubspec_lock.dart';

class ShellUtils {
  static Future<void> pubGet() async {
    LogService.info('Running `flutter pub get` …');
    await run('flutter', ['pub', 'get'], verbose: true);
  }

  static Future<bool> loadAndExtractZip(
    String url, {
    String extractedPath = 'extracted/',
    String entryPath = '',
  }) async {
    final HttpClient client = HttpClient();
    final fileSave = File(
        'temp/${entryPath == null || entryPath == '' ? '' : '$entryPath'}load.zip');

    try {
      final HttpClientRequest request = await client.getUrl(Uri.parse(url));
      final HttpClientResponse response = await request.close();
      await response.pipe(fileSave.openWrite());
    } catch (e) {
      LogService.error('Error Occured: $e');
      return false;
    }

    LogService.info('Extracting...');
    final bytes = fileSave.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = 'temp/$extractedPath${file.name}';
      LogService.success('Added $filename');
      if (file.isFile) {
        final data = file.content as List<int>;
        File(filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        final dir = Directory(filename);
        await dir.create(recursive: true);
      }
    }

    return true;
  }

  static Future<bool> installFontify() async {
    LogService.info(
        'Fontify Service not installed. Installing, Please wait...');

    try {
      await run('flutter', ['pub', 'global', 'activate', 'fontify'],
          verbose: true);
      return true;
    } catch (e) {
      LogService.error(e);
      return false;
    }
  }

  static Future<bool> generateIcons(
    String path,
    String opath,
    String classFile, {
    String fontName = 'Custom Icons',
    String className = 'CustomIcons',
    bool recursive = true,
  }) async {
    LogService.info('Converting SVG from $path to $opath, please wait...');

    try {
      final cmds = [
        path,
        opath,
        '--font-name=$fontName',
        '--class-name=$className',
        '--output-class-file=$classFile'
      ];

      if (recursive) cmds.add('--recursive');
      print("Running... ${['fontify', ...cmds].join(" ")}");
      await run(
        'fontify',
        cmds,
        runInShell: true,
      );
      return true;
    } catch (e) {
      LogService.error(e);
      return false;
    }
  }

  static Future<void> clearTemp() async {
    LogService.info('Cleaning Project Structure...');
    try {
      await Directory('temp').delete(recursive: true);
    } catch (e) {
      LogService.info('something went wrong: $e');
    }
    LogService.success('Project Structure Cleaned.');
  }

  static Future<void> flutterCreate(String path, String org) async {
    LogService.info('Running `flutter create $path` …');
    await run('flutter', ['create', '--org', org, path], verbose: true);
  }

  static void installVSCodePlugins(
    String path,
    List<String> pluginNames,
  ) async {
    LogService.info('Installing Essential VSCode Plugins');

    final result = await run(path, ['--list-extensions'], verbose: true);
    final extensions = <String>{};

    if (result.stdout is String) {
      extensions.addAll(result.stdout.toString().toLowerCase().split('\n'));
    }

    for (var name in pluginNames) {
      LogService.info('Installing $name extension.');

      if (extensions.contains(name)) {
        LogService.success('Skipped: Extension $name already installed.');
        continue;
      }

      try {
        await run(
          path,
          ['--install-extension', '--force', name],
          verbose: true,
        );
        LogService.success('$name extension installed.');
      } catch (e) {
        LogService.error('$name extension Failed: $e');
      }
    }
  }

  static void update([isGit = false, forceUpdate = false]) async {
    isGit = GetCli.arguments.contains('--git');
    forceUpdate = GetCli.arguments.contains('-f');
    if (!isGit && !forceUpdate) {
      String versionInPubDev =
          await PubDevApi.getLatestVersionFromPackage('get_cli');

      String versionInstalled =
          await PubspecLock.getVersionCli(disableLog: true);

      if (versionInstalled == versionInPubDev) {
        return LogService.info(
            Translation(LocaleKeys.info_cli_last_version_already_installed.tr));
      }
    }

    LogService.info('Upgrading get_cli …');
    var res;
    if (Platform.script.path.contains('flutter')) {
      if (isGit) {
        res = await run(
            'flutter',
            [
              'pub',
              'global',
              'activate',
              '-sgit',
              'https://github.com/raj457036/get_cli.git'
            ],
            verbose: true);
      } else {
        res = await run(
            'flutter',
            [
              'pub',
              'global',
              'activate',
              '-sgit',
              'https://github.com/raj457036/get_cli.git',
            ],
            verbose: true);
      }
    } else {
      if (isGit) {
        res = await run(
            'pub',
            [
              'global',
              'activate',
              '-sgit',
              'https://github.com/raj457036/get_cli.git'
            ],
            verbose: true);
      } else {
        res = await run(
            'pub',
            [
              'global',
              'activate',
              '-sgit',
              'https://github.com/raj457036/get_cli.git'
            ],
            verbose: true);
      }
    }
    if (res.stderr.toString().isNotEmpty) {
      return LogService.error(LocaleKeys.error_update_cli.tr);
    }
    LogService.success(LocaleKeys.sucess_update_cli.tr);
  }
}
