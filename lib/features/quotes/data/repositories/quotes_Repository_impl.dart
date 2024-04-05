import 'package:assignmenttask/core/error/failures.dart';
import 'package:assignmenttask/core/platform/network_info.dart';
import 'package:assignmenttask/features/quotes/data/datasources/quote_remote_Datasource.dart';
import 'package:assignmenttask/features/quotes/domain/entities/quotes.dart';
import 'package:assignmenttask/features/quotes/domain/repositories/quotes_repository.dart';
import 'package:dartz/dartz.dart';


class QuotesRepositoryImpl implements QuotesRepository{

  final QuoteRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  QuotesRepositoryImpl({required this.remoteDataSource,required this.networkInfo});

  
  @override
  Future<Either<Failure, Quotes>> getQuotes() async{
    if(await networkInfo.isConnected){
      try{
        final login =  await remoteDataSource.getQuotes();
        return Right(login);
      }catch(e){
        return Left(ServerFailure(serverFailureMessage: e.toString()));
      }
      
    }
    else{
      return const Left(ServerFailure(serverFailureMessage: "No Internet Connection"));
    }
  }
 
  
}