import 'package:flutter/material.dart';
import 'dart:async';

class AudioPositionWidget extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;

  const AudioPositionWidget({
    required this.currentPosition,
    required this.duration,
    required this.seekTo,
  });

  @override
  _AudioPositionWidgetState createState() => _AudioPositionWidgetState();
}

class _AudioPositionWidgetState extends State<AudioPositionWidget> {
  late Duration _visibleValue;
  bool listenOnlyUserInterraction = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
  }

  @override
  void didUpdateWidget(AudioPositionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInterraction) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      //20210505: Should probably use BlocBuilder here? nah, all that stuff is handled by the parent
      child: SliderTheme(
        data: SliderThemeData(
          thumbShape: SliderComponentShape.noThumb,
          trackShape: CustomTrackShape(),
          trackHeight: 3,
          //Alphas taken from SliderThemeData.fromPrimaryColors:
          disabledActiveTrackColor: Theme.of(context).colorScheme.primary.withAlpha(0xff),
          disabledInactiveTrackColor: Theme.of(context).colorScheme.primary.withAlpha(0x3d),
        ),
        child: Slider(
          min: 0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: percent * widget.duration.inMilliseconds.toDouble(),
          //TODO: use handlers below for the playback screen
          // onChangeStart: (_) {
          //   setState(() {
          //     listenOnlyUserInterraction = true;
          //   });
          // },
          // onChangeEnd: (newValue) {
          //   setState(() {
          //     listenOnlyUserInterraction = false;
          //     widget.seekTo(_visibleValue);
          //   });
          // },
          // onChanged: (newValue) {
          //   setState(() {
          //     final to = Duration(milliseconds: newValue.floor());
          //     _visibleValue = to;
          //   });
          // },
          onChanged: null,
        ),
      ),
    );
  }
}

class CustomTrackShape extends RectangularSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight as double;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
