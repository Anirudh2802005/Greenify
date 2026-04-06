import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_application_1/screens/loginpage.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _leafController;
  late AnimationController _glowController;
  late AnimationController _floatingController;
  double scrollOffset = 0;

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

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scrollController.addListener(() {
      setState(() {
        scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _leafController.dispose();
    _glowController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
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

          // Main content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildFirstSection(),
                _buildSecondSection(),
              ],
            ),
          ),

          // Scroll indicator at bottom of first section
          if (scrollOffset < 100)
  Positioned(
    bottom: 30,
    left: 0,
    right: 0,
    child: AnimatedBuilder(
      animation: _leafController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              0, math.sin(_leafController.value * 2 * math.pi) * 10),
          child: GestureDetector(
            onTap: () {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              );
            },
            child: Column(
              children: const [
                Text(
                  'Scroll down',
                  style: TextStyle(
                    color: Color(0xFF4ade80),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF4ade80),
                  size: 32,
                ),
              ],
            ),
          ),
        );
      },
    ),
  ),
        ],
      ),
    );
  }

  Widget _buildFirstSection() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Animated Leaf Logo
          AnimatedBuilder(
            animation: _leafController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    0, math.sin(_leafController.value * 2 * math.pi) * 15),
                child: Transform.rotate(
                  angle: math.sin(_leafController.value * 2 * math.pi) * 0.1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow effect
                      AnimatedBuilder(
                        animation: _glowController,
                        builder: (context, child) {
                          return Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF22c55e).withOpacity(
                                      0.3 + _glowController.value * 0.3),
                                  blurRadius: 60 + _glowController.value * 20,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Main circle
                      Container(
                        width: 160,
                        height: 160,
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
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.eco,
                          size: 90,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),

          // Title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF86efac),
                Color(0xFF34d399),
                Color(0xFF5eead4)
              ],
            ).createShader(bounds),
            child: const Text(
              'Avoid Plastic',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Description
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF14532d).withOpacity(0.4),
                  const Color(0xFF065f46).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFF15803d).withOpacity(0.5)),
            ),
            child: const Text(
              'Join the movement to reduce plastic waste and protect our beautiful planet for future generations',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFd1d5db),
                height: 1.5,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSecondSection() {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Animated paw icon
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    0, math.sin(_floatingController.value * math.pi * 2) * 10),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3b82f6), Color(0xFF06b6d4)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3b82f6).withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.pets,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),

          const Text(
            'Save Marine Life',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF14532d).withOpacity(0.4),
                  const Color(0xFF065f46).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFF15803d).withOpacity(0.5)),
            ),
            child: const Text(
              'Over 100,000 marine animals die annually from plastic pollution. Every piece of plastic matters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFd1d5db),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 60),

          // Wave icon
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF3b82f6), Color(0xFF1e40af)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3b82f6).withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.waves,
              size: 70,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),

          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF86efac), Color(0xFF34d399)],
            ).createShader(bounds),
            child: const Text(
              'Protect Our Oceans',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF14532d).withOpacity(0.4),
                  const Color(0xFF065f46).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: const Color(0xFF15803d).withOpacity(0.5)),
            ),
            child: const Text(
              '8 million tons of plastic waste enter our oceans every year, harming marine life and ecosystems.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFd1d5db),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 50),

          // Stats cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('91%', 'Plastic not\nrecycled',
                  [const Color(0xFFec4899), const Color(0xFFbe185d)]),
              _buildStatCard('5T', 'Plastic in\noceans by\n2050',
                  [const Color(0xFFf97316), const Color(0xFFea580c)]),
              _buildStatCard('YOU', 'Can make a\ndifference',
                  [const Color(0xFF22c55e), const Color(0xFF16a34a)]),
            ],
          ),
          const SizedBox(height: 60),

          // Join Mission button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22c55e).withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 600),
                    pageBuilder: (_, __, ___) => const LoginPage(),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      );
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22c55e),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Join Our Mission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Together, we can create a plastic-free future',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF9ca3af),
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.eco,
                color: Color(0xFF4ade80),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildStatCard(String stat, String label, List<Color> colors) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            stat,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingParticle extends StatefulWidget {
  final int index;

  const FloatingParticle({Key? key, required this.index}) : super(key: key);

  @override
  State<FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<FloatingParticle>
    with SingleTickerProviderStateMixin {
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
      end: Offset(_random.nextDouble() * 20 - 10,
          _random.nextDouble() * 40 - 20),
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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