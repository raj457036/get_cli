import '../../../interface/sample_interface.dart';

class GetXModAssetSecretSample extends Sample {
  GetXModAssetSecretSample()
      : super(
          'assets/secrets/secrets.json',
          overwrite: true,
        );

  @override
  String get content => '''{
    "production": {
       
    },
    "development": {
       
    }
}
  ''';
}
