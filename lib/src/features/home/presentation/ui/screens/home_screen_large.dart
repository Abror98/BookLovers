import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:openlib/src/common/common.dart';
import 'package:openlib/src/features/features.dart';

class HomeScreenLarge extends StatelessWidget {
  const HomeScreenLarge({super.key});

  @override
  Widget build(BuildContext context) {
    final isNestedEmpty = context.watchRouter.topRoute.name == 'HomeRoute';

    return AnimatedPageSplitter(
      isExpanded: !isNestedEmpty,
      leftChild: const HomeScreenSmall(),
      rightChild: const AutoRouter(),
    );
  }
}
