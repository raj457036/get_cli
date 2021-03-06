import '../../../../interface/sample_interface.dart';

class GetXModTranslationsSample extends Sample {
  GetXModTranslationsSample()
      : super(
          'lib/app/core/translations/translations.dart',
          overwrite: true,
        );

  @override
  String get content => '''import 'package:get/get.dart';

class GlobalTranslation extends Translations {
  GlobalTranslation._();

  Map<String, Map<String, String>> _translations =
      Map<String, Map<String, String>>();

  static GlobalTranslation _instance = GlobalTranslation._();

  static GlobalTranslation get instance => _instance;
  static GlobalTranslation get I => _instance;

  @override
  Map<String, Map<String, String>> get keys => _translations;

  setup(Map<String, Map<String, String>> translations) =>
      _translations = translations;
}

  ''';
}
