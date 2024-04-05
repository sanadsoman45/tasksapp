class QuotesStates {
  final String quote;
  final String erroMessage;

  QuotesStates({this.quote = '', this.erroMessage = ''});

  QuotesStates copyWith({String? quote, String? erroMessage}) {
    return QuotesStates(
        quote: quote ?? this.quote,
        erroMessage: erroMessage ?? this.erroMessage);
  }
}
