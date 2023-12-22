import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_sample/core/widgets/bottom_action_bar.dart';
import 'package:agora_sample/sound_wave.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CallScreen(),
    );
  }
}

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late RtcEngine _agoraEngine;

  bool _muted = false;
  bool _speakerOff = false;
  bool _hasVoiceCome = false;
  int? _remoteUid;
  bool _isJoined = false;

  final appId = 'f3de06bbd5204c9ea642ae7e8516394e';
  final uid = 0;
  final channelId = "test";
  final token =
      '007eJxTYGAMMORRuCp/w9rvYZfQj6ruA1NMH4U/eWixunjtYcd7tysUGNKMU1INzJKSUkyNDEySLVMTzUyMElPNUy1MDc2MLU1Sk0NbUxsCGRmOTZvGzMgAgSA+C0NJanEJAwMAankgdA==';

  @override
  void initState() {
    super.initState();
    setupVoiceSDKEngine()
        .whenComplete(() => joinChannel())
        .onError((error, stackTrace) => {
              debugPrint(error.toString()),
              debugPrint(stackTrace.toString()),
            });
  }

  @override
  void dispose() {
    super.dispose();
    _agoraEngine.leaveChannel();
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _agoraEngine.muteLocalAudioStream(_muted);
  }

  void _onToggerSpeaker() {
    setState(() {
      _speakerOff = !_speakerOff;
    });
    _agoraEngine.setEnableSpeakerphone(!_speakerOff);
  }

  void _onLeave() {
    _agoraEngine.leaveChannel();
  }

  Future<void> setupVoiceSDKEngine() async {
    try {
      // Retrieve or request microphone permission
      await [Permission.microphone].request();

      // Create an instance of the Agora engine
      _agoraEngine = createAgoraRtcEngine();
      await _agoraEngine.initialize(RtcEngineContext(appId: appId));

      // Enables the audioVolumeIndication
      await _agoraEngine.enableAudioVolumeIndication(
          interval: 250, smooth: 8, reportVad: true);

      // Register the event handler
      _agoraEngine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            setState(() {
              _isJoined = true;
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            setState(() {
              _remoteUid = remoteUid;
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            setState(() {
              _remoteUid = null;
            });
          },
          onAudioVolumeIndication: (
            RtcConnection connection,
            List<AudioVolumeInfo> speakers,
            int speakerNumber,
            int totalVolume,
          ) {
            setState(() {
              // explain the below code meaning

              _hasVoiceCome = speakers.any((speaker) => speaker.vad == 1);
            });
          },
          onError: (err, msg) => {
            debugPrint(err.toString()),
            debugPrint(msg.toString()),
          },
        ),
      );
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  void joinChannel() async {
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    try {
      await _agoraEngine.joinChannel(
        token: token,
        channelId: channelId,
        options: options,
        uid: uid,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get started with Voice Calling'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 40, child: Center(child: _status())),
            Column(
              children: [
                SizedBox(
                  height: 60.0,
                  child: SoundWave(hasVoiceCome: _hasVoiceCome),
                ),
                const SizedBox(height: 40.0),
                BottomActionBar(
                  muted: _muted,
                  speakerOff: _speakerOff,
                  onToggleMute: _onToggleMute,
                  onToggleSpeaker: _onToggerSpeaker,
                  onLeave: _onLeave,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _status() {
    String statusText;

    if (!_isJoined) {
      statusText = 'Join a channel';
    } else if (_remoteUid == null) {
      statusText = 'Waiting for a remote user to join...';
    } else {
      statusText = 'Connected to remote user, uid:$_remoteUid';
    }

    return Text(
      statusText,
    );
  }
}
