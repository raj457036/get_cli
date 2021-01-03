import '../../../interface/sample_interface.dart';

class GetXModGlobalControllerSample extends Sample {
  GetXModGlobalControllerSample()
      : super(
          'lib/app/controllers/global_controller.dart',
          overwrite: true,
        );

  @override
  String get content => '''import 'package:get/get.dart';

class GlobalController extends GetxController {
  final _loaderOpened = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  // ------- getters -------
  bool get loaderOpened => _loaderOpened.value;

  // ------- public methods -------
  startLoading() {
    _loaderOpened.value = true;
  }

  stopLoading() {
    _loaderOpened.value = false;
  }
}
  ''';
}
