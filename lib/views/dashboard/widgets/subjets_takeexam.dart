import 'package:flutter/material.dart';

class SubjectSectionExam extends StatelessWidget {
  const SubjectSectionExam({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'TAKE EXAM',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
          Text(
            "View All",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
        ],
      ),
    );
  }
}
