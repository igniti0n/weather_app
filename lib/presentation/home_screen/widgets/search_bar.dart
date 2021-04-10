import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_app/constants.dart';
import 'package:interview_app/core/dialogs/error_dialog.dart';
import 'package:interview_app/core/dialogs/exit_dialog.dart';
import 'package:interview_app/domain/entities/suggestion.dart';
import 'package:interview_app/presentation/home_screen/suggestions_bloc/suggestions_bloc.dart';
import 'package:interview_app/presentation/home_screen/weather_bloc/weather_bloc.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController _searchController;
  late final FocusNode _textFocusNode;
  Timer? _fetchSuggestionsTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _textFocusNode.dispose();
    _fetchSuggestionsTimer?.cancel();
    super.dispose();
  }

  String _currentValue = "";

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
        ),
        TextField(
          controller: _searchController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onSubmitted: (text) {
            BlocProvider.of<SuggestionsBloc>(context, listen: false)
                .add(CloseSuggestions());
            if (text.isNotEmpty) {
              BlocProvider.of<WeatherBloc>(context, listen: false)
                  .add(FetchWeather(city: text));
            }
          },
          onChanged: (String input) {
            _currentValue = input;
            _fetchSuggestions(input, context);
          },
          onTap: () => _fetchSuggestions(_currentValue, context),
          enabled: true,
          style: _theme.textTheme.bodyText1,
          decoration: InputDecoration(
            hintText: "City",
            prefixIcon: Icon(
              Icons.search,
              color: light,
            ),
            fillColor: medium,
            focusColor: medium,
            filled: true,
            border: null,
            errorBorder: null,
            enabledBorder: null,
            focusedBorder: null,
            disabledBorder: null,
            focusedErrorBorder: null,
          ),
        ),
        Expanded(
          child: BlocBuilder<SuggestionsBloc, SuggestionsState>(
            builder: (context, state) {
              log('Search state:' + state.toString());
              if (state is SuggestionsLoading) {
                return Container();
              } else if (state is SuggestionsLoaded) {
                final List<Suggestion> _suggestions = state.suggestions;
                if (_suggestions.isEmpty) {
                  return Container(
                    height: 40,
                    width: double.infinity,
                    color: medium,
                    alignment: Alignment.center,
                    child: Text(
                      "No suggestions to show.",
                      style: _theme.textTheme.bodyText1,
                    ),
                  );
                }
                return Container(
                  color: medium,
                  child: ListView.builder(
                    itemCount: _suggestions.length,
                    itemBuilder: (ctx, index) => SuggestionItem(
                      text: _suggestions[index].description,
                      style: _theme.textTheme.bodyText1,
                      city: _suggestions[index].city,
                      onTap: () {
                        BlocProvider.of<SuggestionsBloc>(context, listen: false)
                            .add(CloseSuggestions());

                        _searchController.text = _suggestions[index].city;

                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                );
              } else if (state is SuggestionsError) {
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }

  void _fetchSuggestions(String input, BuildContext context) {
    _fetchSuggestionsTimer?.cancel();

    if (input.isNotEmpty)
      _fetchSuggestionsTimer = Timer(
          Duration(milliseconds: 200),
          () => BlocProvider.of<SuggestionsBloc>(context, listen: false)
              .add(FetchSuggestions(input)));
  }
}

class SuggestionItem extends StatelessWidget {
  final String text;
  final String city;
  final TextStyle? style;
  final Function() onTap;
  const SuggestionItem({
    Key? key,
    required this.text,
    required this.style,
    required this.city,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<WeatherBloc>(context, listen: false)
            .add(FetchWeather(city: city));
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}
