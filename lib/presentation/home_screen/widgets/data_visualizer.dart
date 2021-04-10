import 'package:flutter/material.dart';

import '../../../constants.dart';

class DataVisualizer extends StatefulWidget {
  const DataVisualizer({
    Key? key,
    required this.data,
    required this.maxTemperature,
    required this.minTemperature,
    required this.theme,
    required this.title,
    required this.animationController,
    required this.beginAnimating,
    required this.endAnimating,
  }) : super(key: key);

  final double data;
  final double maxTemperature;
  final double minTemperature;
  final ThemeData theme;
  final String title;
  final AnimationController animationController;
  final double beginAnimating;
  final double endAnimating;

  @override
  _DataVisualizerState createState() => _DataVisualizerState();
}

class _DataVisualizerState extends State<DataVisualizer> {
  @override
  late final double _widthFactor;

  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _widthFactor = (widget.data - widget.minTemperature + 2) /
        ((widget.maxTemperature - widget.minTemperature + 2));
    animation =
        Tween<double>(begin: 0, end: _widthFactor).animate(CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(
              widget.beginAnimating,
              widget.endAnimating,
              curve: Curves.easeOut,
            )));
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${widget.title}: ',
                style: widget.theme.textTheme.headline1,
              ),
              Spacer(),
              Text(
                '${widget.data} F°',
                style: widget.theme.textTheme.headline1,
              ),
            ],
          ),
          SizedBox(
            height: 40,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                ),
                AnimatedBuilder(
                  animation: animation,
                  builder: (ctx, child) => FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: animation.value,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                            colors: [
                              purpleBar,
                              Colors.red,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
