import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'main.dart';
import 'congrats.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _showBadges = false;
  bool _showConfetti = false;

  String? _selectedAvatar;
  final List<String> _avatars = [
    '😺', 
    '🐶', 
    '🦄', 
  ];

  String _passwordStrength = '';
  Color _strengthColor = Colors.red;
  List<Widget> _earnedBadges = [];

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 16).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Date Picker Function
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurple, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.deepPurple, size: 28),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showSignupBadges() {
    _earnedBadges.clear();
    // Strong password badge
    if (_passwordStrength == 'Strong') {
      _earnedBadges.add(_buildBadge(Icons.lock, 'Strong Password'));
    }
    // Signup before 12PM badge
    final now = DateTime.now();
    if (now.hour < 12) {
      _earnedBadges.add(_buildBadge(Icons.flight, 'Early Bird'));
    }
    // All fields completed badge
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _dobController.text.isNotEmpty &&
        _selectedAvatar != null) {
      _earnedBadges.add(_buildBadge(Icons.check_circle, 'All Fields Complete'));
    }
    setState(() {
      _showBadges = true;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        _showBadges = false;
        _showConfetti = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (!kIsWeb) {
          HapticFeedback.lightImpact();
        }
        setState(() {
          _showConfetti = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              userName: _nameController.text,
              avatar: _selectedAvatar!,
            ),
          ),
        );
      });
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedAvatar == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an avatar!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        _showSignupBadges();
      });
    }
  }

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      _passwordStrength = '';
      _strengthColor = Colors.red;
    } else if (password.length < 6 || !RegExp(r'^(?=.*[a-zA-Z])').hasMatch(password)) {
      _passwordStrength = 'Weak';
      _strengthColor = Colors.red;
    } else if (password.length < 10 || !RegExp(r'^(?=.*[0-9])').hasMatch(password)) {
      _passwordStrength = 'Could be improved';
      _strengthColor = Colors.yellow;
    } else if (RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~])').hasMatch(password)) {
      _passwordStrength = 'Strong';
      _strengthColor = Colors.green;
    } else {
      _passwordStrength = 'Could be improved';
      _strengthColor = Colors.yellow;
    }
  }

  void _triggerShake() {
    _shakeController.forward(from: 0);
    if (!kIsWeb) {
      HapticFeedback.vibrate();
    }
  }

  void _validateAndSubmit() {
    if (_nameController.text.isEmpty || _passwordController.text.isEmpty) {
      _triggerShake();
      return;
    }
    if (_formKey.currentState!.validate()) {
      if (_selectedAvatar == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an avatar!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        _showSignupBadges();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Account'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Column(
        children: [
          const ProgressBar(progress: 0.5),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
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
                      // Avatar Selector
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _avatars.map((avatar) {
                            final isSelected = _selectedAvatar == avatar;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedAvatar = avatar;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.deepPurple[100] : Colors.grey[200],
                                  border: Border.all(
                                    color: isSelected ? Colors.deepPurple : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  avatar,
                                  style: const TextStyle(fontSize: 36),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Padding(
                      //   padding: const EdgeInsets.all(24.0),
                      //   child:
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Animated Form Header
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.tips_and_updates,
                                      color: Colors.deepPurple[800]),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Complete your adventure profile!',
                                      style: TextStyle(
                                        color: Colors.deepPurple[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Name Field
                            _buildTextField(
                              controller: _nameController,
                              label: 'Adventure Name',
                              icon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'What should we call you on this adventure?';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Email Field
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email Address',
                              icon: Icons.email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'We need your email for adventure updates!';
                                }
                                if (!value.contains('@') || !value.contains('.')) {
                                  return 'Oops! That doesn\'t look like a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // DOB w/Calendar
                            TextFormField(
                              controller: _dobController,
                              readOnly: true,
                              onTap: _selectDate,
                              decoration: InputDecoration(
                                labelText: 'Date of Birth',
                                prefixIcon:
                                    const Icon(Icons.calendar_today, color: Colors.deepPurple),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.date_range),
                                  onPressed: _selectDate,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'When did your adventure begin?';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Pswd Field w/ Toggle
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              onChanged: (value) {
                                setState(() {
                                  _checkPasswordStrength(value);
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Secret Password',
                                prefixIcon:
                                    const Icon(Icons.lock, color: Colors.deepPurple),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.deepPurple,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Every adventurer needs a secret password!';
                                }
                                if (value.length < 6) {
                                  return 'Make it stronger! At least 6 characters';
                                }
                                return null;
                              },
                            ),
                            // Password Strength Meter
                            if (_passwordStrength.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: _strengthColor,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _passwordStrength,
                                      style: TextStyle(
                                        color: _strengthColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 30),

                            // Submit Button w/ Loading Animation
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: _isLoading ? 60 : double.infinity,
                              height: 60,
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.deepPurple),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: _validateAndSubmit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        elevation: 5,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Start My Adventure',
                                            style: TextStyle(
                                                fontSize: 18, color: Colors.white),
                                          ),
                                          SizedBox(width: 10),
                                          Icon(Icons.rocket_launch, color: Colors.white),
                                        ],
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 20),

                            // Badges Section
                            if (_showBadges)
                              Column(
                                children: [
                                  const Text('Badges Earned:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    children: _earnedBadges,
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
