import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'signup.dart';
import 'main.dart';
import 'dart:io' as io;
import 'dart:developer' as debug;
import 'package:flutter/services.dart' as services;
import 'package:flutter/foundation.dart';

// Welcome Screen w/ Animated Text
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showConfetti = false;

  void _goToSignup() {
    setState(() {
      _showConfetti = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!kIsWeb) {
        services.HapticFeedback.lightImpact();
      }
      setState(() {
        _showConfetti = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Column(
        children: [
          const ProgressBar(progress: 0.25),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_showConfetti)
                    SizedBox(
                      height: 120,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: ConfettiWidget(
                              confettiController: ConfettiController(duration: const Duration(seconds: 2))..play(),
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
                  // Animated Emoji
                  AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    curve: Curves.bounceOut,
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Animated Title
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Join The Adventure!',
                        textStyle: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Create your account and start your journey',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 50),

                  // Start Button
                  ElevatedButton(
                    onPressed: _goToSignup,
                    child: const Text('Start Signup'),
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

  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.deepPurple[100],
      color: Colors.deepPurple,
      minHeight: 8,
    );
  }
}