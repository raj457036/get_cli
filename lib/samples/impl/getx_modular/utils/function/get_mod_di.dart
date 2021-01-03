import '../../../../interface/sample_interface.dart';

class GetXModDISample extends Sample {
  GetXModDISample()
      : super(
          'lib/app/utils/function/di.dart',
          overwrite: true,
        );

  @override
  String get content => '''import 'package:get/get.dart';

import '../../controllers/global_controller.dart';

class DI {
  DI._();

  static DI _instance = DI._();
  static DI get instance => _instance;

  Future<void> init() async {
    Get.put<GlobalController>(GlobalController());
  }
}

  ''';
}
