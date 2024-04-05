import 'package:equatable/equatable.dart';

class Quotes extends Equatable{

  final String quote;

  const Quotes({required this.quote});
  
  @override
  List<Object?> get props => [quote];
}