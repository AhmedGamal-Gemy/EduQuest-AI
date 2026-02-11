import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/theme/app_colors.dart';
import 'package:eduquest_ai/dependency_injection.dart';
import 'package:eduquest_ai/features/course/logic/course_cubit.dart';
import 'package:eduquest_ai/features/course/ui/instructor_course_page.dart';
import 'package:eduquest_ai/features/course/ui/student_course_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class AppNavigationBar extends StatefulWidget {
  final Role role;
  const AppNavigationBar({super.key, required this.role});

  @override
  State<AppNavigationBar> createState() => _AppNavigationBar();
}

class _AppNavigationBar extends State<AppNavigationBar> {
  int _currentIndex = 0;

  late final List<Widget> _pages;
  late final List<CrystalNavigationBarItem> _items;

  @override
  void initState() {
    super.initState();
    _setupNavigation();
  }

  void _setupNavigation() {
    // final uid = context.read<AuthCubit>().user.uid;

    switch (widget.role) {
      case Role.instructor:
        _pages = [
          // BlocProvider(create: (_) => HomeCubit(HomeServicesImpl()), child: const HomePage()),
          // BlocProvider(create: (_) => CartCubit(CartServicesImpl(uid))..fetchCartItems(), child: const CartPage()),
          BlocProvider(
            create: (_) => getIt<CourseCubit>()..fetchCourses(),
            child: const InstructorCoursePage(),
          ),
          // Text("Course"),
          // InstructorCoursePage(),
          Text("Course"),
          Text("Course"),
        ];

        _items = [
          CrystalNavigationBarItem(icon: IconlyLight.home, unselectedIcon: IconlyBold.home),
          CrystalNavigationBarItem(icon: IconlyLight.document, unselectedIcon: IconlyBold.document),
          CrystalNavigationBarItem(icon: IconlyLight.chat, unselectedIcon: IconlyBold.chat),
        ];
        break;

      case Role.student:
        _pages = [
          // BlocProvider(
          //   create: (_) => OrderCubit(OrderServicesImpl(uid))..fetchOrders(),
          //   child: BlocBuilder<OrderCubit, OrderState>(
          //     builder: (context, state) {
          //       if (state is OrderFetchLoading) {
          //         return const Center(child: CircularProgressIndicator());
          //       } else if (state is OrderFetched) {
          //         return StatisticsPage(orders: state.orders);
          //       } else if (state is OrderFetchedError) {
          //         return Center(child: Text(state.message));
          //       }
          //       return const SizedBox.shrink();
          //     },
          //   ),
          // ),
          // BlocProvider(create: (_) => HomeCubit(HomeServicesImpl()), child: const HomePage()),
          // BlocProvider(create: (_) => OrderCubit(OrderServicesImpl(uid)), child: const OrderPage()),
          // BlocProvider(create: (_) => OrderCubit(OrderServicesImpl(uid))..fetchOrders(), child: const StatisticsPage(orders: ),),
          // Text("Course"),
           BlocProvider(
            create: (_) => getIt<CourseCubit>()..fetchCourses(),
            child: const StudentCoursePage(),
          ),
          Text("Course"),
          Text("chat"), // flutter_ai_toolkit: ^1.0.0
        ];

        _items = [
          CrystalNavigationBarItem(icon: IconlyLight.home, unselectedIcon: IconlyBold.home),
          CrystalNavigationBarItem(icon: IconlyLight.document, unselectedIcon: IconlyBold.document),
          CrystalNavigationBarItem(icon: IconlyLight.chat, unselectedIcon: IconlyBold.chat),
          // activity | trendingUp | chart
        ];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: CrystalNavigationBar(
        height: Constants.heightNav,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        // Todo.................
        backgroundColor: AppColors.navyBlue,
        selectedItemColor: AppColors.purple,
        unselectedItemColor: AppColors.whiteSoft,
        indicatorColor: AppColors.purple,
        outlineBorderColor: AppColors.grayBlue,
        borderWidth: 2,
        items: _items,
      ),
    );
  }
}
