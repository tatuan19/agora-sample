import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SoundWave extends StatelessWidget {
  const SoundWave({super.key, required this.hasVoiceCome});

  final bool hasVoiceCome;

  @override
  Widget build(BuildContext context) {
    List<Color> soundWaveColors = const [
      Color(0xFFFF5500),
      Color(0xFFFF6600),
      Color(0xFFFF7700),
      Color(0xFFFF8800),
      Color(0xFFFF9900),
      Color(0xFFFAA400),
      Color(0xFFFBAD00),
      Color(0xFFFCB400),
      Color(0xFFFDBA00),
      Color(0xFFFECC00),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        2,
        (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: LoadingIndicator(
              indicatorType: Indicator.lineScalePulseOutRapid,
              colors: soundWaveColors.sublist(index * 5, (index + 1) * 5),
              pause: !hasVoiceCome,
            ),
          );
        },
      ),
    );
  }
}
