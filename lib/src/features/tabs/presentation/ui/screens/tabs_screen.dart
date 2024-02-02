import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:openlib/src/common/common.dart';
import 'package:openlib/src/debug_page.dart';
import 'package:openlib/src/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logman/logman.dart';

@RoutePage()
class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Logman.instance.attachOverlay(
    //     context: context,
    //     debugPage: const DebugPage(),
    //     button: FloatingActionButton(
    //       elevation: 0,
    //       onPressed: () {},
    //       backgroundColor: context.theme.accentColor,
    //       child: const Icon(
    //         Icons.bug_report,
    //         color: Colors.white,
    //       ),
    //     ),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    // watch providers so they don't get disposed
    ref.watch(homeFeedNotifierProvider);

    return PopScope(
      onPopInvoked: (_) async {
        ExitModalDialog.show(context: context);
      },
      child: const ResponsiveWidget(
        smallScreen: TabsScreenSmall(),
        largeScreen: TabsScreenLarge(),
      ),
    );
  }
}
