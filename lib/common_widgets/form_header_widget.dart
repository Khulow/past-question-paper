import 'package:flutter/material.dart';
import 'package:past_question_paper/utils/theme/widget_themes/text_themes.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.size});

  final String image, title, subTitle;

  final Size size;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: AssetImage(image),
            height: size.height * 0.1,
          ),
          Text(
            title,
            style: TTextTheme.lightTextTheme.titleSmall,
          ),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
