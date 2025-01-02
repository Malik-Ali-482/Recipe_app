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
    totalTimeInSeconds = widget.minutes * 60;
    remainingTime = totalTimeInSeconds;
    _audioPlayer = AudioPlayer();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _timer.cancel();
        _playBeep();
        _showNotification();
      }
    });
  }

  void _playBeep() async {
    // Play a beep sound when the timer hits zero
    await _audioPlayer.play(AssetSource('assets/beep.mp3')); // Ensure you have a beep.mp3 in your assets
  }

  void _showNotification() async {
    // Send a notification when the timer ends
    await _notificationHelper.showImmediateNotification(
      title: 'Time is up!',
      body: 'Your timer has finished.',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate minutes and seconds from the remaining time
    int minutesLeft = remainingTime ~/ 60;
    int secondsLeft = remainingTime % 60;

    // Calculate the progress for the circular indicator
    double progress = remainingTime / totalTimeInSeconds;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Display remaining time in "MM:SS" format
        Text(
          '$minutesLeft:${secondsLeft.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // Analog clock-like circular representation
        Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: 1, // Full circle
                strokeWidth: 10,
                color: Colors.grey[300],
              ),
            ),
            // Foreground circle with remaining time shaded in green
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: progress, // Green shaded area showing remaining time
                strokeWidth: 10,
                color: Colors.green,
              ),
            ),
            // Clock hands as a visual indicator of passage of time
            Positioned(
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
    _audioPlayer.dispose(); // Dispose the audio player to prevent memory leaks
    super.dispose();
  }
}
