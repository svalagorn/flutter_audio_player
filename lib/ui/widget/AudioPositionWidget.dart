import 'package:flutter/material.dart';
import 'dart:async';

class AudioPositionWidget extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;

  const AudioPositionWidget({
    @required this.currentPosition,
    @required this.duration,
    @required this.seekTo,
  });

  @override
  _AudioPositionWidgetState createState() => _AudioPositionWidgetState();
}

class _AudioPositionWidgetState extends State<AudioPositionWidget> {
  //late Duration _visibleValue;
  bool listenOnlyUserInterraction = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        //Should probably use BlocBuilder here? nah, all that stuff is handled by the parent
        );
  }
}
