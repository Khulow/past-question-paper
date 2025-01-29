import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:past_question_paper/common_widgets/sticky_header_delegate.dart';
import 'package:past_question_paper/utils/theme/widget_themes/text_themes.dart';
import 'package:past_question_paper/viewmodels/topic_viewmodel.dart';
import 'package:past_question_paper/views/topic_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ionicons/ionicons.dart';
import '../viewmodels/subject_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubjectViewModel>(context, listen: false).fetchSubjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserViewModel, SubjectViewModel>(
      builder: (context, userViewModel, subjectViewModel, child) {
        final user = userViewModel.user;

        return RefreshIndicator(
          onRefresh: () async {
            await Provider.of<SubjectViewModel>(context, listen: false)
                .fetchSubjects();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreetingHeader(user),
                      const SizedBox(height: 24),
                      Text(
                        'Your Subjects',
                        style: TTextTheme.lightTextTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: StickyHeaderDelegate(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: _buildStatsCard(user),
                  ),
                ),
              ),
              _buildSubjectsContent(subjectViewModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGreetingHeader(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user?.displayName ?? "Student"}',
              style: TTextTheme.lightTextTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            Text(
              'Let\'s continue learning!',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            Ionicons.trophy_outline,
            color: Colors.amber.shade700,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(user) {
    double accuracy = user?.overallAccuracy ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade50,
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.blue.shade50,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  value: accuracy / 100,
                  backgroundColor: Colors.blue.shade50,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue.shade700,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${accuracy.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                      height: 1,
                    ),
                  ),
                  Text(
                    'ACC',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Ionicons.trending_up_outline,
                      size: 20,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Performance Insights',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  label: 'Overall Accuracy',
                  value: '${accuracy.toStringAsFixed(0)}%',
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsContent(SubjectViewModel viewModel) {
    if (viewModel.isLoading) {
      return SliverToBoxAdapter(child: _buildLoadingList());
    }

    if (viewModel.subjects.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Ionicons.library_outline,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Subjects Available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore and add new subjects to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final subject = viewModel.subjects[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                leading: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: subject.imageUrl.isNotEmpty
                        ? SvgPicture.asset(
                            subject.imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Ionicons.book_outline,
                            color: Colors.blue.shade700,
                          ),
                  ),
                ),
                title: Text(
                  subject.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  '${subject.numberOfTopics} Topics',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Ionicons.chevron_forward_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                ),
                onTap: () {
                  Provider.of<TopicViewModel>(context, listen: false)
                      .clearTopics();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopicsScreen(subjectId: subject.id),
                    ),
                  );
                },
              ),
            );
          },
          childCount: viewModel.subjects.length,
        ),
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: const CircleAvatar(radius: 30),
            title: Container(height: 16, color: Colors.white),
            subtitle: Container(height: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
