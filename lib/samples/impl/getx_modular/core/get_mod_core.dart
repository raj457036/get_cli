import '../../../interface/sample_interface.dart';

class GetXModCoreSample extends Sample {
  GetXModCoreSample()
      : super(
          'lib/app/core/core.dart',
          overwrite: true,
        );

  @override
  String get content => '''export 'environment/env.dart';
export 'exceptions/exceptions.dart';
export 'failures/failures.dart';
  ''';
}
