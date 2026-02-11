import 'package:eduquest_ai/core/common/widgets/app_field.dart';
import 'package:eduquest_ai/core/common/widgets/app_glass_card.dart';
import 'package:eduquest_ai/core/helper/shared_pref_helper.dart';
import 'package:eduquest_ai/core/networking/api_constants.dart';
import 'package:eduquest_ai/core/theme/app_colors.dart';
import 'package:eduquest_ai/features/course/data/models/course_request_body.dart';
import 'package:eduquest_ai/features/course/data/models/course_response.dart';
import 'package:eduquest_ai/features/course/logic/course_cubit.dart';
import 'package:eduquest_ai/features/course/logic/course_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructorCoursePage extends StatelessWidget {
  const InstructorCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseCubit = BlocProvider.of<CourseCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF8A2EFF),
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
                    // color: Colors.black,
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
          // _Badge(label: 'Student'),
          const SizedBox(width: 6),
          // _Badge(label: 'Level 1', icon: Icons.emoji_events),
          const SizedBox(width: 6),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Sign Out'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _percentageCards(courseCubit),
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
                  onPressed: () {
                    final parentContext = context;
                    showModalBottomSheet(
                      context: parentContext,
                      // backgroundColor: AppColors.whiteSoft,
                      isDismissible: true,
                      enableDrag: true,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (context) {
                        return BlocProvider<CourseCubit>.value(
                          value: parentContext.read<CourseCubit>(),
                          child: CreatingCourseBottomSheet(),
                        );
                      },
                    );
                  },
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
            CoursesGridBlocBuilder(),
            const SizedBox(height: 12),

          ],
        ),
      ),
    );
  }

  Widget _percentageCards(CourseCubit courseCubit) {
    return Column(
      children: [
        BlocBuilder<CourseCubit, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading) {
              return const _StatCard(
                title: 'Total Courses',
                value: '...',
                icon: Icons.menu_book,
                iconColor: Colors.blue,
              );
            }

            if (state is CourseListLoaded) {
              return GestureDetector(
                onTap: () async {
                  final token = await SharedPrefHelper.getString(
                    SharedPrefKeys.userToken,
                  );
                  debugPrint("Token: $token");
                },
                child: _StatCard(
                  title: 'Total Courses',
                  value: state.courses.length.toString(),
                  icon: Icons.menu_book,
                  iconColor: Colors.blue,
                ),
              );
            }

            return const _StatCard(
              title: 'Total Courses',
              value: '0',
              icon: Icons.menu_book,
              iconColor: Colors.blue,
            );
          },
        ),
        const SizedBox(height: 12),
        BlocBuilder<CourseCubit, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading) {
              return const _StatCard(
                title: 'Active Students',
                value: '...',
                icon: Icons.people,
                iconColor: Colors.blue,
              );
            }

            if (state is CourseListLoaded) {
              return GestureDetector(
                onTap: () async {
                  final token = await SharedPrefHelper.getString(
                    SharedPrefKeys.userToken,
                  );
                  debugPrint("Token: $token");
                },
                child: _StatCard(
                  title: 'Active Students',
                  value: state.courses[0].studentIds.length.toString(),
                  icon: Icons.people,
                  iconColor: Colors.blue,
                ),
              );
            }

            return const _StatCard(
              title: 'Active Students',
              value: '0',
              icon: Icons.people,
              iconColor: Colors.blue,
            );
          },
        ),

        // _StatCard(
        //   title: 'Active Students',
        //   value: ,
        //   icon: Icons.people,
        //   iconColor: Colors.purple,
        // ),
        const SizedBox(height: 12),
        _StatCard(
          title: 'Live Sessions',
          value: '0',
          icon: Icons.wifi_tethering,
          iconColor: Colors.green,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class CourseCardWidget extends StatelessWidget {
  const CourseCardWidget({
    super.key,
    required this.course,
    this.isStudent = false,
  });
  final CourseResponse course;
  final bool isStudent;

  @override
  Widget build(BuildContext context) {
    final courseCubit = BlocProvider.of<CourseCubit>(context);

    return AppGlassCard(
      //! BoxShadow
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Course Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                "assets/images/course.png",
                fit: BoxFit.cover,
              ),
            ),

            /// Course Info
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: Text(
                  course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  course.description ?? "No description",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(course.level),
                  ),
                ),
                isStudent
                    ? BlocConsumer<CourseCubit, CourseState>(
                        listener: (context, state) async {
                          if (state is CourseActionSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Course Join successfully'),
                              ),
                            );
                            context.read<CourseCubit>().fetchCourses();
                          }

                          if (state is CourseFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          final isEnrolling = state is CourseLoading;

                          return InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: isEnrolling
                                ? null
                                : () {
                                    context.read<CourseCubit>().enrollInCourse(course.id);
                                  },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: isEnrolling
                                  ? const SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.join_full,
                                      size: 14,
                                    ),
                            ),
                          );
                        },
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /// ✏️ EDIT BUTTON
                          InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              final parentContext = context;

                              showModalBottomSheet(
                                context: parentContext,
                                isDismissible: true,
                                enableDrag: true,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                builder: (context) {
                                  return BlocProvider<CourseCubit>.value(
                                    value: parentContext.read<CourseCubit>(),
                                    child: CreatingCourseBottomSheet(
                                      course: course,
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.edit,
                                size: 14,
                              ),
                            ),
                          ),

                          const SizedBox(width: 6),

                          /// 🗑 DELETE BUTTON
                          BlocConsumer<CourseCubit, CourseState>(
                            listener: (context, state) async {
                              if (state is CourseActionSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Course deleted successfully'),
                                  ),
                                );

                                context.read<CourseCubit>().fetchCourses();
                              }

                              if (state is CourseFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.error),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              final isDeleting = state is CourseLoading;
                              // && state.courseId == course.id;

                              return InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: isDeleting
                                    ? null
                                    : () {
                                        context.read<CourseCubit>().deleteCourse(course.id);
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: isDeleting
                                      ? const SizedBox(
                                          height: 14,
                                          width: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.delete,
                                          size: 14,
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                        ],
                      )
              ],
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

class CreatingCourseBottomSheet extends StatefulWidget {
  const CreatingCourseBottomSheet({
    super.key,
    this.course,
  });

  final CourseResponse? course;

  @override
  State<CreatingCourseBottomSheet> createState() => _CreatingCourseBottomSheetState();
}

class _CreatingCourseBottomSheetState extends State<CreatingCourseBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _repoURLController;

  String _selectedLevel = "beginner";

  final List<String> _levels = [
    "beginner",
    "intermediate",
    "advanced",
  ];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _repoURLController = TextEditingController();

    if (widget.course != null) {
      _titleController.text = widget.course!.title;
      _descriptionController.text = widget.course!.description ?? "";
      _repoURLController.text = widget.course!.githubRepoUrl ?? "";
      _selectedLevel = widget.course!.level ?? "beginner";
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _repoURLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),

              Text(
                widget.course != null ? "Update Course" : "Create Course",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// Title
              AppField(
                hint: "Course title",
                controller: _titleController,
                icon: Icons.title,
                validator: (v) => v == null || v.isEmpty ? 'Please enter your course title' : null,
              ),

              const SizedBox(height: 12),

              /// Description
              AppField(
                hint: "Course description",
                controller: _descriptionController,
                maxLines: 3,
                icon: Icons.description,
                validator: (v) => v == null || v.isEmpty ? 'Please enter your course description' : null,
              ),

              const SizedBox(height: 12),

              /// GitHub URL
              AppField(
                hint: "GitHub Repo URL",
                controller: _repoURLController,
                icon: Icons.link,
                validator: (v) => v == null || v.isEmpty ? 'Please enter your GitHub Repo URL' : null,
              ),

              const SizedBox(height: 16),

              /// Upload + AI Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.upload),
                      onPressed: () {
                        // TODO: Upload image logic
                      },
                      label: const Text('Upload'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.auto_awesome),
                      onPressed: () {
                        // TODO: Generate with AI logic
                      },
                      label: const Text('Generate with AI'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Level Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Course Level",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// Level Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _levels.map((level) {
                  final isSelected = _selectedLevel == level;

                  return ChoiceChip(
                    label: Text(level),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedLevel = level;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                child: BlocConsumer<CourseCubit, CourseState>(
                  listener: (context, state) async {
                    if (state is CourseActionSuccess) {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Course saved successfully'),
                        ),
                      );

                      context.read<CourseCubit>().fetchCourses();
                    }

                    if (state is CourseFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is CourseLoading;

                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final body = CourseRequestBody(
                                  title: _titleController.text.trim(),
                                  description: _descriptionController.text.trim(),
                                  githubRepoUrl: _repoURLController.text.trim(),
                                  level: _selectedLevel,
                                  isPublished: true,
                                );

                                if (widget.course != null) {
                                  await context.read<CourseCubit>().updateCourse(widget.course!.id, body);
                                } else {
                                  await context.read<CourseCubit>().createCourse(body);
                                }
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(widget.course != null ? "Update Course" : "Create Course"),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class CoursesGridBlocBuilder extends StatelessWidget {
  const CoursesGridBlocBuilder({super.key, this.isStudent = false});
  final bool isStudent;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCubit, CourseState>(
      buildWhen: (previous, current) => current is CourseLoading || current is CourseFailure || current is CourseListLoaded,
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox.shrink(),

          /// 🔄 Loading
          courseLoading: () => _courseLoadingWidget(),

          /// ❌ Failure
          courseFailure: (error) => _courseFailureWidget(error, context),

          /// ✅ Loaded
          courseListLoaded: (courses) {
            if (courses.isEmpty) {
              return _coursesEmptyWidget();
            }

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: courses.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.67,
              ),
              itemBuilder: (context, index) {
                final course = courses[index];
                return CourseCardWidget(
                  course: course,
                  isStudent: isStudent,
                );
              },
            );
          },
        );
      },
    );
  }

  AppGlassCard _coursesEmptyWidget() {
    return AppGlassCard(
      child: Column(
        children: [
          const Icon(
            Icons.menu_book_outlined,
            size: 42,
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
              onPressed: () {
                //! Navigator.pushNamed(context, Routes.createCourse);
              },
              icon: const Icon(Icons.add, color: AppColors.whiteSoft),
              label: const Text('Create Your First Course'),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _courseFailureWidget(String error, BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Center(
        child: Text(
          error,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }

  SizedBox _courseLoadingWidget() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Center(
        child: const CupertinoActivityIndicator(color: AppColors.whiteSoft),
      ),
    );
  }
}
