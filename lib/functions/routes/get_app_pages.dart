import 'dart:convert';
import 'dart:io';

import 'package:recase/recase.dart';

import '../../common/utils/logger/LogUtils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../samples/impl/get_app_pages.dart';
import '../create/create_single_file.dart';
import '../find_file/find_file_by_name.dart';
import '../formatter_dart_file/frommatter_dart_file.dart';
import 'get_support_children.dart';

Future<void> addAppPage(String name, String bindingDir, String viewDir) async {
  File appPagesFile = findFileByName('app_pages.dart');
  String path = viewDir;
  List<String> lines = [];
  if (appPagesFile.path.isEmpty) {
    AppPagesSample().create(skipFormatter: true);
    appPagesFile = File(AppPagesSample().path);
    lines = appPagesFile.readAsLinesSync();
  } else {
    String content = formatterDartFile(appPagesFile.readAsStringSync());
    lines = LineSplitter.split(content).toList();
  }

  String routesOrPath = 'Routes';

  int indexRoutes = lines
      .indexWhere((element) => element.trim().contains('static final routes'));
  int index =
      lines.indexWhere((element) => element.contains('];'), indexRoutes);

  int tabEspaces = 2;
  if (supportChildrenRoutes) {
    routesOrPath = '_Paths';
    List<String> pathSplit = path.split('/');
    pathSplit.removeLast();
    pathSplit.removeLast();
    pathSplit
        .removeWhere((element) => element == 'app' || element == 'modules');
    int onPageIndex = -1;
    while (pathSplit.isNotEmpty && onPageIndex == -1) {
      onPageIndex = lines.indexWhere(
          (element) => element
              .contains('_Paths.${pathSplit.last.snakeCase.toUpperCase()},'),
          indexRoutes);

      pathSplit.removeLast();
    }
    if (onPageIndex != -1) {
      int onPageStartIndex = lines
          .sublist(0, onPageIndex)
          .lastIndexWhere((element) => element.contains('GetPage'));

      int onPageEndIndex = -1;

      if (onPageStartIndex != -1) {
        onPageEndIndex = lines.indexWhere(
            (element) => element.startsWith(
                _getTabs(_countTabs(lines[onPageStartIndex])) + '),'),
            onPageStartIndex);
      } else {
        _logInvalidFormart();
      }
      if (onPageEndIndex != -1) {
        int indexChildrenStart = lines
            .sublist(onPageStartIndex, onPageEndIndex)
            .indexWhere((element) => element.contains('children'));
        if (indexChildrenStart == -1) {
          tabEspaces = _countTabs(lines[onPageStartIndex]) + 1;
          index = onPageEndIndex;
          lines.insert(index, _getTabs(tabEspaces) + 'children: [');
          index++;
          lines.insert(index, _getTabs(tabEspaces) + '],');
          tabEspaces++;
        } else {
          int indexChildrenEnd = -1;
          indexChildrenEnd = lines.indexWhere(
              (element) => element.startsWith(
                  _getTabs(_countTabs(lines[onPageStartIndex]) + 1) + '],'),
              onPageStartIndex);
          if (indexChildrenEnd != -1) {
            index = indexChildrenEnd;
            tabEspaces = _countTabs(lines[onPageStartIndex]) + 2;
          } else {
            _logInvalidFormart();
          }
        }
      } else {
        _logInvalidFormart();
      }
    }
  }
  String nameSnakeCase = name.snakeCase;
  String namePascalCase = name.pascalCase;
  String line = '''${_getTabs(tabEspaces)}GetPage(
${_getTabs(tabEspaces + 1)}name: $routesOrPath.${nameSnakeCase.toUpperCase()}, 
${_getTabs(tabEspaces + 1)}page:()=> ${namePascalCase}View(), 
${_getTabs(tabEspaces + 1)}binding: ${namePascalCase}Binding(),
${_getTabs(tabEspaces)}),''';

  String import = "import 'package:${PubspecUtils.getProjectName()}/";

  lines.insert(index, line);

  lines.insert(0, import + bindingDir + "';");
  lines.insert(0, import + viewDir + "';");

  writeFile(appPagesFile.path, lines.join('\n'),
      overwrite: true, logger: false);
}

String _getTabs(int tabEspaces) {
  String string = '';
  for (var i = 0; i < tabEspaces; i++) {
    string += '  ';
  }
  return string;
}

int _countTabs(String line) {
  return '  '.allMatches(line).length;
}

void _logInvalidFormart() {
  LogService.info(
      'the app_pages.dart file does not meet the '
      'expected format, fails to create children pages',
      false,
      false);
}
