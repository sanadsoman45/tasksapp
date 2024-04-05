import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo{
  Future<bool> get isConnected;
}

//implementation class of network info to check internet connectivity.
class Networkinfoimpl implements NetworkInfo{

  //dependency to check internet connection.
  final InternetConnectionChecker internetConnectionChecker;

  //constructor to initialize the internet connection checker.
  const Networkinfoimpl({required this.internetConnectionChecker});

  //overriding the abstract method to check data connectivity is available or not?
  @override
  Future<bool> get isConnected=>internetConnectionChecker.hasConnection;
} 