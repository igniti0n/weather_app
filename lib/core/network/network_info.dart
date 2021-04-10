import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkChecker {
  Future<bool> get hasConnection;
}

class NetworkInfo extends NetworkChecker {
  @override
  Future<bool> get hasConnection => InternetConnectionChecker().hasConnection;
}
