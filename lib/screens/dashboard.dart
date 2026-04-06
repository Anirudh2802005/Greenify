import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_application_1/screens/calculator.dart';
import 'package:flutter_application_1/screens/schemes.dart';
import 'package:flutter_application_1/screens/resources.dart';
import 'package:flutter_application_1/screens/profile.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _PlasticAwarenessDashboardState();
}

class _PlasticAwarenessDashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _leafController;
  late AnimationController _glowController;
  String activeNav = 'home';
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
    super.dispose();
  }

  void scrollToSection(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
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
                Color(0xFF064e3b), // green-950
                Color(0xFF065f46), // emerald-900
                Color(0xFF134e4a), // teal-950
              ],
            ),
          ),
        ),

        // Floating particles
        ...List.generate(25, (index) => FloatingParticle(index: index)),

        // Main content
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: 120), // Added extra space (was 80)
              _buildHeroSection(),
              _buildJourneySection(),
              _buildBenefitsSection(),
              _buildCTASection(),
              _buildFooter(),
            ],
          ),
        ),

        // ✅ Fixed Navigation bar (stays visible while scrolling)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildNavigationBar(),
        ),
      ],
    ),
  );
}


Widget _buildNavigationBar() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF14532d).withOpacity(0.8),
          const Color(0xFF065f46).withOpacity(0.8),
          const Color(0xFF115e59).withOpacity(0.8),
        ],
      ),
      border: const Border(
        bottom: BorderSide(color: Color(0xFF15803d), width: 0.5),
      ),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🌿 Left Title
            const Row(
              children: [
                Icon(Icons.eco, color: Color(0xFF4ade80), size: 32),
                SizedBox(width: 8),
                Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // 🌍 Right Navigation Buttons
            Row(
              children: [
                _navButton('Home', 'home', 0),
                const SizedBox(width: 20),

                // ✅ Smooth Fade + Zoom Animation for Calculator
                GestureDetector(
                  onTap: () {
                    setState(() => activeNav = 'calculator');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 700),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const PlasticCalculatorApp(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          // Create fade and scale transition together
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: Tween<double>(
                                begin: 0.95,
                                end: 1.0,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              )),
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Calculator',
                    style: TextStyle(
                      color: activeNav == 'calculator'
                          ? const Color(0xFF4ade80)
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(width: 20),
             GestureDetector(
  onTap: () {
    setState(() => activeNav = 'schemes');
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const GovernmentSchemesPage(), // your schemes.dart main widget
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  },
  child: Text(
    'Schemes',
    style: TextStyle(
      color: activeNav == 'schemes'
          ? const Color(0xFF4ade80)
          : Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
  ),
),
const SizedBox(width: 20),

// Profile Icon
// 👤 Profile Icon with fade + scale animation navigation
GestureDetector(
  onTap: () {
    setState(() => activeNav = 'profile');
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const  ProfilePage(), // ✅ your profile.dart main widget
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  },
  child: Container(
    width: 40,
    height: 40,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: [Color(0xFF4ade80), Color(0xFF10b981)],
      ),
    ),
    child: const Center(
      child: Text(
        'P',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ),
  ),
),


              
            ],
          ),
        ],
      ),
    ),
  ),
);
}




  Widget _navButton(String text, String nav, double scrollTo) {
    final isActive = activeNav == nav;
    return GestureDetector(
      onTap: () {
        setState(() => activeNav = nav);
        scrollToSection(scrollTo);
      },
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? const Color(0xFF4ade80) : Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
  return Container(
    height: MediaQuery.of(context).size.height - 80,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 🌿 Animated Leaf Logo
        AnimatedBuilder(
          animation: _leafController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, math.sin(_leafController.value * 2 * math.pi) * 15),
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
                          width: 192,
                          height: 192,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF22c55e)
                                    .withOpacity(0.3 + _glowController.value * 0.3),
                                blurRadius: 60 + _glowController.value * 20,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Main circle with eco icon
                    Container(
                      width: 192,
                      height: 192,
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
                        size: 112,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 48),

        // 🌍 Title
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF86efac), Color(0xFF34d399), Color(0xFF5eead4)],
          ).createShader(bounds),
          child: const Text(
            'Join The Plastic-Free\nRevolution',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // 🌱 Description
        const Text(
          'Every small action counts. Together we can create a cleaner,\nhealthier planet free from plastic pollution.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFd1d5db),
            height: 1.5,
          ),
        ),

        const SizedBox(height: 40),

        // 🌊 Buttons Section
        // 🌊 Buttons Section (Centered)
Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // 🧮 Calculate Plastic Usage Button
      OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const PlasticCalculatorApp(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        icon: const Icon(Icons.calculate),
        label: const Text('Calculate Plastic Usage'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF22c55e), width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadowColor: const Color(0xFF22c55e).withOpacity(0.5),
          elevation: 8,
        ),
      ),

      const SizedBox(height: 20),

      // 📘 Learn More Button
      OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const ResourcesApp(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        icon: const Icon(Icons.menu_book),
        label: const Text('Learn More'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF22c55e), width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    ],
  ),
),


        const SizedBox(height: 64),

        // ⬇️ Scroll indicator animation
        AnimatedBuilder(
          animation: _leafController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, math.sin(_leafController.value * 2 * math.pi) * 10),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF4ade80),
                size: 40,
              ),
            );
          },
        ),
      ],
    ),
  );
}


  Widget _buildJourneySection() {
    final steps = [
      {'icon': Icons.people, 'title': 'Community Awareness', 'desc': 'Join local groups and spread awareness about plastic pollution'},
      {'icon': Icons.delete_outline, 'title': 'Reduce Single-Use', 'desc': 'Switch to reusable bags, bottles, and containers'},
      {'icon': Icons.recycling, 'title': 'Smart Recycling', 'desc': 'Learn proper segregation and recycling techniques'},
      {'icon': Icons.park, 'title': 'Eco Alternatives', 'desc': 'Adopt biodegradable and sustainable alternatives'},
      {'icon': Icons.workspace_premium, 'title': 'Be A Champion', 'desc': 'Lead by example and inspire others to join the movement'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF86efac), Color(0xFF34d399)],
            ).createShader(bounds),
            child: const Text(
              'Our Plastic Awareness Journey',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Take these simple steps to make a lasting impact on our environment',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFd1d5db),
            ),
          ),
          const SizedBox(height: 64),
          ...List.generate(steps.length, (index) {
            return _buildJourneyStep(
              index + 1,
              steps[index]['icon'] as IconData,
              steps[index]['title'] as String,
              steps[index]['desc'] as String,
              index,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildJourneyStep(int step, IconData icon, String title, String desc, int index) {
    final isVisible = scrollOffset > 500 + index * 120;
    final offset = isVisible ? 0.0 : (index % 2 == 0 ? -50.0 : 50.0);

    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 600),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        transform: Matrix4.translationValues(offset, 0, 0),
        margin: const EdgeInsets.only(bottom: 24),
        child: Container(
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
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF22c55e), Color(0xFF10b981)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF22c55e),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: BoxDecoration(
    color: const Color(0xFF22c55e).withOpacity(0.25),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFF22c55e).withOpacity(0.5)),
  ),
  child: Text(
    'Step $step',
    style: const TextStyle(
      color: Color(0xFF86efac),
      fontSize: 10,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  ),
),

                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      desc,
                      style: const TextStyle(
                        color: Color(0xFFd1d5db),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitsSection() {
    final benefits = [
      {'icon': Icons.eco, 'title': 'Save Environment', 'subtitle': 'Reduce ocean and land pollution  ', 'colors': [const Color(0xFF059669), const Color(0xFF047857)]},
      {'icon': Icons.favorite, 'title': 'Healthier Life', 'subtitle': 'Avoid harmful chemicals and toxins', 'colors': [const Color(0xFFe11d48), const Color(0xFFbe185d)]},
      {'icon': Icons.park, 'title': 'Protect Wildlife', 'subtitle': 'Save marine and terrestrial animals', 'colors': [const Color(0xFF0d9488), const Color(0xFF0e7490)]},
      {'icon': Icons.workspace_premium, 'title': 'Future Generations', 'subtitle': 'Leave a cleaner planet for our children', 'colors': [const Color(0xFFd97706), const Color(0xFFea580c)]},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF86efac), Color(0xFF34d399)],
            ).createShader(bounds),
            child: const Text(
              'Why Choose Plastic-Free Living',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Make a difference for yourself, wildlife, and future generations',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFd1d5db),
            ),
          ),
          const SizedBox(height: 64),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: benefits.length,
            itemBuilder: (context, index) {
              final isVisible = scrollOffset > 1600 + index * 100;
              return AnimatedOpacity(
                opacity: isVisible ? 1.0 : 0.3,
                duration: Duration(milliseconds: 600 + index * 100),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 600 + index * 100),
                  transform: Matrix4.translationValues(0, isVisible ? 0 : 50, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF14532d).withOpacity(0.4),
                          const Color(0xFF065f46).withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF15803d).withOpacity(0.5)),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: benefits[index]['colors'] as List<Color>,
                            ),
                          ),
                          child: Icon(
                            benefits[index]['icon'] as IconData,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          benefits[index]['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          benefits[index]['subtitle'] as String,
                          style: const TextStyle(
                            color: Color(0xFFd1d5db),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection() {
    final options = [
      {'icon': Icons.calculate, 'title': 'Plastic Calculator', 'subtitle': 'Calculate your plastic ', 'colors': [const Color(0xFF22c55e), const Color(0xFF10b981)]},
      {'icon': Icons.emoji_events, 'title': 'Incentives', 'subtitle': 'Rewards for plastic-free lifestyle', 'colors': [const Color(0xFFa855f7), const Color(0xFF7c3aed)]},
      {'icon': Icons.menu_book, 'title': 'Resources', 'subtitle': 'Expert guides & eco-friendly tips', 'colors': [const Color(0xFF3b82f6), const Color(0xFF06b6d4)]},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF86efac), Color(0xFF34d399)],
            ).createShader(bounds),
            child: const Text(
              'Start Your Plastic Awareness',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Take the first step towards a sustainable lifestyle today',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFd1d5db),
            ),
          ),
          const SizedBox(height: 64),
          ...List.generate(options.length, (index) {
            final isVisible = scrollOffset > 2400 + index * 100;
            final offset = isVisible ? 0.0 : (index % 2 == 0 ? -50.0 : 50.0);
            
            return AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.3,
              duration: Duration(milliseconds: 600 + index * 100),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 600 + index * 100),
                transform: Matrix4.translationValues(offset, 0, 0),
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
              onTap: () {
  if (options[index]['title'] == 'Plastic Calculator') {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PlasticCalculatorApp(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05), // subtle upward fade
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  } else if (options[index]['title'] == 'Incentives') {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const GovernmentSchemesPage(), // ✅ opens your schemes.dart page
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }else if (options[index]['title'] == 'Resources') {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 700),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ResourcesPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1), // smooth upward fade
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    ),
  );
}

},



                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: options[index]['colors'] as List<Color>,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (options[index]['colors'] as List<Color>)[0].withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            options[index]['icon'] as IconData,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                options[index]['title'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                options[index]['subtitle'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 64),
          const Text(
            '🌍 Together we\'ve saved over 10 million plastic items from landfills',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9ca3af),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Join thousands making the switch to a plastic-free lifestyle',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9ca3af),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFF15803d).withOpacity(0.3)),
        ),
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco, color: Color(0xFF4ade80), size: 24),
              SizedBox(width: 8),
              Text(
                'Plastic Awareness',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Every action counts. Start your journey to a cleaner planet today.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9ca3af),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '© 2025 Plastic Awareness Initiative. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9ca3af),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

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