import 'package:assignmenttask/features/quotes/domain/entities/quotes.dart';


class QuotesModel extends Quotes{

  const QuotesModel({required String quote}) : super(quote: quote);
  
  //get json From Quotes Object
  Map<String,dynamic> tojson(){
    return {
      'quote':quote
    };
  }

  //get Quotes object from json
  factory QuotesModel.fromJson(Map<String,dynamic> json){
    return QuotesModel(quote: json['text']);
  }
}