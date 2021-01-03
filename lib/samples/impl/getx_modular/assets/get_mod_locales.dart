import '../../../interface/sample_interface.dart';

class GetXModAssetLocalesSample extends Sample {
  GetXModAssetLocalesSample()
      : super(
          'assets/locales/en_EN.json',
          overwrite: true,
        );

  @override
  String get content => '''{

    "failures": {
        "base_network": "Network failure encountered.",
        "no_internet": "Internet not available",
        "base_general": "Some error encountered.",
        "base_database": "Database error encountered."
    }
}
  ''';
}
