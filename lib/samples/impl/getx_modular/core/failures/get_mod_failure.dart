import '../../../../interface/sample_interface.dart';

class GetXModFailureSample extends Sample {
  GetXModFailureSample()
      : super(
          'lib/app/core/failures/failures.dart',
          overwrite: true,
        );

  @override
  String get content => '''import '../../../generated/locales.g.dart';

part '_database_failures.dart';
part '_general_failures.dart';
part '_network_failures.dart';

class Failure implements Type {
  final int code;
  final String message;
  final Exception actualException;

  const Failure({this.code, this.message, this.actualException});
}

  ''';
}
