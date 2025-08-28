import 'package:flutter/cupertino.dart';
import 'package:movie_app_valu/core/theming/colors.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(
        color: ColorsManager.primary,
        radius: 20,
      ),
    );
  }
}
