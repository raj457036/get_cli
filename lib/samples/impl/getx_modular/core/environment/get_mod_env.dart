import '../../../../interface/sample_interface.dart';

class GetXModEnvSample extends Sample {
  GetXModEnvSample()
      : super(
          'lib/app/core/environment/env.dart',
          overwrite: true,
        );

  @override
  String get content => '''import 'dart:convert';

import 'package:flutter/painting.dart';

import '../../utils/function/asset_loader.dart';
import '../../utils/function/logger.dart';


part '_colors.dart';
part '_environments.dart';
part '_values.dart';

class Env {
  final _ColorStyles _colorStyles = _ColorStyles();
  final _Values _values = _Values();
  final _Environment _environment = _Environment();

  Env._();

  static final Env _instance = Env._();

  static Env get I => _instance;
  static _ColorStyles get colors => I._colorStyles;
  static _Values get values => I._values;
  static _Environment get environment => I._environment;

  Future<void> init([String secretFilePath = "secrets/secrets.json"]) async {
    await environment.loadEnvironment(path: secretFilePath);
  }
}

  ''';
}
