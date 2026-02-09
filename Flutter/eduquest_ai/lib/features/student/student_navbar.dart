import 'package:eduquest_ai/core/common/widgets/app_glass_card.dart';
import 'package:flutter/material.dart';

class StudentNavbar extends StatelessWidget {
  const StudentNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF8F2F7),
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   title: Row(
      //     children: [
      //       const CircleAvatar(
      //         radius: 16,
      //         backgroundColor: Color(0xFF8A2EFF),
      //         child: Icon(Icons.auto_awesome, color: Colors.white, size: 18),
      //       ),
      //       const SizedBox(width: 8),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: const [
      //           Text(
      //             'EduAI Assistant',
      //             style: TextStyle(
      //               fontSize: 14,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.black,
      //             ),
      //           ),
      //           Text(
      //             'Student Dashboard',
      //             style: TextStyle(fontSize: 11, color: Colors.grey),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     _Badge(label: 'Student'),
      //     const SizedBox(width: 6),
      //     _Badge(label: 'Level 1', icon: Icons.emoji_events),
      //     const SizedBox(width: 6),
      //     TextButton.icon(
      //       onPressed: () {},
      //       icon: const Icon(Icons.logout, size: 18),
      //       label: const Text('Sign Out'),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _LevelCard(),
            const SizedBox(height: 16),

            _StatCard(
              title: 'Enrolled Courses',
              value: '0',
              icon: Icons.menu_book,
              iconColor: Colors.purple,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'Live Now',
              value: '0',
              icon: Icons.wifi_tethering,
              iconColor: Colors.green,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'XP This Week',
              value: '0',
              icon: Icons.trending_up,
              iconColor: Colors.pink,
            ),
            const SizedBox(height: 24),

            /// My Courses Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Courses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Your enrolled courses and live sessions',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  label: const Text('Join Course'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A2EFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Empty State
            AppGlassCard(
              child: Column(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No courses enrolled',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Join a course to start learning with AI-powered support',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                      label: const Text('Join Your First Course'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A2EFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8A2EFF), Color(0xFFE91E63)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.white),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '0 XP earned',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '0%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const LinearProgressIndicator(
            value: 0,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Earn XP by asking questions and engaging in live sessions',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(
            icon,
            // color: iconColor,
            color: Theme.of(context).colorScheme.primary,

            size: 28,
          ),
        ],
      ),
    );
  }
}
