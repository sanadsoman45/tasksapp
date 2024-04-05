import 'package:assignmenttask/core/error/failures.dart';
import 'package:assignmenttask/features/quotes/domain/entities/quotes.dart';
import 'package:dartz/dartz.dart';

abstract class QuotesRepository{
  Future<Either<Failure,Quotes>> getQuotes();
}