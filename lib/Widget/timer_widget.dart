import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:recipie_app/Utils/notification_helper.dart';

class TimerWidget extends StatefulWidget {
  final int minutes; // The total time in minutes

  const TimerWidget({super.key, required this.minutes});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int remainingTime; // Remaining time in seconds
  late int totalTimeInSeconds; // Total time in seconds (for progress calculation)
  late Timer _timer;
  late AudioPlayer _audioPlayer;
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    // Ensure totalTimeInSeconds is at least 1 to avoid Division by Zero (NaN)
    totalTimeInSeconds = (widget.minutes > 0 ? widget.minutes : 1) * 60;
    remainingTime = widget.minutes * 60;
    _audioPlayer = AudioPlayer();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        if (mounted) {
          setState(() {
            remainingTime--;
          });
        }
      } else {
        _timer.cancel();
        _playBeep();
        _showNotification();
      }
    });
  }

  void _playBeep() async {
    try {
      // audioplayers 6.x expects the path relative to the assets folder.
      // If your file is at 'assets/beep.mp3', just pass 'beep.mp3'.
      await _audioPlayer.play(AssetSource('beep.mp3'));
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  void _showNotification() async {
    await _notificationHelper.showImmediateNotification(
      title: 'Time is up!',
      body: 'Your timer has finished.',
    );
  }

  @override
  Widget build(BuildContext context) {
    int minutesLeft = remainingTime ~/ 60;
    int secondsLeft = remainingTime % 60;

    // Safely calculate progress to avoid NaN/Infinity
    double progress = totalTimeInSeconds > 0 ? remainingTime / totalTimeInSeconds : 0.0;
    // Clamp between 0 and 1 just in case
    progress = progress.clamp(0.0, 1.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$minutesLeft:${secondsLeft.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: 1, 
                strokeWidth: 10,
                color: Colors.grey[300],
              ),
            ),
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: progress, 
                strokeWidth: 10,
                color: Colors.green,
              ),
            ),
            const Positioned(
              top: 10,
              child: Text(
                "Time left",
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
