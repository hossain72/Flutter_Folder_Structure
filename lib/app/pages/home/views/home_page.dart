import 'package:flutter/material.dart';
import 'package:flutter_project/app/common_widgets/text_widget.dart';
import 'package:flutter_project/app/core/resources/strings/app_strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(title: TextWidget(text: AppString.animation)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
