import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../viewmodels/subject_viewmodel.dart';
import '../models/subject.dart';
import '../views/topic_view.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({
    super.key,
  });

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubjectViewModel>(context, listen: false).fetchSubjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<SubjectViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return _buildLoadingList();
          }

          if (viewModel.subjects.isEmpty) {
            return _buildEmptyState();
          }

          return _buildSubjectsList(viewModel.subjects);
        },
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListTile(
          leading: const CircleAvatar(radius: 30),
          title: Container(height: 16, color: Colors.white),
          subtitle: Container(height: 12, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.subject, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No Subjects Available',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsList(List<Subject> subjects) {
    return ListView.separated(
      itemCount: subjects.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: subject.imageUrl.isNotEmpty
                ? NetworkImage(subject.imageUrl)
                : null,
            backgroundColor: Colors.blueAccent,
            child: subject.imageUrl.isEmpty
                ? const Icon(Icons.book, color: Colors.white)
                : null,
          ),
          title: Text(
            subject.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${subject.numberOfTopics} Topics',
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopicsScreen(subjectId: subject.id),
              ),
            );
          },
        );
      },
    );
  }
}
