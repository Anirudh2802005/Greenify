import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:math' as math;
import 'package:flutter_application_1/screens/dashboard.dart';
void main() {
  runApp(const PlasticCalculatorApp());
}

class PlasticCalculatorApp extends StatelessWidget {
  const PlasticCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plastic Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF10b981),
        scaffoldBackgroundColor: const Color(0xFF022c22),
      ),
      home: const PlasticCalculatorPage(),
    );
  }
}

class PlasticCalculatorPage extends StatefulWidget {
  const PlasticCalculatorPage({super.key});

  @override
  State<PlasticCalculatorPage> createState() => _PlasticCalculatorPageState();
}

class _PlasticCalculatorPageState extends State<PlasticCalculatorPage>
    with TickerProviderStateMixin {
  int _activeTab = 0;
  bool _showCelebration = false;
  double _goal = 30;

  final Map<String, int> _dailyUsage = {
    'bottles': 0,
    'bags': 0,
    'wrappers': 0,
    'straws': 0,
    'cups': 0,
    'containers': 0,
  };

  final Map<String, int> _itemWeights = {
    'bottles': 30,
    'bags': 5,
    'wrappers': 3,
    'straws': 1,
    'cups': 8,
    'containers': 15,
  };

  final Map<String, Map<String, String>> _categories = {
    'bottles': {'type': 'recyclable', 'name': 'Plastic Bottles'},
    'bags': {'type': 'single-use', 'name': 'Plastic Bags'},
    'wrappers': {'type': 'non-recyclable', 'name': 'Food Wrappers'},
    'straws': {'type': 'single-use', 'name': 'Straws'},
    'cups': {'type': 'recyclable', 'name': 'Cups'},
    'containers': {'type': 'recyclable', 'name': 'Containers'},
  };

  final List<Map<String, dynamic>> _history = [];
  late AnimationController _leafController;
  late AnimationController _glowController;

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
  }

  @override
  void dispose() {
    _leafController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  int get _totalGrams {
    return _dailyUsage.entries.fold(0, (sum, entry) {
      return sum + (entry.value * _itemWeights[entry.key]!);
    });
  }

  int get _weeklyTotal => _totalGrams * 7;
  int get _monthlyTotal => _totalGrams * 30;

  Map<String, int> _getCategoryTotals() {
    final totals = {'single-use': 0, 'recyclable': 0, 'non-recyclable': 0};
    _dailyUsage.forEach((key, value) {
      final weight = value * _itemWeights[key]!;
      final type = _categories[key]!['type']!;
      totals[type] = (totals[type] ?? 0) + weight;
    });
    return totals;
  }

  Map<String, dynamic> _getFootprintScore() {
    if (_weeklyTotal <= 50) {
      return {
        'level': 'Eco Champion',
        'icon': Icons.eco,
        'color': const Color(0xFF10b981),
      };
    } else if (_weeklyTotal <= 150) {
      return {
        'level': 'Needs Improvement',
        'icon': Icons.recycling,
        'color': const Color(0xFFfbbf24),
      };
    }
    return {
      'level': 'High Plastic User',
      'icon': Icons.warning_amber,
      'color': const Color(0xFFef4444),
    };
  }

  String _getAwarenessTip() {
    final tips = [
      "Try using a reusable metal bottle instead of plastic!",
      "Bring your own shopping bags to reduce plastic usage!",
      "Use beeswax wraps instead of plastic wrap!",
      "Say no to plastic straws - use metal or bamboo alternatives!",
      "Choose products with minimal packaging!",
      "Invest in reusable food containers!"
    ];
    return tips[math.Random().nextInt(tips.length)];
  }

  void _addToHistory() {
    if (_totalGrams > 0) {
      setState(() {
        _history.add({
          'date': DateTime.now().toString().substring(0, 10),
          'total': _totalGrams,
        });
        if (_history.length > 7) {
          _history.removeAt(0);
        }

        if (_totalGrams < (_weeklyTotal / 7) * (1 - _goal / 100)) {
          _showCelebration = true;
          Future.delayed(const Duration(seconds: 3), () {
            setState(() => _showCelebration = false);
          });
        }

        _dailyUsage.updateAll((key, value) => 0);
      });
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
                colors: [
                  Color(0xFF022c22),
                  Color(0xFF065f46),
                  Color(0xFF134e4a),
                ],
              ),
            ),
          ),
          // Floating particles
          ...List.generate(25, (index) => _buildFloatingParticle()),
          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildTabBar(),
                        const SizedBox(height: 24),
                        _buildTabContent(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Celebration overlay
          if (_showCelebration) _buildCelebration(),
        ],
      ),
    );
  }

  Widget _buildFloatingParticle() {
    final random = math.Random();
    return Positioned(
      left: random.nextDouble() * 400,
      top: random.nextDouble() * 800,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(seconds: 10 + random.nextInt(10)),
        curve: Curves.easeInOut,
        builder: (context, double value, child) {
          return Transform.translate(
            offset: Offset(
              math.sin(value * 2 * math.pi) * 20,
              math.cos(value * 2 * math.pi) * 30,
            ),
            child: Container(
              width: 2 + random.nextDouble() * 4,
              height: 2 + random.nextDouble() * 4,
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

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF065f46).withOpacity(0.8),
            const Color(0xFF047857).withOpacity(0.8),
            const Color(0xFF0d9488).withOpacity(0.8),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF10b981).withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _leafController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _leafController.value * 0.1 - 0.05,
                    child: const Icon(
                      Icons.eco,
                      color: Color(0xFF10b981),
                      size: 32,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              const Text(
                'Calculator ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
      ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Dashboard(),
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
      label: const Text('  Back to Home  '),
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

  Widget _buildHeader() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _leafController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, math.sin(_leafController.value * 2 * math.pi) * 15),
              child: Transform.rotate(
                angle: _leafController.value * 0.1 - 0.05,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10b981), Color(0xFF047857), Color(0xFF0d9488)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10b981).withOpacity(0.4),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.eco, size: 64, color: Colors.white),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF86efac), Color(0xFF10b981), Color(0xFF5eead4)],
          ).createShader(bounds),
          child: const Text(
            'Track Your Plastic Footprint',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Monitor, analyze, and reduce your plastic consumption',
          style: TextStyle(fontSize: 16, color: Color(0xFFd1d5db)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF065f46).withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF10b981).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          _buildTab('Input', 0),
          _buildTab('Stats', 1),
          _buildTab('Goals', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFF10b981), Color(0xFF047857)],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF10b981).withOpacity(0.3),
                      blurRadius: 8,
                    )
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : const Color(0xFFd1d5db),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 0:
        return _buildInputTab();
      case 1:
        return _buildStatsTab();
      case 2:
        return _buildGoalsTab();
      default:
        return Container();
    }
  }

  Widget _buildInputTab() {
    return Column(
      children: [
        _buildDailyUsageCard(),
        const SizedBox(height: 16),
        _buildQuickStats(),
        const SizedBox(height: 16),
        if (_getCategoryTotals().values.any((v) => v > 0)) _buildPieChart(),
        const SizedBox(height: 16),
        if (_totalGrams > 0) _buildAwarenessTip(),
      ],
    );
  }

  Widget _buildDailyUsageCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFF10b981)),
              SizedBox(width: 8),
              Text(
                'Daily Plastic Usage',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._dailyUsage.keys.map((key) => _buildInputField(key)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _totalGrams > 0 ? _addToHistory : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF10b981),
                disabledBackgroundColor: const Color(0xFF065f46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Daily Usage',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_categories[key]!['name']} (${_itemWeights[key]}g each)',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFd1d5db),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF065f46).withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF10b981).withOpacity(0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF10b981).withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF10b981), width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _dailyUsage[key] = int.tryParse(value) ?? 0;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatCard('Daily Total', '$_totalGrams g', const Color(0xFF2563eb)),
        const SizedBox(width: 8),
        _buildStatCard('Weekly Total', '$_weeklyTotal g', const Color(0xFF7c3aed)),
        const SizedBox(width: 8),
        _buildStatCard('Monthly Total', '$_monthlyTotal g', const Color(0xFFdb2777)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final totals = _getCategoryTotals();
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plastic Category Breakdown',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: totals['single-use']!.toDouble(),
                    color: const Color(0xFFef4444),
                    title: '${totals['single-use']}g',
                    radius: 80,
                  ),
                  PieChartSectionData(
                    value: totals['non-recyclable']!.toDouble(),
                    color: const Color(0xFFfbbf24),
                    title: '${totals['non-recyclable']}g',
                    radius: 80,
                  ),
                  PieChartSectionData(
                    value: totals['recyclable']!.toDouble(),
                    color: const Color(0xFF10b981),
                    title: '${totals['recyclable']}g',
                    radius: 80,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLegendItem('Single-use plastic (Most harmful)', const Color(0xFFef4444)),
          _buildLegendItem('Non-recyclable plastic', const Color(0xFFfbbf24)),
          _buildLegendItem('Recyclable plastic (Better choice)', const Color(0xFF10b981)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Color(0xFFd1d5db))),
        ],
      ),
    );
  }

  Widget _buildAwarenessTip() {
    final seaTurtles = (_weeklyTotal / 250).floor();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF78350f).withOpacity(0.4),
            const Color(0xFF92400e).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFf59e0b).withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber, color: Color(0xFFfbbf24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Environmental Impact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFfcd34d),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You used $_weeklyTotal g of plastic this week = harming ${seaTurtles > 0 ? "$seaTurtles sea turtle${seaTurtles > 1 ? 's' : ''} worth of plastic waste! 🌊" : "Great job keeping plastic use low! 🌊"}',
                      style: const TextStyle(color: Color(0xFFd1d5db)),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF451a03).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFf59e0b).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '💡 ${_getAwarenessTip()}',
                        style: const TextStyle(
                          color: Color(0xFFe5e7eb),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    final footprint = _getFootprintScore();
    final progressPercent = math.min((_weeklyTotal / 150) * 100, 100.0);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
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
              const Row(
                children: [
                  Icon(Icons.emoji_events, color: Color(0xFF10b981)),
                  SizedBox(width: 8),
                  Text(
                    'Your Plastic Footprint Score',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Icon(
                footprint['icon'],
                size: 80,
                color: footprint['color'],
              ),
              const SizedBox(height: 16),
              Text(
                footprint['level'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: footprint['color'],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF022c22),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF10b981).withOpacity(0.5),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressPercent / 100,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(footprint['color']),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$_weeklyTotal g / 150g weekly',
                style: const TextStyle(color: Color(0xFFd1d5db)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildScoreCategory('0-50g', 'Eco Champion 🌎', const Color(0xFF10b981)),
                  const SizedBox(width: 8),
                  _buildScoreCategory('51-150g', 'Needs Improvement ♻️', const Color(0xFFfbbf24)),
                  const SizedBox(width: 8),
                  _buildScoreCategory('151g+', 'High User ⚠️', const Color(0xFFef4444)),
                ],
              ),
            ],
          ),
        ),
        if (_history.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildUsageTrend(),
        ],
      ],
    );
  }

  Widget _buildScoreCategory(String range, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              range,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFFd1d5db)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageTrend() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Usage Trend',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color(0xFF065f46),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < _history.length) {
                          return Text(
                            _history[index]['date'].substring(5),
                            style: const TextStyle(
                              color: Color(0xFFd1d5db),
                              fontSize: 10,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _history
                        .asMap()
                        .entries
                        .map((e) => FlSpot(
                              e.key.toDouble(),
                              e.value['total'].toDouble(),
                            ))
                        .toList(),
                    isCurved: true,
                    color: const Color(0xFF10b981),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF10b981).withOpacity(0.2),
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

  Widget _buildGoalsTab() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flag, color: Color(0xFF10b981)),
              SizedBox(width: 8),
              Text(
                'Set Your Plastic Reduction Goal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Target: Reduce plastic usage by ${_goal.toStringAsFixed(0)}%',
            style: const TextStyle(color: Color(0xFFd1d5db), fontSize: 16),
          ),
          Slider(
            value: _goal,
            min: 10,
            max: 90,
            divisions: 8,
            activeColor: const Color(0xFF10b981),
            label: '${_goal.round()}%',
            onChanged: (value) {
              setState(() => _goal = value);
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Tips to Reach Your Goal:',
            style: TextStyle(
              color: Color(0xFFa7f3d0),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          _buildGoalTip('🛍️ Carry reusable cloth bags.'),
          _buildGoalTip('🥤 Avoid buying bottled drinks.'),
          _buildGoalTip('🍱 Bring your own containers for takeout.'),
          _buildGoalTip('🧴 Refill products instead of new plastic ones.'),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _showCelebration = true;
                });
                Future.delayed(const Duration(seconds: 3), () {
                  setState(() => _showCelebration = false);
                });
              },
              icon: const Icon(Icons.celebration),
              label: const Text('Celebrate Progress'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10b981),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF10b981), size: 20),
          const SizedBox(width: 8),
          Text(
            tip,
            style: const TextStyle(color: Color(0xFFd1d5db), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebration() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.celebration, size: 100, color: Color(0xFF10b981)),
            SizedBox(height: 16),
            Text(
              'Great job! 🎉\nYou made progress toward reducing plastic waste!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
