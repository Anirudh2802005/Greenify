import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeTerms = false;

  late AnimationController _leafController;
  late AnimationController _glowController;
  late AnimationController _formController;

  @override
  void initState() {
    super.initState();
    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _leafController.dispose();
    _glowController.dispose();
    _formController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  Color(0xFF064e3b), // green-950
                  Color(0xFF065f46), // emerald-900
                  Color(0xFF134e4a), // teal-950
                ],
              ),
            ),
          ),

          // Floating particles
          ...List.generate(20, (index) => _FloatingParticle(index: index)),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _formController,
                curve: Curves.easeIn,
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _formController,
                  curve: Curves.easeOutCubic,
                )),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      _buildLogo(),
                      const SizedBox(height: 32),
                      _buildHeaderText(),
                      const SizedBox(height: 40),
                      _buildFormFields(),
                      const SizedBox(height: 24),
                      _buildTermsCheckbox(),
                      const SizedBox(height: 32),
                      _buildSignUpButton(),
                      const SizedBox(height: 24),
                      _buildLoginRedirect(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🌿 Animated Leaf Logo matching dashboard style
  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _leafController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_leafController.value * 2 * math.pi) * 10),
          child: Transform.rotate(
            angle: math.sin(_leafController.value * 2 * math.pi) * 0.05,
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
                // Main circle
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
                  child: const Icon(
                    Icons.eco,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🌈 Header title matching dashboard style
  Widget _buildHeaderText() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF86efac), Color(0xFF34d399), Color(0xFF5eead4)],
          ).createShader(bounds),
          child: const Text(
            "Join The Green Movement",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Create your account and be part of the solution 🌿",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFd1d5db),
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// 📝 Signup form fields with dashboard styling
  Widget _buildFormFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildInput(_nameController, Icons.person_outline, "Full Name"),
          const SizedBox(height: 16),
          _buildInput(_emailController, Icons.email_outlined, "Email"),
          const SizedBox(height: 16),
          _buildPasswordField(_passwordController, "Password", _isPasswordVisible, () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          }),
          const SizedBox(height: 16),
          _buildPasswordField(_confirmPasswordController, "Confirm Password", _isConfirmPasswordVisible, () {
            setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
          }),
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, IconData icon, String hint) {
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
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF4ade80)),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9ca3af)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
        validator: (value) => value!.isEmpty ? 'Please enter $hint' : null,
      ),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller, String hint, bool visible, VoidCallback toggle) {
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
      child: TextFormField(
        controller: controller,
        obscureText: !visible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4ade80)),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9ca3af)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          suffixIcon: IconButton(
            icon: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF9ca3af),
            ),
            onPressed: toggle,
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Please enter $hint' : null,
      ),
    );
  }

  /// ✅ Terms checkbox with dashboard styling
  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          activeColor: const Color(0xFF22c55e),
          checkColor: Colors.white,
          side: const BorderSide(color: Color(0xFF4ade80)),
          value: _agreeTerms,
          onChanged: (v) => setState(() => _agreeTerms = v ?? false),
        ),
        const Expanded(
          child: Text(
            "I agree to the Terms of Service and Privacy Policy",
            style: TextStyle(color: Color(0xFFd1d5db), fontSize: 14),
          ),
        ),
      ],
    );
  }

  /// 🌱 Sign up button matching dashboard style
  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState!.validate() && _agreeTerms) {
          if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Passwords do not match."),
                backgroundColor: const Color(0xFFef4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
            return;
          }

          try {
            // ✅ Create account in Firebase
            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

            print('Signup successful: ${credential.user?.email}');

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Account Created Successfully 🎉"),
                backgroundColor: const Color(0xFF22c55e),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );

            // ✅ Navigate to Login Page
            Navigator.pop(context);

          } on FirebaseAuthException catch (e) {
            String message;
            if (e.code == 'email-already-in-use') {
              message = "This email is already registered.";
            } else if (e.code == 'weak-password') {
              message = "Password is too weak.";
            } else {
              message = e.message ?? "Signup failed.";
            }

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: const Color(0xFFef4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        } else if (!_agreeTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Please accept terms and conditions."),
              backgroundColor: const Color(0xFFef4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF22c55e), Color(0xFF10b981)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF22c55e).withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  /// 🔁 Redirect to login with dashboard styling
  Widget _buildLoginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(color: Color(0xFFd1d5db), fontSize: 15),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text(
            "Sign In",
            style: TextStyle(
              color: Color(0xFF4ade80),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

// Floating Particle Widget matching dashboard
class _FloatingParticle extends StatefulWidget {
  final int index;

  const _FloatingParticle({required this.index});

  @override
  State<_FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<_FloatingParticle> with SingleTickerProviderStateMixin {
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