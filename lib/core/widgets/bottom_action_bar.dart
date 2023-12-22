import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    required this.muted,
    required this.speakerOff,
    required this.onLeave,
    required this.onToggleMute,
    required this.onToggleSpeaker,
  });

  final bool muted;
  final bool speakerOff;
  final Function onToggleMute;
  final Function onToggleSpeaker;
  final Function onLeave;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Micro button
        IconButton(
          icon: Icon(muted ? Icons.mic_off : Icons.mic),
          onPressed: () {
            onToggleMute();
          },
          iconSize: 36,
        ),
        // Speaker button
        IconButton(
          icon: Icon(speakerOff ? Icons.volume_off : Icons.volume_up),
          onPressed: () {
            onToggleSpeaker();
          },
          iconSize: 36,
        ),
        // Leave button
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () {
            onLeave();
          },
          iconSize: 36,
        ),
      ],
    );
  }
}
