import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/screens/dashboard.dart';

void main() {
  runApp(const GovernmentSchemesApp());
}

class GovernmentSchemesApp extends StatelessWidget {
  const GovernmentSchemesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Government Schemes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF10b981),
        scaffoldBackgroundColor: const Color(0xFF022c22),
      ),
      home: const GovernmentSchemesPage(),
    );
  }
}

class GovernmentSchemesPage extends StatefulWidget {
  const GovernmentSchemesPage({super.key});

  @override
  State<GovernmentSchemesPage> createState() => _GovernmentSchemesPageState();
}

class _GovernmentSchemesPageState extends State<GovernmentSchemesPage>
    with SingleTickerProviderStateMixin {
  String selectedCategory = 'all';
  int? expandedScheme;
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  double scrollY = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scrollController.addListener(() {
      setState(() {
        scrollY = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> schemes = [
    {
      'id': 1,
      'name': 'Plastic Waste Management Rules, 2016 & Amendments (2022)',
      'category': 'regulatory',
      'authority': 'Ministry of Environment, Forest & Climate Change (MoEF&CC)',
      'description': 'Core rules governing plastic waste handling in India - including segregation at source, recycling, and extended producer responsibility (EPR) for producers, brand-owners, and importers.',
      'impact': 'Establishes the legal framework for plastic waste management across India',
      'link': 'https://moef.gov.in',
      'icon': Icons.gavel,
      'gradient': [const Color(0xFF2563eb), const Color(0xFF0891b2)],
    },
    {
      'id': 2,
      'name': 'Scheme for Setting up of Plastic Parks',
      'category': 'infrastructure',
      'authority': 'Department of Chemicals & Petro-Chemicals',
      'description': 'Provides grants (up to 50% of project cost, max Rs 40 crore) to support plastic parks - industrial clusters for plastic processing, recycling, and waste-plastic utilization.',
      'impact': 'Creates dedicated infrastructure for organized plastic recycling and processing',
      'link': 'https://chemicals.gov.in',
      'icon': Icons.factory,
      'gradient': [const Color(0xFF7c3aed), const Color(0xFF8b5cf6)],
    },
    {
      'id': 3,
      'name': 'Swachh Bharat Mission – Urban (Plastic Waste Component)',
      'category': 'citizen',
      'authority': 'Ministry of Housing and Urban Affairs',
      'description': 'Urban sanitation & waste-management initiative with special emphasis on plastic waste: collection, segregation, recycling. Features digital deposit/refund systems for plastic bottles.',
      'impact': 'Nationwide movement engaging citizens in plastic waste management',
      'link': 'https://sbmurban.org',
      'icon': Icons.groups,
      'gradient': [const Color(0xFF059669), const Color(0xFF10b981)],
    },
    {
      'id': 4,
      'name': 'Ecomark Scheme',
      'category': 'awareness',
      'authority': 'Bureau of Indian Standards (BIS)',
      'description': 'A labelling scheme for environment-friendly products. Covers \'Plastic Products\' among its 17 categories, promoting use of better plastics or alternatives.',
      'impact': 'Helps consumers identify and choose eco-friendly plastic products',
      'link': 'https://bis.gov.in',
      'icon': Icons.emoji_events,
      'gradient': [const Color(0xFFd97706), const Color(0xFFf59e0b)],
    },
    {
      'id': 5,
      'name': 'DST Waste Management Technology Programme',
      'category': 'infrastructure',
      'authority': 'Department of Science & Technology',
      'description': 'Supports technologies for recycling plastics and converting waste plastics into useful products like tiles, panels, and construction materials.',
      'impact': 'Drives innovation in plastic waste conversion and recycling technologies',
      'link': 'https://dst.gov.in',
      'icon': Icons.lightbulb,
      'gradient': [const Color(0xFFdb2777), const Color(0xFFf43f5e)],
    },
    {
      'id': 6,
      'name': 'Extended Producer Responsibility (EPR) for Plastic Packaging',
      'category': 'regulatory',
      'authority': 'MoEF&CC under Plastic Waste Management Rules',
      'description': 'Makes producers, importers, and brand-owners responsible for the lifecycle of plastic packaging they introduce - including collection, recycling, and disposal.',
      'impact': 'Shifts responsibility to manufacturers, ensuring proper end-of-life management',
      'link': 'https://moef.gov.in',
      'icon': Icons.recycling,
      'gradient': [const Color(0xFF0d9488), const Color(0xFF06b6d4)],
    },
    {
      'id': 7,
      'name': 'Plastic Credit Scheme (Emerging)',
      'category': 'incentive',
      'authority': 'Linked to EPR Framework',
      'description': 'Evolving plastic-credit trading system where companies meet EPR targets by purchasing plastic recycling credits from certified recyclers.',
      'impact': 'Creates a market-based mechanism for achieving plastic recycling goals',
      'link': 'https://dostartup.in',
      'icon': Icons.attach_money,
      'gradient': [const Color(0xFF4f46e5), const Color(0xFF3b82f6)],
    },
    {
      'id': 8,
      'name': 'Cash Incentive Pilot Scheme for Plastic Recycling – West Bengal',
      'category': 'incentive',
      'authority': 'West Bengal Pollution Control Board',
      'description': 'State-level pilot offering cash incentives to citizens and institutions for recycling plastic waste via compactors and smart bins.',
      'impact': 'Direct financial rewards motivate citizens to participate in recycling',
      'link': 'https://wbpcb.gov.in',
      'icon': Icons.payments,
      'gradient': [const Color(0xFF059669), const Color(0xFF22c55e)],
    },
    {
      'id': 9,
      'name': 'Bharat Swachhata Kendra (BSK) Plastic Recycling Platform',
      'category': 'citizen',
      'authority': 'Local Bodies / Gram Panchayats',
      'description': 'Platform for plastic waste collection, segregation and recycling at grassroots level. Offers Rs 10 per kg incentive to villagers for plastic waste collected.',
      'impact': 'Empowers rural communities to participate in plastic waste management',
      'link': 'https://dri-bharat.co.in',
      'icon': Icons.people_alt,
      'gradient': [const Color(0xFF65a30d), const Color(0xFF84cc16)],
    },
    {
      'id': 10,
      'name': 'Innovations in Plastic Waste Conversion (Roads, Tiles etc.)',
      'category': 'infrastructure',
      'authority': 'Multiple Ministries & Research Institutions',
      'description': 'Technology and policy initiatives for using waste plastic in road building, tiles, and other construction materials through government-backed research partnerships.',
      'impact': 'Transforms plastic waste into valuable infrastructure materials',
      'link': 'https://indiascienceandtechnology.gov.in',
      'icon': Icons.business,
      'gradient': [const Color(0xFFea580c), const Color(0xFFdc2626)],
    },
  ];

  final List<Map<String, dynamic>> categories = [
    {'id': 'all', 'name': 'All Schemes', 'icon': Icons.eco},
    {'id': 'regulatory', 'name': 'Regulatory', 'icon': Icons.gavel},
    {'id': 'infrastructure', 'name': 'Infrastructure', 'icon': Icons.factory},
    {'id': 'citizen', 'name': 'Citizen Programs', 'icon': Icons.groups},
    {'id': 'incentive', 'name': 'Incentives', 'icon': Icons.attach_money},
    {'id': 'awareness', 'name': 'Awareness', 'icon': Icons.emoji_events},
  ];

  List<Map<String, dynamic>> get filteredSchemes {
    if (selectedCategory == 'all') return schemes;
    return schemes.where((s) => s['category'] == selectedCategory).toList();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF022c22), Color(0xFF065f46), Color(0xFF134e4a)],
              ),
            ),
          ),
          // Floating particles
          ...List.generate(25, (i) => _buildFloatingParticle(i)),
          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildNavigationBar(),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      _buildHeroSection(),
                      _buildCategoryFilter(),
                      _buildSchemesGrid(),
                      _buildCallToAction(),
                      _buildFooter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = math.Random(index);
    return Positioned(
      left: random.nextDouble() * 400,
      top: random.nextDouble() * 1000,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(seconds: (random.nextDouble() * 10 + 10).toInt()),
        curve: Curves.easeInOut,
        builder: (context, double value, child) {
          return Transform.translate(
            offset: Offset(
              math.sin(value * 2 * math.pi) * 20,
              math.cos(value * 2 * math.pi) * 30,
            ),
            child: Container(
              width: random.nextDouble() * 4 + 2,
              height: random.nextDouble() * 4 + 2,
              decoration: BoxDecoration(
                color: const Color(0xFF10b981).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF065f46).withOpacity(0.8),
            const Color(0xFF047857).withOpacity(0.8),
            const Color(0xFF0d9488).withOpacity(0.8),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: const Color(0xFF10b981).withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animationController.value * 0.1 - 0.05,
                    child: const Icon(Icons.eco, color: Color(0xFF10b981), size: 32),
                  );
                },
              ),
              const SizedBox(width: 8),
              const Text(
                ' Schemes ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton.icon(
  onPressed: () {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) => const Dashboard(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          final slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(fadeAnimation);

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  },
  icon: const Icon(Icons.arrow_back, size: 16),
  label: const Text('Back to Home'),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF065f46).withOpacity(0.4),
    foregroundColor: Colors.white,
    side: BorderSide(color: const Color(0xFF10b981).withOpacity(0.5)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  ),
),

        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 32),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, math.sin(_animationController.value * 2 * math.pi) * 15),
                child: Transform.rotate(
                  angle: _animationController.value * 0.1 - 0.05,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10b981), Color(0xFF047857), Color(0xFF0d9488)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10b981).withOpacity(0.5),
                          blurRadius: 60,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.gavel, size: 80, color: Colors.white),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF86efac), Color(0xFF10b981), Color(0xFF5eead4)],
            ).createShader(bounds),
            child: const Text(
              'Government Schemes &\nInitiatives',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Explore India\'s policy framework and support mechanisms for plastic waste management. These initiatives empower citizens, industries, and local bodies to combat plastic pollution.',
              style: TextStyle(fontSize: 18, color: Color(0xFFd1d5db), height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF065f46).withOpacity(0.4),
                  const Color(0xFF047857).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF10b981).withOpacity(0.5)),
            ),
            child: const Text(
              '🌍 10 Active Schemes across Regulatory, Infrastructure, Citizen Programs & Incentives',
              style: TextStyle(color: Color(0xFFd1d5db)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF065f46).withOpacity(0.4),
              const Color(0xFF047857).withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF10b981).withOpacity(0.5)),
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: categories.map((cat) {
            final isActive = selectedCategory == cat['id'];
            return GestureDetector(
              onTap: () => setState(() => selectedCategory = cat['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? const LinearGradient(
                          colors: [Color(0xFF10b981), Color(0xFF047857)],
                        )
                      : null,
                  color: isActive ? null : const Color(0xFF065f46).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: isActive
                      ? null
                      : Border.all(color: const Color(0xFF10b981).withOpacity(0.3)),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF10b981).withOpacity(0.3),
                            blurRadius: 12,
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      size: 20,
                      color: isActive ? Colors.white : const Color(0xFFd1d5db),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      cat['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : const Color(0xFFd1d5db),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSchemesGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
      child: Column(
        children: filteredSchemes.asMap().entries.map((entry) {
          final index = entry.key;
          final scheme = entry.value;
          final isExpanded = expandedScheme == scheme['id'];
          final opacity = scrollY > 300 + index * 80 ? 1.0 : 0.3;
          final translateY = scrollY > 300 + index * 80 ? 0.0 : 50.0;

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: opacity,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              transform: Matrix4.translationValues(0, translateY, 0),
              margin: const EdgeInsets.only(bottom: 24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF065f46).withOpacity(0.4),
                      const Color(0xFF047857).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF10b981).withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: List<Color>.from(scheme['gradient']),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (scheme['gradient'][0] as Color).withOpacity(0.5),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  scheme['icon'] as IconData,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            scheme['name'] as String,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF10b981).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: const Color(0xFF10b981).withOpacity(0.5),
                                            ),
                                          ),
                                          child: Text(
                                            '#${scheme['id']}',
                                            style: const TextStyle(
                                              color: Color(0xFF10b981),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.business,
                                          size: 16,
                                          color: Color(0xFF10b981),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            scheme['authority'] as String,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF9ca3af),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            scheme['description'] as String,
                            style: const TextStyle(
                              color: Color(0xFFd1d5db),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      expandedScheme = isExpanded ? null : scheme['id'] as int;
                                    });
                                  },
                                  icon: Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 16,
                                  ),
                                  label: Text(isExpanded ? 'Show Less' : 'Learn More'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF065f46).withOpacity(0.4),
                                    foregroundColor: const Color(0xFF10b981),
                                    side: BorderSide(
                                      color: const Color(0xFF10b981).withOpacity(0.5),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _launchURL(scheme['link'] as String),
                                  icon: const Icon(Icons.open_in_new, size: 16),
                                  label: const Text('Official Website'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10b981),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: const Color(0xFF10b981).withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF065f46).withOpacity(0.6),
                                    const Color(0xFF047857).withOpacity(0.4),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF10b981).withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.emoji_events,
                                        size: 16,
                                        color: Color(0xFF10b981),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Impact & Benefits',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF10b981),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    scheme['impact'] as String,
                                    style: const TextStyle(
                                      color: Color(0xFFd1d5db),
                                      fontSize: 14,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF1e3a8a).withOpacity(0.3),
                                    const Color(0xFF0369a1).withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF3b82f6).withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.groups,
                                        size: 16,
                                        color: Color(0xFF3b82f6),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'How You Can Participate',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF3b82f6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...() {
                                    List<String> points = [];
                                    switch (scheme['category']) {
                                      case 'citizen':
                                        points = [
                                          '• Register with local collection centers',
                                          '• Participate in segregation at source',
                                          '• Track your contribution digitally',
                                        ];
                                        break;
                                      case 'incentive':
                                        points = [
                                          '• Collect and segregate plastic waste',
                                          '• Submit to authorized collection points',
                                          '• Receive monetary rewards or credits',
                                        ];
                                        break;
                                      case 'regulatory':
                                        points = [
                                          '• Understand your rights as a consumer',
                                          '• Report non-compliant producers',
                                          '• Support businesses following EPR',
                                        ];
                                        break;
                                      case 'infrastructure':
                                        points = [
                                          '• Support local recycling initiatives',
                                          '• Advocate for infrastructure in your area',
                                          '• Explore business opportunities',
                                        ];
                                        break;
                                      case 'awareness':
                                        points = [
                                          '• Look for Ecomark certified products',
                                          '• Spread awareness in your community',
                                          '• Choose sustainable alternatives',
                                        ];
                                        break;
                                    }
                                    return points
                                        .map((point) => Padding(
                                              padding: const EdgeInsets.only(bottom: 4),
                                              child: Text(
                                                point,
                                                style: const TextStyle(
                                                  color: Color(0xFFd1d5db),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ))
                                        .toList();
                                  }(),
                                ],
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
        }).toList(),
      ),
    );
  }

  Widget _buildCallToAction() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF065f46).withOpacity(0.6),
              const Color(0xFF047857).withOpacity(0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF10b981).withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            const Text(
              '🇮🇳',
              style: TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 16),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF86efac), Color(0xFF10b981)],
              ).createShader(bounds),
              child: const Text(
                'Be Part of the Solution',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'These schemes represent India\'s commitment to tackling plastic pollution. From regulatory frameworks to citizen incentives, there are multiple ways you can contribute to a cleaner future.',
                style: TextStyle(
                  color: Color(0xFFd1d5db),
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: const Color(0xFF10b981).withOpacity(0.3),
        ),
      ),
    ),
    child: const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.eco,
              color: Color(0xFF10b981),
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Plastic Awareness',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Supporting Government of India’s initiatives towards sustainable plastic waste management.',
          style: TextStyle(
            color: Color(0xFF9ca3af),
            fontSize: 14,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          '© 2025 Plastic Awareness Initiative. All Rights Reserved.',
          style: TextStyle(
            color: Color(0xFF6b7280),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
    }