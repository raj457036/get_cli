import '../../../../interface/sample_interface.dart';

class GetXModGeneralFailureSample extends Sample {
  GetXModGeneralFailureSample()
      : super(
          'lib/app/core/failures/_general_failures.dart',
          overwrite: true,
        );

  @override
  String get content => '''part of 'failures.dart';

// --------------------- codes ---------------------

const int BASE_GENERAL_FAILURE_CODE = 300000;

// --------------------- classes ---------------------

class BaseGeneralFailure extends Failure {
  BaseGeneralFailure({
    String message,
    Exception actualException,
  }) : super(
          code: BASE_GENERAL_FAILURE_CODE,
          message: message ?? LocaleKeys.failures_base_general,
          actualException: actualException,
        );
}

  ''';
}
