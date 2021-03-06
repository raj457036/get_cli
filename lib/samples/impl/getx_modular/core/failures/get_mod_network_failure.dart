import '../../../../interface/sample_interface.dart';

class GetXModNetworkFailureSample extends Sample {
  GetXModNetworkFailureSample()
      : super(
          'lib/app/core/failures/_network_failures.dart',
          overwrite: true,
        );

  @override
  String get content => '''part of 'failures.dart';

// --------------------- codes ---------------------

const int BASE_NETWORK_FAILURE_CODE = 400000;
const int NO_INTERNET_CONNECTION_FAILURE_CODE = 400001;

// --------------------- classes ---------------------

class BaseNetworkFailure extends Failure {
  BaseNetworkFailure({
    String message,
    Exception actualException,
  }) : super(
          code: BASE_NETWORK_FAILURE_CODE,
          message: message ?? LocaleKeys.failures_base_network,
          actualException: actualException,
        );
}

class NoInternetConnectionFailure extends Failure {
  NoInternetConnectionFailure([actualException])
      : super(
          code: NO_INTERNET_CONNECTION_FAILURE_CODE,
          message: LocaleKeys.failures_no_internet,
          actualException: actualException,
        );
}

  ''';
}
