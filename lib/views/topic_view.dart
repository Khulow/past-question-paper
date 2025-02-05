import 'package:flutter/material.dart';
import 'package:past_question_paper/views/question_view.dart';
import 'package:past_question_paper/views/quiz_instruction.dart';
import 'package:provider/provider.dart';
import 'package:past_question_paper/viewmodels/topic_viewmodel.dart';

class TopicsScreen extends StatefulWidget {
  final String subjectId;

  const TopicsScreen({
    super.key,
    required this.subjectId,
  });

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  // We'll use this to control when we load the topics
  bool _isFirstLoad = true;

  @override
  Widget build(BuildContext context) {
    // Load topics only on first build
    if (_isFirstLoad) {
      _isFirstLoad = false;
      // Use a post-frame callback to avoid build-phase issues
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<TopicViewModel>(context, listen: false)
            .fetchTopics(widget.subjectId);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<TopicViewModel>(
        builder: (context, viewModel, child) {
          // Show loading indicator
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show empty state
          if (viewModel.topics.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No topics available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show topics list
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.topics.length,
            itemBuilder: (context, index) {
              final topic = viewModel.topics[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    topic.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  onTap: () {
                    // Handle topic selection
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizInstructionScreen(
                          subjectId: widget.subjectId,
                          topicId: topic.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Use a post-frame callback to safely clear topics
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<TopicViewModel>(context, listen: false).clearTopics();
      }
    });
    super.dispose();
  }
}
