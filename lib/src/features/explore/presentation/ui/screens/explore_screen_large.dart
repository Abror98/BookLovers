import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:openlib/src/common/common.dart';
import 'package:openlib/src/features/features.dart';

class ExploreScreenLarge extends StatelessWidget {
  const ExploreScreenLarge({super.key});

  @override
  Widget build(BuildContext context) {
    final isNestedEmpty = context.watchRouter.topRoute.name == 'ExploreRoute';

    return AnimatedPageSplitter(
      isExpanded: !isNestedEmpty,
      leftChild: const ExploreScreenSmall(),
      rightChild: const AutoRouter(),
    );
  }
}
