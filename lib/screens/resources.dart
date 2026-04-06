import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/screens/dashboard.dart';
void main() {
  runApp(const ResourcesApp());
}

class ResourcesApp extends StatelessWidget {
  const ResourcesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resources',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF10b981),
        scaffoldBackgroundColor: const Color(0xFF022c22),
      ),
      home: const ResourcesPage(),
    );
  }
}

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  double scrollY = 0;
  String selectedCategory = 'all';

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

  final List<Map<String, dynamic>> categories = [
    {'id': 'all', 'name': 'All', 'icon': Icons.grid_view},
    {'id': 'education', 'name': 'Education', 'icon': Icons.school},
    {'id': 'alternatives', 'name': 'Alternatives', 'icon': Icons.eco},
    {'id': 'diy', 'name': 'DIY Ideas', 'icon': Icons.construction},
    {'id': 'videos', 'name': 'Videos', 'icon': Icons.play_circle},
    {'id': 'links', 'name': 'Links', 'icon': Icons.link},
  ];

  final List<Map<String, dynamic>> educationalArticles = [
    {
      'title': 'What is Plastic Pollution?',
      'description': 'Understanding causes, effects, and global impact of plastic waste on our environment.',
      'icon': Icons.info_outline,
      'color': [const Color(0xFF3b82f6), const Color(0xFF2563eb)],
      'category': 'education',
      'action': 'article',
      'fullContent': '''Plastic pollution is one of the most pressing environmental issues of our time. It refers to the accumulation of plastic products in the environment that adversely affects wildlife, habitat, and humans.

Key Points:
• Over 8 million tons of plastic enter our oceans every year
• Plastic takes 400-1000 years to decompose
• Microplastics have been found in human blood and organs
• Marine animals mistake plastic for food, leading to starvation
• Plastic production has increased 20x in the past 50 years

The main causes include:
1. Single-use plastics (bottles, bags, straws)
2. Poor waste management systems
3. Lack of recycling infrastructure
4. Consumer behavior and convenience culture
5. Industrial waste discharge

Effects on Environment:
- Ocean pollution affecting 700+ marine species
- Soil contamination reducing agricultural productivity
- Air pollution from plastic burning
- Disruption of ecosystems and food chains''',
    },
    {
      'title': 'Types of Plastics & Their Impacts',
      'description': 'Learn about different plastic types, their uses, and environmental footprint.',
      'icon': Icons.category,
      'color': [const Color(0xFF8b5cf6), const Color(0xFF7c3aed)],
      'category': 'education',
      'action': 'article',
      'fullContent': '''Understanding plastic types helps in proper disposal and recycling.

7 Types of Plastics:

1. PET (Polyethylene Terephthalate) - #1
   • Used in: Water bottles, soft drink bottles
   • Recyclable: Yes, but only once or twice
   • Impact: Releases antimony and phthalates

2. HDPE (High-Density Polyethylene) - #2
   • Used in: Milk jugs, detergent bottles
   • Recyclable: Yes, highly recyclable
   • Impact: Relatively safe, less toxic

3. PVC (Polyvinyl Chloride) - #3
   • Used in: Pipes, credit cards
   • Recyclable: Rarely
   • Impact: Contains toxic chemicals, releases dioxins

4. LDPE (Low-Density Polyethylene) - #4
   • Used in: Plastic bags, food wraps
   • Recyclable: Sometimes
   • Impact: Takes centuries to decompose

5. PP (Polypropylene) - #5
   • Used in: Yogurt containers, bottle caps
   • Recyclable: Yes
   • Impact: Heat-resistant but slow to degrade

6. PS (Polystyrene/Styrofoam) - #6
   • Used in: Disposable cups, takeout containers
   • Recyclable: Rarely
   • Impact: Extremely harmful, releases styrene

7. Others (PC, ABS, etc.) - #7
   • Used in: Mixed plastics, CDs
   • Recyclable: Usually not
   • Impact: Often contains BPA''',
    },
    {
      'title': 'Plastic\'s Journey',
      'description': 'From manufacturing to disposal - tracking the complete lifecycle of plastic products.',
      'icon': Icons.route,
      'color': [const Color(0xFF06b6d4), const Color(0xFF0891b2)],
      'category': 'education',
      'action': 'article',
      'fullContent': '''The lifecycle of plastic reveals its true environmental cost.

Stage 1: Production (Raw Materials)
• Extracted from crude oil and natural gas
• Requires significant energy and water
• Releases greenhouse gases
• Global production: 400+ million tons annually

Stage 2: Manufacturing
• Plastic pellets shaped into products
• Chemical additives mixed (colorants, stabilizers)
• Energy-intensive process
• Factory emissions pollute air and water

Stage 3: Distribution & Use
• Transportation adds to carbon footprint
• Average use time: 12-15 minutes for single-use items
• Convenience comes at environmental cost

Stage 4: Disposal
Option A - Landfill (79%)
• Takes 400-1000 years to decompose
• Leaches toxic chemicals into soil
• Occupies valuable land space

Option B - Incineration (12%)
• Releases toxic fumes and dioxins
• Contributes to air pollution
• Creates hazardous ash

Option C - Recycling (9%)
• Only 9% of plastic ever made has been recycled
• Downcycling: quality decreases with each cycle
• Limited infrastructure in many regions

Stage 5: Environmental Persistence
• Breaks into microplastics (never fully disappears)
• Enters food chain and water systems
• Found in Arctic ice and deepest ocean trenches
• Accumulates in animal and human tissues''',
    },
    {
      'title': 'Statistics & Facts',
      'description': 'Real data about plastic waste in India and worldwide. Know the numbers.',
      'icon': Icons.bar_chart,
      'color': [const Color(0xFFf59e0b), const Color(0xFFd97706)],
      'category': 'education',
      'action': 'article',
      'fullContent': '''Shocking statistics that reveal the scale of plastic pollution.

Global Statistics:
• 400 million tons of plastic produced annually
• 8 million tons enter oceans each year
• 5 trillion plastic pieces floating in oceans
• By 2050: More plastic than fish in oceans (by weight)
• 1 million plastic bottles purchased every minute
• 5 trillion plastic bags used worldwide yearly
• Only 9% of all plastic ever made has been recycled

India-Specific Data:
• 9.46 million tons of plastic waste generated annually
• 43% of plastic is single-use packaging
• 26,000 tons of plastic waste generated daily
• Only 60% is recycled
• Mumbai generates 700 tons of plastic waste daily
• Delhi: 689 tons per day
• Bengaluru: 300 tons per day

Health Impact:
• Microplastics found in 93% of bottled water
• Average person ingests 5g of plastic weekly (credit card weight)
• Linked to hormonal disruption and cancer
• Found in human blood, lungs, and placenta

Marine Life:
• 1 million seabirds die from plastic annually
• 100,000 marine mammals killed yearly
• 700+ species affected by plastic pollution
• 90% of seabirds have plastic in their stomachs

Economic Impact:
• 13 billion in damage to marine ecosystems yearly
• Tourism and fishing industries severely affected
• Cleanup costs billions annually
• Healthcare costs from plastic-related illnesses rising

Time to Decompose:
• Plastic bag: 20 years
• Plastic bottle: 450 years
• Disposable diaper: 450 years
• Fishing line: 600 years
• Styrofoam cup: Never fully decomposes''',
    },
    {
      'title': 'Microplastics',
      'description': 'How tiny plastic particles affect human health and marine ecosystems.',
      'icon': Icons.bubble_chart,
      'color': [const Color(0xFFec4899), const Color(0xFFdb2777)],
      'category': 'education',
      'action': 'article',
      'fullContent': '''Microplastics are plastic particles smaller than 5mm that pose invisible threats.

What are Microplastics?
• Primary: Manufactured small (microbeads in cosmetics)
• Secondary: Broken down from larger plastics
• Size: Less than 5mm, some microscopic
• Persistent: Never fully biodegrades

Sources:
1. Synthetic clothing (35% of ocean microplastics)
2. Tire dust from vehicles
3. Cosmetics and personal care products
4. Breakdown of larger plastic items
5. Industrial plastic pellets
6. Paint and coatings

Where They're Found:
• Tap water (83% of samples globally)
• Bottled water (93% contamination rate)
• Sea salt (90% of brands tested)
• Seafood and fish
• Beer and honey
• Human blood and organs
• Arctic ice and mountain snow
• Rain and air we breathe

Health Impacts:
• Enter bloodstream through digestion
• Accumulate in organs (liver, kidneys, lungs)
• Disrupt hormones (endocrine disruption)
• Cause inflammation
• Potentially carcinogenic
• Affect reproductive health
• Average person ingests 50,000 particles yearly

Environmental Impact:
• Absorbed by smallest marine organisms
• Biomagnification up the food chain
• Toxic chemicals hitch a ride on particles
• Disrupt coral reefs and ecosystems
• Soil contamination affects crops
• Birds and fish mistake them for food

How to Reduce Exposure:
1. Use glass or metal water bottles
2. Avoid synthetic clothing (choose natural fibers)
3. Don't microwave food in plastic containers
4. Choose products without microbeads
5. Use natural fiber tea bags
6. Install water filters at home
7. Reduce overall plastic consumption
8. Support plastic-free packaging''',
    },
  ];

  final List<Map<String, dynamic>> alternatives = [
    {
      'title': 'Bamboo Toothbrush',
      'icon': '🪥',
      'cost': '₹50-100',
      'impact': 'Saves 4-5 plastic toothbrushes per year',
      'category': 'alternatives',
      'color': [const Color(0xFF10b981), const Color(0xFF059669)],
      'action': 'detail',
    },
    {
      'title': 'Cloth Shopping Bags',
      'icon': '🛍️',
      'cost': '₹30-80',
      'impact': 'Replaces 500+ plastic bags annually',
      'category': 'alternatives',
      'color': [const Color(0xFF8b5cf6), const Color(0xFF7c3aed)],
      'action': 'detail',
    },
    {
      'title': 'Metal/Glass Bottles',
      'icon': '🧴',
      'cost': '₹200-500',
      'impact': 'Eliminates 150+ plastic bottles yearly',
      'category': 'alternatives',
      'color': [const Color(0xFF3b82f6), const Color(0xFF2563eb)],
      'action': 'detail',
    },
    {
      'title': 'Paper Packaging',
      'icon': '📦',
      'cost': '₹10-50',
      'impact': 'Biodegradable alternative to plastic wrap',
      'category': 'alternatives',
      'color': [const Color(0xFFf59e0b), const Color(0xFFd97706)],
      'action': 'detail',
    },
    {
      'title': 'Reusable Food Wraps',
      'icon': '🥪',
      'cost': '₹150-300',
      'impact': 'Replaces 100+ plastic wraps per year',
      'category': 'alternatives',
      'color': [const Color(0xFFec4899), const Color(0xFFdb2777)],
      'action': 'detail',
    },
    {
      'title': 'Steel Straws',
      'icon': '🥤',
      'cost': '₹100-200',
      'impact': 'Saves 200+ plastic straws annually',
      'category': 'alternatives',
      'color': [const Color(0xFF06b6d4), const Color(0xFF0891b2)],
      'action': 'detail',
    },
  ];

  final List<Map<String, dynamic>> diyIdeas = [
    {
      'title': 'Planters from Bottles',
      'icon': '🌿',
      'difficulty': 'Easy',
      'time': '10 mins',
      'description': 'Transform plastic bottles into beautiful hanging planters',
      'category': 'diy',
      'color': [const Color(0xFF10b981), const Color(0xFF059669)],
      'action': 'tutorial',
      'steps': [
        'Clean empty plastic bottles thoroughly and remove labels',
        'Cut bottles in half using scissors or a craft knife',
        'Make 2-3 small drainage holes at the bottom with a heated needle',
        'Paint the outside with acrylic paint (optional for decoration)',
        'Add decorative elements like twine, ribbons, or fabric',
        'Fill bottom with small stones for drainage',
        'Add potting soil mixed with compost',
        'Plant your chosen herbs or flowers',
        'For hanging: Punch holes on sides and thread strong rope',
        'Water gently and place in suitable light conditions',
      ],
      'materials': 'Empty plastic bottles, scissors, paint, soil, plants, rope',
      'tips': 'Use clear bottles for better root visibility. Bottom half makes stable pots, top half great for hanging.',
    },
    {
      'title': 'Lamps from Plastic Spoons',
      'icon': '💡',
      'difficulty': 'Medium',
      'time': '30 mins',
      'description': 'Create stunning decorative lamps using plastic spoons',
      'category': 'diy',
      'color': [const Color(0xFFf59e0b), const Color(0xFFd97706)],
      'action': 'tutorial',
      'steps': [
        'Collect 100+ plastic spoons and cut off handles',
        'Take a large plastic bottle (5L) and cut off the bottom',
        'Start from bottom: glue spoon heads in overlapping circular rows',
        'Continue layering spoons upward like flower petals',
        'Ensure each row overlaps previous one by half',
        'Leave the bottle neck open for light bulb',
        'Once covered, spray paint entire lamp (white or gold looks great)',
        'Let paint dry completely (2-3 hours)',
        'Install LED bulb holder through bottle neck',
        'Hang or mount with the neck facing down',
      ],
      'materials': 'Plastic spoons (100+), 5L bottle, hot glue gun, spray paint, LED bulb, electrical fittings',
      'tips': 'Use LED bulbs only (they don\'t heat up). White spoons need less paint. Work in a ventilated area.',
    },
    {
      'title': 'Wall Art from Bottle Caps',
      'icon': '🎨',
      'difficulty': 'Easy',
      'time': '20 mins',
      'description': 'Design colorful wall art with collected bottle caps',
      'category': 'diy',
      'color': [const Color(0xFFec4899), const Color(0xFFdb2777)],
      'action': 'tutorial',
      'steps': [
        'Collect bottle caps in various colors (50-100 caps)',
        'Wash and dry all caps thoroughly',
        'Sort caps by color into separate containers',
        'Draw your design on paper first (simple shapes work best)',
        'Mark design outline on canvas or wooden board',
        'Apply strong adhesive (E6000 or hot glue) to cap backs',
        'Press caps firmly onto surface following your pattern',
        'Fill in background with additional caps for mosaic effect',
        'Let glue dry overnight for strong bond',
        'Optional: Apply clear sealant spray for weather protection',
      ],
      'materials': 'Bottle caps (50-100), canvas/wood board, strong glue, marker, clear sealant (optional)',
      'tips': 'Start with simple designs like hearts, flowers, or letters. Mix cap orientations for texture.',
    },
    {
      'title': 'Bird Feeders',
      'icon': '🐦',
      'difficulty': 'Easy',
      'time': '15 mins',
      'description': 'Build eco-friendly bird feeders from plastic bottles',
      'category': 'diy',
      'color': [const Color(0xFF3b82f6), const Color(0xFF2563eb)],
      'action': 'tutorial',
      'steps': [
        'Take a clean 2L plastic bottle with cap',
        'Cut two small holes (3cm diameter) on opposite sides, 10cm from bottom',
        'Below each hole, make smaller holes and insert wooden dowels for perches',
        'Make 4-6 tiny drainage holes at the very bottom',
        'Decorate bottle with weather-proof paint or leave clear',
        'Fill bottle with bird seed through top opening',
        'Poke two holes near cap and thread wire through for hanging',
        'Hang from tree branch at 5-6 feet height',
        'Keep away from windows and predator access',
        'Clean and refill weekly',
      ],
      'materials': 'Plastic bottle (2L), wooden dowels, wire, bird seed, scissors/knife, paint (optional)',
      'tips': 'Position near bushes for bird safety. Add a bottle cap glued on top as rain cover. Use different seeds to attract various species.',
    },
    {
      'title': 'Organizers from Containers',
      'icon': '📦',
      'difficulty': 'Easy',
      'time': '15 mins',
      'description': 'Create desk and drawer organizers from plastic containers',
      'category': 'diy',
      'color': [const Color(0xFF06b6d4), const Color(0xFF0891b2)],
      'action': 'tutorial',
      'steps': [
        'Gather various plastic containers (yogurt cups, bottles, food containers)',
        'Clean thoroughly and remove all labels and adhesive',
        'Cut containers to desired heights using sharp scissors',
        'Sand rough edges with sandpaper for safety',
        'Measure and plan layout for drawers or desk space',
        'Spray paint all containers in matching colors (optional)',
        'Let paint dry for 2-3 hours',
        'Arrange containers in drawer or on tray',
        'Use double-sided tape or glue to secure positions if needed',
        'Fill with office supplies, makeup, or small items',
      ],
      'materials': 'Plastic containers (various), scissors, sandpaper, spray paint, double-sided tape',
      'tips': 'Use different heights for visual interest. Group by function. Clear containers work great for visibility.',
    },
    {
      'title': 'Watering Can from Bottle',
      'icon': '💧',
      'difficulty': 'Easy',
      'time': '5 mins',
      'description': 'Make a simple watering can for your plants',
      'category': 'diy',
      'color': [const Color(0xFF10b981), const Color(0xFF059669)],
      'action': 'tutorial',
      'steps': [
        'Take a clean plastic bottle (1-2L) with cap',
        'Use a heated needle or small drill bit',
        'Poke 10-15 small holes in the bottle cap',
        'Ensure holes are evenly distributed for even water flow',
        'Test water flow by filling and tipping',
        'Adjust hole size if water flows too fast or slow',
        'Decorate bottle with waterproof stickers (optional)',
        'Fill with water and screw cap tightly',
        'Squeeze gently for gentle watering or tip for stronger flow',
        'Perfect for seedlings and delicate plants',
      ],
      'materials': 'Plastic bottle with cap, needle or small drill, lighter/heat source',
      'tips': 'Smaller holes = gentler spray. Make two versions - one for delicate seedlings, one for established plants.',
    },
  ];

  final List<Map<String, dynamic>> tutorialVideos = [
    {
      'title': 'How to Reduce Plastic Usage',
      'description': 'Practical tips and daily habits to minimize plastic consumption',
      'icon': Icons.play_circle_filled,
      
      'url': 'https://www.youtube.com/watch?v=W1wmSJsxk3w',
      'category': 'videos',
      'color': [const Color(0xFFef4444), const Color(0xFFdc2626)],
    },
    {
      'title': 'DIY Plastic Bottle Crafts',
      'description': 'Creative ways to reuse plastic bottles for home decoration',
      'icon': Icons.play_circle_filled,
      

      'url': 'https://www.youtube.com/watch?v=E19QrSIWfQU',
      'category': 'videos',
      'color': [const Color(0xFF8b5cf6), const Color(0xFF7c3aed)],
    },
    {
      'title': 'Plastic Recycling Process',
      'description': 'Behind the scenes: How plastic gets recycled in facilities',
      'icon': Icons.play_circle_filled,
     
      'url': 'https://www.youtube.com/watch?v=cNPEH0GOhRw',
      'category': 'videos',
      'color': [const Color(0xFF3b82f6), const Color(0xFF2563eb)],
    },
    {
      'title': 'Ocean Plastic Documentary',
      'description': 'The impact of plastic pollution on marine life and ecosystems',
      'icon': Icons.play_circle_filled,
      
      
      'url': 'https://www.youtube.com/watch?v=Yomf5pBN8dY',
      'category': 'videos',
      'color': [const Color(0xFF06b6d4), const Color(0xFF0891b2)],
    },
  ];

  final List<Map<String, dynamic>> externalLinks = [
    {
      'title': 'UN Environment – Beat Plastic Pollution',
      'url': 'https://www.unep.org/beat-plastic-pollution',
      'description': 'Global initiative to end plastic pollution',
      'icon': Icons.public,
      'category': 'links',
      'color': [const Color(0xFF3b82f6), const Color(0xFF2563eb)],
    },
    {
      'title': 'WWF Plastic Smart Cities',
      'url': 'https://www.wwf.org.uk/plastic',
      'description': 'Creating cities free from plastic pollution',
      'icon': Icons.location_city,
      'category': 'links',
      'color': [const Color(0xFF10b981), const Color(0xFF059669)],
    },
    {
      'title': 'India\'s MoEFCC Guidelines',
      'url': 'https://moef.gov.in',
      'description': 'Official plastic waste management guidelines',
      'icon': Icons.policy,
      'category': 'links',
      'color': [const Color(0xFFf59e0b), const Color(0xFFd97706)],
    },
    {
      'title': 'Recycling Education',
      'url': 'https://www.recyclenow.com',
      'description': 'Learn proper recycling techniques',
      'icon': Icons.recycling,
      'category': 'links',
      'color': [const Color(0xFF8b5cf6), const Color(0xFF7c3aed)],
    },
  ];

  List<dynamic> get filteredItems {
    List<dynamic> allItems = [
      ...educationalArticles,
      ...alternatives,
      ...diyIdeas,
      ...tutorialVideos,
      ...externalLinks,
    ];

    if (selectedCategory == 'all') return allItems;
    return allItems.where((item) => item['category'] == selectedCategory).toList();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

 

  void _handleItemTap(Map<String, dynamic> item) {
    if (item['url'] != null) {
      _launchURL(item['url']);
    } else if (item['action'] == 'article') {
      _showArticleDialog(item);
    } else if (item['action'] == 'detail') {
      _showDetailDialog(item);
    } else if (item['action'] == 'tutorial') {
      _showTutorialDialog(item);
    }
  }

  void _showArticleDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          decoration: BoxDecoration(
            color: const Color(0xFF065f46),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF10b981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: List<Color>.from(item['color']),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(item['icon'], size: 40, color: Colors.white),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    item['fullContent'] ?? item['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFd1d5db),
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF065f46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF10b981)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item['icon'],
                style: const TextStyle(fontSize: 60),
              ),
              const SizedBox(height: 16),
              Text(
                item['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF047857).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cost:', style: TextStyle(color: Color(0xFFd1d5db))),
                        Text(
                          item['cost'],
                          style: const TextStyle(
                            color: Color(0xFF10b981),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.eco, size: 16, color: Color(0xFF10b981)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item['impact'],
                            style: const TextStyle(fontSize: 13, color: Color(0xFFd1d5db)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10b981),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTutorialDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          decoration: BoxDecoration(
            color: const Color(0xFF065f46),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF10b981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: List<Color>.from(item['color']),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      item['icon'],
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item['difficulty'],
                                  style: const TextStyle(fontSize: 11, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.timer, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                item['time'],
                                style: const TextStyle(fontSize: 11, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFd1d5db),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF047857).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF10b981).withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.shopping_bag, size: 16, color: Color(0xFF10b981)),
                                SizedBox(width: 8),
                                Text(
                                  'Materials Needed:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF10b981),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['materials'] ?? 'Basic craft supplies',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFd1d5db),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Step-by-Step Guide:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        (item['steps'] as List<String>?)?.length ?? 0,
                        (index) {
                          final steps = item['steps'] as List<String>;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: List<Color>.from(item['color']),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    steps[index],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFd1d5db),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (item['tips'] != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10b981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF10b981).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                size: 20,
                                color: Color(0xFF10b981),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Pro Tips:',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF10b981),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['tips'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFd1d5db),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF022c22), Color(0xFF065f46), Color(0xFF134e4a)],
              ),
            ),
          ),
          ...List.generate(25, (i) => _buildFloatingParticle(i)),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      _buildHeroSection(),
                      _buildCategoryFilter(),
                      _buildResourcesGrid(),
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

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              const SizedBox(width: 12),
              const Text(
                'Resources',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
  children: [
    _buildNavButton(context, 'Back to Home', Icons.arrow_back),
  ],
),
        ],
      ),
    );
  }

 Widget _buildNavButton(
  BuildContext context,
  String label,
  IconData icon, [
  VoidCallback? onTap,
]) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap ??
            () {
              if (label == 'Back to Home') {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 700),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 500),
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            const Dashboard(),
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
                            begin: const Offset(0, 0.1),
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
        borderRadius: BorderRadius.circular(25),
        splashColor: Colors.white24,
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF065f46).withOpacity(0.6),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color(0xFF10b981).withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}



 

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
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
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10b981), Color(0xFF047857), Color(0xFF0d9488)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10b981).withOpacity(0.5),
                          blurRadius: 50,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.library_books, size: 70, color: Colors.white),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF86efac), Color(0xFF10b981), Color(0xFF5eead4)],
            ).createShader(bounds),
            child: const Text(
              'Learning Resources &\nTools',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Discover educational content, eco-friendly alternatives, DIY tutorials, videos, and more to help you reduce plastic waste',
              style: TextStyle(fontSize: 16, color: Color(0xFFd1d5db), height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF065f46).withOpacity(0.4),
                  const Color(0xFF047857).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF10b981).withOpacity(0.5)),
            ),
            child: const Text(
              '📚 Articles | 🌱 Alternatives | 🎨 DIY Projects | 🎥 Video Tutorials',
              style: TextStyle(color: Color(0xFFd1d5db), fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF065f46).withOpacity(0.4),
              const Color(0xFF047857).withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF10b981).withOpacity(0.5)),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: categories.map((cat) {
            final active = selectedCategory == cat['id'];
            return GestureDetector(
              onTap: () => setState(() => selectedCategory = cat['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: active
                      ? const LinearGradient(colors: [Color(0xFF10b981), Color(0xFF047857)])
                      : null,
                  color: active ? null : const Color(0xFF065f46).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: active ? null : Border.all(color: const Color(0xFF10b981).withOpacity(0.3)),
                  boxShadow: active
                      ? [BoxShadow(color: const Color(0xFF10b981).withOpacity(0.3), blurRadius: 8)]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      size: 16,
                      color: active ? Colors.white : const Color(0xFFd1d5db),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat['name'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: active ? Colors.white : const Color(0xFFd1d5db),
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

  Widget _buildResourcesGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        children: filteredItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final opacity = scrollY > 200 + index * 50 ? 1.0 : 0.3;

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: opacity,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF065f46).withOpacity(0.4),
                    const Color(0xFF047857).withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF10b981).withOpacity(0.5)),
              ),
              child: InkWell(
                onTap: () => _handleItemTap(item),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: List<Color>.from(item['color'])),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: item['icon'] is IconData
                              ? Icon(item['icon'], size: 30, color: Colors.white)
                              : Text(
                                  item['icon'] as String,
                                  style: const TextStyle(fontSize: 30),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (item['description'] != null)
                              Text(
                                item['description'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFd1d5db),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (item['cost'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${item['cost']} • ${item['impact']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF10b981),
                                  ),
                                ),
                              ),
                            if (item['duration'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${item['duration']} • ${item['views']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF10b981),
                                  ),
                                ),
                              ),
                            if (item['difficulty'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${item['difficulty']} • ${item['time']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF10b981),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        item['url'] != null ? Icons.open_in_new : Icons.arrow_forward_ios,
                        size: 20,
                        color: const Color(0xFF10b981),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFF10b981).withOpacity(0.3)),
        ),
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco, color: Color(0xFF10b981), size: 20),
              SizedBox(width: 8),
              Text(
                'Plastic Awareness',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Learn, Act, and Make a Difference',
            style: TextStyle(color: Color(0xFF9ca3af), fontSize: 12),
          ),
          SizedBox(height: 4),
          Text(
            '© 2025 Plastic Awareness Initiative',
            style: TextStyle(color: Color(0xFF6b7280), fontSize: 11),
          ),
        ],
      ),
    );
  }
}