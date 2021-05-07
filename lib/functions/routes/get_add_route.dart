import 'dart:convert';
import 'dart:io';

import 'package:recase/recase.dart';

import '../../common/utils/logger/LogUtils.dart';
import '../../core/internationalization.dart';
import '../../core/locales.g.dart';
import '../../samples/impl/get_route.dart';
import '../create/create_single_file.dart';
import '../find_file/find_file_by_name.dart';
import '../formatter_dart_file/frommatter_dart_file.dart';
import 'get_app_pages.dart';
import 'get_support_children.dart';

Future<void> addRoute(
    String nameRoute, String bindingDir, String viewDir) async {
  File routesFile = findFileByName('app_routes.dart');
  List<String> lines = [];

  if (routesFile.path.isEmpty) {
    RouteSample().create(skipFormatter: true);
    routesFile = File(RouteSample().path);
    lines = routesFile.readAsLinesSync();
  } else {
    String content = formatterDartFile(routesFile.readAsStringSync());
    lines = LineSplitter.split(content).toList();
  }
  List<String> pathSplit = viewDir.split('/');
  //remove file
  pathSplit.removeLast();
  // remove view folder
  pathSplit.removeLast();

  pathSplit.removeWhere((element) => element == 'app' || element == 'modules');

  for (var i = 0; i < pathSplit.length; i++) {
    pathSplit[i] =
        pathSplit[i].snakeCase.snakeCase.toLowerCase().replaceAll('_', '-');
  }
  String route = pathSplit.join('/');

  int indexEndRoutes = lines.indexWhere((element) => element.startsWith('}'));

  String line =
      "static const ${nameRoute.snakeCase.toUpperCase()} = '/$route';";

  if (supportChildrenRoutes) {
    line =
        'static const ${nameRoute.snakeCase.toUpperCase()} = ${_pathsToRoute(pathSplit)};';
    int indexEndPaths =
        lines.lastIndexWhere((element) => element.startsWith('}'));

    String linePath =
        "static const ${nameRoute.snakeCase.toUpperCase()} = '/${pathSplit.last}';";
    lines.insert(indexEndPaths, linePath);
  }

  if (lines.contains(line)) {
    return;
  }

  lines.insert(indexEndRoutes, line);

  writeFile(routesFile.path, lines.join('\n'), overwrite: true, logger: false);
  LogService.success(
      Translation(LocaleKeys.sucess_route_created).trArgs([nameRoute]));

  await addAppPage(nameRoute, bindingDir, viewDir);
}

String _pathsToRoute(List<String> pathSplit) {
  StringBuffer sb = StringBuffer();
  pathSplit.forEach((element) {
    sb.write('_Paths.');
    sb.write(element.snakeCase.toUpperCase());
    if (element != pathSplit.last) {
      sb.write(' + ');
    }
  });
  return sb.toString();
}
