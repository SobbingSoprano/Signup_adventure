import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Tha Big Confetti Celebration
class SuccessScreen extends StatelessWidget {
  final String userName;
  final String avatar;

  const SuccessScreen({Key? key, required this.userName, required this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!kIsWeb) {
        HapticFeedback.lightImpact();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Congratulations!'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Column(
        children: [
          const ProgressBar(progress: 1.0),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: ConfettiWidget(
                            confettiController: ConfettiController(
                                    duration: const Duration(seconds: 2))
                                  ..play(),
                            blastDirectionality: BlastDirectionality.explosive,
                            shouldLoop: false,
                            colors: const [
                              Colors.deepPurple,
                              Colors.purple,
                              Colors.blue,
                              Colors.green,
                              Colors.orange,
                            ],
                          ),
                        ),
                        const Center(
                          child: Text('🎉', style: TextStyle(fontSize: 64)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome, $userName!',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your adventure begins now.',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 32),
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.deepPurple[100],
                      child: Text(
                        avatar,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.purple,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
