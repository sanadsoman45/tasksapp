import 'package:assignmenttask/features/quotes/domain/repositories/quotes_repository.dart';
import 'package:assignmenttask/features/quotes/presentation/bloc/quotes_events.dart';
import 'package:assignmenttask/features/quotes/presentation/bloc/quotes_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuotesBloc extends Bloc<QuotesEvents, QuotesStates> {
  final QuotesRepository quotesRepository;

  QuotesBloc({required this.quotesRepository}) : super(QuotesStates()) {
    //event to handle task name input
    on<getQuotes>((event, emit) async {
      final quotesModel = await quotesRepository.getQuotes();
      quotesModel.fold(
          (failure) => emit(state.copyWith(erroMessage: failure.toString())),
          (quotes) => emit(state.copyWith(quote: quotes.quote.toString())));
    });
  }
}
