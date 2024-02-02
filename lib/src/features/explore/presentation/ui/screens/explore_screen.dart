import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:openlib/src/common/common.dart';
import 'package:openlib/src/features/features.dart';

@RoutePage()
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveWidget(
      smallScreen: ExploreScreenSmall(),
      largeScreen: ExploreScreenLarge(),
    );
  }
}
