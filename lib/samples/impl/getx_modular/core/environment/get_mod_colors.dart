import '../../../../interface/sample_interface.dart';

class GetXModEnvColorsSample extends Sample {
  GetXModEnvColorsSample()
      : super(
          'lib/app/core/environment/_colors.dart',
          overwrite: true,
        );

  @override
  String get content => '''part of 'env.dart';

class _ColorStyles {
  final Color primaryColor = const Color(0x00000000);
  final Color secondaryColor = const Color(0x00000000);
  final Color accentColor = const Color(0x00000000);
}
  ''';
}
