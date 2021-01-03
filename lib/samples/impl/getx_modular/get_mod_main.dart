import '../../interface/sample_interface.dart';

class GetXModMainSample extends Sample {
  GetXModMainSample() : super('lib/main.dart', overwrite: true);

  @override
  String get content => '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/translations/translations.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_route_observer.dart';
import 'app/utils/function/di.dart';
import 'generated/locales.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.instance.init();
  GlobalTranslation.I.setup(AppTranslation.translations);

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      navigatorObservers: [AppRouteObserver.instance],
      locale: Locale('en', "EN"),
      translations: GlobalTranslation.I,
    ),
  );
}
  ''';
}
