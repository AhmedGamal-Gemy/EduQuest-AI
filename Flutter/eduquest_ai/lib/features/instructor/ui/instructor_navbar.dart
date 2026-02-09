import 'package:eduquest_ai/core/common/widgets/app_glass_card.dart';
import 'package:eduquest_ai/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class InstructorNavbar extends StatelessWidget {
  const InstructorNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF4F6FF),
      /* appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF5B5FFF),
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'EduAI Assistant',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Instructor Dashboard',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEEFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Instructor',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5B5FFF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Sign Out'),
          ),
          const SizedBox(width: 8),
        ],
      ),*/
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! Cards
            _StatCard(
              title: 'Total Courses',
              value: '0',
              icon: Icons.menu_book,
              iconColor: Colors.blue,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'Active Students',
              value: '0',
              icon: Icons.people,
              iconColor: Colors.purple,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'Live Sessions',
              value: '0',
              icon: Icons.wifi_tethering,
              iconColor: Colors.green,
            ),
            const SizedBox(height: 24),

            //! Your Courses Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Courses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: AppColors.whiteSoft),
                  label: const Text('Create Course'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: const Text(
                'Create and manage your courses with AI-powered support',
                style: TextStyle(color: AppColors.graySoft, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),

            /// Empty State Card
            AppGlassCard(
              child: Column(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    size: 48,
                    color: AppColors.graySoft,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No courses yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Create your first course to get started with AI-powered teaching',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.graySoft, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, color: AppColors.whiteSoft),
                      label: const Text('Create Your First Course'),
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
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.graySoft,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.whiteSoft,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            // iconColor,
            size: 28,
          ),
        ],
      ),
    );
  }
}
