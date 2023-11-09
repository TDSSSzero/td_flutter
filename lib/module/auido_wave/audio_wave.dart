import 'package:flutter/material.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:td_flutter/module/auido_wave/wave_widget.dart';

class AudioWavePage extends StatefulWidget {
  AudioWavePage({super.key});

  @override
  State<AudioWavePage> createState() => _AudioWavePageState();
}

class _AudioWavePageState extends State<AudioWavePage> {

  final progressStream = BehaviorSubject<WaveformProgress>();
  final String rawPath = "assets/music/chilichill.ogg";

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 150.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            padding: const EdgeInsets.all(16.0),
            width: double.maxFinite,
            child: StreamBuilder<WaveformProgress>(
              stream: progressStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                final progress = snapshot.data?.progress ?? 0.0;
                final waveform = snapshot.data?.waveform;
                if (waveform == null) {
                  return Center(
                    child: Text(
                      '${(100 * progress).toInt()}%',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                }
                return AudioWaveformWidget(
                  waveform: waveform,
                  start: Duration.zero,
                  duration: waveform.duration,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _init() async {
    final audioFile =
    File(p.join((await getTemporaryDirectory()).path, 'waveform.mp3'));
    try {
      await audioFile.writeAsBytes(
          (await rootBundle.load('assets/music/chilichill.ogg')).buffer.asUint8List());
      final waveFile =
      File(p.join((await getTemporaryDirectory()).path, 'waveform.wave'));
      JustWaveform.extract(audioInFile: audioFile, waveOutFile: waveFile)
          .listen(progressStream.add, onError: progressStream.addError);
    } catch (e) {
      progressStream.addError(e);
    }
  }
}
