import '../../../../interface/sample_interface.dart';

class GetXModDbExceptionSample extends Sample {
  GetXModDbExceptionSample()
      : super(
          'lib/app/core/exceptions/_database_exceptions.dart',
          overwrite: true,
        );

  @override
  String get content => '''part of 'exceptions.dart';

class DatabaseException extends BaseException {
  const DatabaseException({
    String message,
    actualError,
  }) : super(
          message: message ?? "database exception encounterd",
          actualError: actualError,
        );
}

  ''';
}
