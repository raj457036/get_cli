import '../../../../interface/sample_interface.dart';

class GetXModEnvValuesSample extends Sample {
  GetXModEnvValuesSample()
      : super(
          'lib/app/core/environment/_values.dart',
          overwrite: true,
        );

  @override
  String get content => '''part of 'env.dart';

class _Values {
  final String loaderRouteName = "_loader";
}
  ''';
}
