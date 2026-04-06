import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_application_1/screens/dashboard.dart';
import 'package:flutter_application_1/screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _showPassword = false;
  bool _loading = true;
  bool _saving = false;

  late AnimationController _leafController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    
    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? profileData = prefs.getString('user_profile');
      
      if (profileData != null) {
        final Map<String, dynamic> data = json.decode(profileData);
        setState(() {
          _fullNameController.text = data['fullName'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _addressController.text = data['address'] ?? '';
          _cityController.text = data['city'] ?? '';
          _stateController.text = data['state'] ?? '';
          _pinCodeController.text = data['pinCode'] ?? '';
          _passwordController.text = data['newPassword'] ?? '';
          _emailController.text = data['email'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _saving = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, String> profileData = {
        'fullName': _fullNameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'pinCode': _pinCodeController.text,
        'newPassword': _passwordController.text,
        'email': _emailController.text,
      };

      await prefs.setString('user_profile', json.encode(profileData));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile saved successfully!'),
            backgroundColor: const Color(0xFF22c55e),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to save profile. Please try again.'),
            backgroundColor: const Color(0xFFef4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _leafController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF064e3b),
                Color(0xFF065f46),
                Color(0xFF134e4a),
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF4ade80),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient matching dashboard
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF064e3b),
                  Color(0xFF065f46),
                  Color(0xFF134e4a),
                ],
              ),
            ),
          ),

          // Floating particles
          ...List.generate(25, (index) => FloatingParticle(index: index)),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Header with back button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGlassButton(
                        icon: Icons.arrow_back,
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const Dashboard(),
                              transitionsBuilder:
                                  (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                      ),
                      const Column(
                        children: [
                          Text(
                            'Profile Settings',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage your account',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF86efac),
                            ),
                          ),
                        ],
                      ),
                   



_buildGlassButton(
  icon: Icons.logout,
  onTap: () async {
    // ✅ Step 1: Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // ✅ Step 2: Then navigate smoothly to LoginPage
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginPage(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  },
),

                    ],
                  ),

                  const SizedBox(height: 32),

                  // Profile Avatar with Animation
                  _buildAnimatedAvatar(),

                  const SizedBox(height: 32),

                  // Form Container
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF14532d).withOpacity(0.4),
                          const Color(0xFF065f46).withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF15803d).withOpacity(0.5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Personal Information Section
                          _buildSectionHeader(
                            icon: Icons.person,
                            title: 'Personal Information',
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            controller: _fullNameController,
                            icon: Icons.person_outline,
                            hint: 'Full Name',
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            controller: _phoneController,
                            icon: Icons.phone_outlined,
                            hint: 'Phone Number',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            controller: _emailController,
                            icon: Icons.email_outlined,
                            hint: 'Email Address',
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 32),

                          // Address Section
                          _buildSectionHeader(
                            icon: Icons.location_on,
                            title: 'Address Details',
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            controller: _addressController,
                            icon: Icons.home_outlined,
                            hint: 'Street Address',
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  controller: _cityController,
                                  icon: Icons.location_city_outlined,
                                  hint: 'City',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInputField(
                                  controller: _stateController,
                                  icon: Icons.map_outlined,
                                  hint: 'State',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            controller: _pinCodeController,
                            icon: Icons.location_on_outlined,
                            hint: 'PIN Code',
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 32),

                          // Security Section
                          _buildSectionHeader(
                            icon: Icons.lock,
                            title: 'Security Settings',
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            controller: _passwordController,
                            icon: Icons.lock_outline,
                            hint: 'New Password',
                            obscureText: !_showPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: const Color(0xFF4ade80),
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Save Button
                          _buildSaveButton(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedAvatar() {
    return AnimatedBuilder(
      animation: _leafController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_leafController.value * 2 * math.pi) * 8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect
              AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF22c55e).withOpacity(0.3 + _glowController.value * 0.3),
                          blurRadius: 40 + _glowController.value * 20,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Avatar
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4ade80),
                      Color(0xFF10b981),
                      Color(0xFF14b8a6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF22c55e),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF22c55e), Color(0xFF10b981)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF22c55e),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF14532d).withOpacity(0.4),
            const Color(0xFF065f46).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF15803d).withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: const Color(0xFF4ade80), size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF14532d).withOpacity(0.3),
            const Color(0xFF065f46).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF15803d).withOpacity(0.4)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF4ade80)),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9ca3af)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _saving ? null : _saveProfile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _saving 
              ? [const Color(0xFF6b7280), const Color(0xFF4b5563)]
              : [const Color(0xFF22c55e), const Color(0xFF10b981)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF22c55e).withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_saving)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              const Icon(Icons.save_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              _saving ? 'Saving...' : 'Save Profile',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Floating Particle Widget matching dashboard
class FloatingParticle extends StatefulWidget {
  final int index;

  const FloatingParticle({super.key, required this.index});

  @override
  State<FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<FloatingParticle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final math.Random _random = math.Random();
  late double size;
  late double left;
  late double top;

  @override
  void initState() {
    super.initState();
    size = _random.nextDouble() * 4 + 2;
    left = _random.nextDouble();
    top = _random.nextDouble();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _random.nextInt(10) + 10),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(_random.nextDouble() * 20 - 10, _random.nextDouble() * 40 - 20),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * left,
      top: MediaQuery.of(context).size.height * top,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: _animation.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4ade80).withOpacity(0.2),
              ),
            ),
          );
        },
      ),
    );
  }
}