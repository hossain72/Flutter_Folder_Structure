import 'package:flutter/material.dart';
import 'package:flutter_project/app/core/resources/images/app_images.dart';
import 'package:flutter_project/app/pages/splash/providers/splash_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Consumer<SplashProvider>(
      builder: (context, provider, child) {
        return Container(
          width: width,
          height: height,
          color: Colors.white,
          child: Center(child: SvgPicture.asset(AppImages.appIcon)),
        );
      },
    );
  }
}
