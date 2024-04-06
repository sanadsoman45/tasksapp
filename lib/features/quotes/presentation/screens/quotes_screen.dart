import 'package:assignmenttask/features/quotes/presentation/bloc/quotes_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assignmenttask/features/quotes/presentation/bloc/quotes_bloc.dart';
import 'package:assignmenttask/features/quotes/presentation/bloc/quotes_events.dart';

class QuotesScreen extends StatefulWidget {
  final QuotesBloc quotesBloc;

  const QuotesScreen({super.key, required this.quotesBloc});

  @override
  State<QuotesScreen> createState() => _QuotesScreen();
}

class _QuotesScreen extends State<QuotesScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.quotesBloc.state.quote.isEmpty) {
      widget.quotesBloc.add(getQuotes());
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenDimensions =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width;

    return BlocProvider.value(
        value: widget.quotesBloc,
        child: Scaffold(
          body: BlocBuilder<QuotesBloc, QuotesStates>(
            builder: (context, state) => Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenDimensions * 0.009,
                  vertical: screenDimensions * 0.009),
              decoration: BoxDecoration(
                  color: Colors.amberAccent.shade400,
                  borderRadius: BorderRadius.circular(20)),
              height: screenDimensions * 0.2,
              width: screenDimensions * 0.5,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Thought Of the Day",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: screenDimensions * 0.02),
                    ),
                    SizedBox(width: screenDimensions*0.01,),
                    const Icon(
                      Icons.lightbulb,
                      color: Colors.yellowAccent,
                    ),
                  ],
                ),
                SizedBox(height: screenDimensions*0.01,),
                Text(
                  state.quote,
                  style: TextStyle(
                      color: Colors.black, fontSize: screenDimensions * 0.03),
                )
              ]),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
