import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../pigeons/daily_pigeon_g.dart';
import '../daily/daily_callback.dart';
import 'music_player_logic.dart';

class MusicPlayerPage extends StatefulWidget {
  MusicPlayerPage({Key? key}) : super(key: key);

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final logic = Get.put(MusicPlayerLogic());

  final state = Get.find<MusicPlayerLogic>().state;
  // late final DailyCallbackImpl callback;

  late final AudioPlayer player;
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  @override
  void initState() {
    super.initState();
    AudioLogger.logLevel = AudioLogLevel.info;
    player = AudioPlayer();
    // Use initial values from player
    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
        _duration = value;
      }),
    );
    player.getCurrentPosition().then(
          (value) => setState(() {
        _position = value;
      }),
    );
    _initStreams();
    if(Get.arguments != null){
      final i = Get.arguments;
      // _playMusic('chilichill.ogg');
    }


    // callback = DailyCallbackImpl.music((){
    //   print("callback music !!!!!!!!!!!!!!!!!!!");
    // });
    // DailyCallback.setup(callback);
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.pink.shade100;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: const Key('play_button'),
                    onPressed: _isPlaying ? null : _play,
                    iconSize: 48.0,
                    icon: const Icon(Icons.play_arrow),
                    color: color,
                  ),
                  IconButton(
                    key: const Key('pause_button'),
                    onPressed: _isPlaying ? _pause : null,
                    iconSize: 48.0,
                    icon: const Icon(Icons.pause),
                    color: color,
                  ),
                  IconButton(
                    key: const Key('stop_button'),
                    onPressed: _isPlaying || _isPaused ? _stop : null,
                    iconSize: 48.0,
                    icon: const Icon(Icons.stop),
                    color: color,
                  ),
                ],
              ),
              Slider(
                onChanged: (v) {
                  final duration = _duration;
                  if (duration == null) {
                    return;
                  }
                  final position = v * duration.inMilliseconds;
                  player.seek(Duration(milliseconds: position.round()));
                },
                value: (_position != null &&
                    _duration != null &&
                    _position!.inMilliseconds > 0 &&
                    _position!.inMilliseconds < _duration!.inMilliseconds)
                    ? _position!.inMilliseconds / _duration!.inMilliseconds
                    : 0.0,
              ),
              Text(
                _position != null
                    ? '$_positionText / $_durationText'
                    : _duration != null
                    ? _durationText
                    : '',
                style: const TextStyle(fontSize: 16.0),
              ),
              Text('State: ${_playerState ?? '-'}'),
              ElevatedButton(onPressed: () => _playMusic('chilichill.ogg'), child: const Text('play music')),
              // ElevatedButton(onPressed: () => _playMusic('hanser.flac'), child: Text('play hanser')),
              // ElevatedButton(onPressed: () => _playMusic('naruto.wav'), child: Text('play naruto')),
              // ElevatedButton(onPressed: () => _playMusic('sp.mp3'), child: Text('play sp')),
              ElevatedButton(onPressed: _playRecord, child: const Text('play record')),
            ],
          ),
        ),
      ),
    );
  }
  
  void _playMusic(String name)async{
    await player.play(AssetSource('music/$name'));
  }

  void _playRecord()async{
    if (Get.arguments != null && Get.arguments != ""){
      String path = Get.arguments;
      Logger().i("record file path: $path");
      await player.play(DeviceFileSource(path));
    }else{
      SmartDialog.showToast("no selected record file");
    }

  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
          (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
          setState(() {
            _playerState = state;
          });
        });
  }

  Future<void> _play() async {
    if (Get.arguments != null && Get.arguments != ""){
      String path = Get.arguments;
      Logger().i("record file path: $path");
      await player.play(DeviceFileSource(path));
    }else{
      SmartDialog.showToast("no selected record file");
    }
    final position = _position;
    if (position != null && position.inMilliseconds > 0) {
      await player.seek(position);
    }
    await player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }
}
