import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_app/constants.dart';
import 'package:interview_app/core/dialogs/exit_dialog.dart';
import 'package:interview_app/presentation/home_screen/suggestions_bloc/suggestions_bloc.dart';
import 'package:interview_app/presentation/home_screen/weather_bloc/weather_bloc.dart';
import 'package:interview_app/presentation/home_screen/widgets/search_bar.dart';
import 'package:interview_app/presentation/home_screen/widgets/weather_presentation.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance.get<WeatherBloc>(),
      child: Scaffold(
        backgroundColor: dark,
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
          onWillPop: () => showExitDialog(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 4,
                      child: WeatherPresentation(),
                    )
                  ],
                ),
                BlocProvider(
                  create: (_) => GetIt.instance.get<SuggestionsBloc>(),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 240,
                      ),
                      child: SearchBar()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
