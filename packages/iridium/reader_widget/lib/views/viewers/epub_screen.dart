import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:dfunc/dfunc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iridium_reader_widget/util/color_extention.dart';
import 'package:iridium_reader_widget/views/viewers/book_screen.dart';
import 'package:iridium_reader_widget/views/viewers/model/fonts.dart';
import 'package:mno_commons/utils/functions.dart';
import 'package:mno_navigator/epub.dart';
import 'package:mno_navigator/publication.dart';
import 'package:mno_server/mno_server.dart';
import 'package:mno_shared/mediatype.dart';
import 'package:mno_shared/publication.dart';
import 'package:mno_streamer/parser.dart';

class EpubScreen extends BookScreen {
  final String? location;
  final int? settings;
  final Map<String, dynamic>? theme;

  const EpubScreen(
      {super.key,
      required super.asset,
      super.readerAnnotationRepository,
      super.paginationCallback,
      this.location,
      this.settings,
      this.theme});

  factory EpubScreen.fromPath(
      {Key? key,
      required String filePath,
      ReaderAnnotationRepository? readerAnnotationRepository,
      PaginationCallback? paginationCallback,
      String? location,
      String? settings,
      String? theme}) {
    Map<String, dynamic>? decodedTheme;
    try {
      decodedTheme = json.decode(theme!);
    } catch (e) {
      debugPrint('failure to decode theme: $e');
    }
    return EpubScreen(
      key: key,
      asset: FileAsset(File(filePath)),
      readerAnnotationRepository: readerAnnotationRepository,
      paginationCallback: paginationCallback,
      location: location,
      settings: int.tryParse(settings ?? '100'),
      theme: decodedTheme,
    );
  }

  factory EpubScreen.fromFile(
      {Key? key,
      required File file,
      ReaderAnnotationRepository? readerAnnotationRepository,
      PaginationCallback? paginationCallback,
      String? location,
      String? settings,
      String? theme}) {
    Map<String, dynamic>? decodedTheme;
    try {
      decodedTheme = json.decode(theme!);
    } catch (e) {
      debugPrint('failure to decode theme: $e');
    }
    return EpubScreen(
      key: key,
      asset: FileAsset(file),
      readerAnnotationRepository: readerAnnotationRepository,
      paginationCallback: paginationCallback,
      location: location,
      settings: int.tryParse(settings ?? '100'),
      theme: decodedTheme,
    );
  }

  factory EpubScreen.fromUri(
      {Key? key,
      required String rootHref,
      ReaderAnnotationRepository? readerAnnotationRepository,
      PaginationCallback? paginationCallback,
      MediaType? mimeType,
      String? location,
      String? settings,
      String? theme}) {
    Map<String, dynamic>? decodedTheme;
    try {
      decodedTheme = json.decode(theme!);
    } catch (e) {
      debugPrint('failure to decode theme: $e');
    }
    return EpubScreen(
      key: key,
      asset: HttpAsset(rootHref, knownMediaType: mimeType),
      readerAnnotationRepository: readerAnnotationRepository,
      paginationCallback: paginationCallback,
      location: location,
      settings: int.tryParse(settings ?? '100'),
      theme: decodedTheme,
    );
  }

  @override
  State<StatefulWidget> createState() => EpubScreenState();
}

class EpubScreenState extends BookScreenState<EpubScreen, EpubController> {
  late ViewerSettingsBloc _viewerSettingsBloc;
  late ReaderThemeBloc _readerThemeBloc;
  int _currentPageNumber = 1;

  @override
  void initState() {
    super.initState();
    _viewerSettingsBloc =
        ViewerSettingsBloc(EpubReaderState("", widget.settings ?? 100));
    debugPrint(widget.theme.toString());
    _readerThemeBloc = ReaderThemeBloc(widget.theme != null
        ? ReaderThemeConfig.fromJson(widget.theme!)
        : ReaderThemeConfig.defaultTheme);

  }

  @override
  void onReaderContextCreated(ReaderContext readerContext) {
    super.onReaderContextCreated(readerContext);

    // Subscribe to the currentLocationStream for pagination info updates.
    readerContext.currentLocationStream.listen((paginationInfo) {
      // Since PaginationInfo itself might not directly tell you the "page number",
      // you'll need to interpret it based on your pagination logic.
      // This might involve looking at the current spine item and its position within the pagination structure.

      // As an example, let's say you have a method to calculate the current page number from paginationInfo.
      int newPageNumber =  paginationInfo.page;

      setState(() {
        _currentPageNumber = newPageNumber;
      });
    });
  }


  void goToPreviousPage() {
    // This is a simplified example. Your actual implementation may vary.
    // It might involve calculating the current page, finding the previous page, and then using
    // ReaderContext's execute method to navigate.
    setState(() {
      if (_currentPageNumber > 1) {
        var previousPage = _currentPageNumber - 1; // Calculate the previous page number
        readerContext.execute(GoToPageCommand(previousPage));
      }
    });
  }

// This is a placeholder for your logic to calculate the current page number based on PaginationInfo.

  @override
  Future<bool> onWillPop() async {
    try {
      readerContext.paginationInfo?.let((paginationInfo) =>
          readerAnnotationRepository.savePosition(paginationInfo));
      Navigator.pop(context, {
        'locator': readerContext.paginationInfo?.locator.json,
        'settings': _viewerSettingsBloc.viewerSettings.fontSize.toString(),
        'theme': json.encode(_readerThemeBloc.currentTheme.toJson()),
      });
    } catch (e) {
      // perhaps a snackbar notification can be added to indicate that there was a problem saving last location and settings
      debugPrint('error returning location and settings');
    }
    return true;
  }

  @override
  Future<String?> get openLocation async {
    if (widget.location != null) {
      return widget.location;
    }
    return readerAnnotationRepository
        .getPosition()
        .then((position) => position?.location);
  }

  SelectionListenerFactory get selectionListenerFactory =>
      SimpleSelectionListenerFactory(this);

  @override
  EpubController createPublicationController(
          Function onServerClosed,
          Function? onPageJump,
          Future<String?> locationFuture,
          PublicationAsset fileAsset,
          Future<Streamer> streamerFuture,
          ReaderAnnotationRepository readerAnnotationRepository,
          Function0<List<RequestHandler>> handlersProvider) =>
      EpubController(
          onServerClosed,
          onPageJump,
          locationFuture,
          fileAsset,
          streamerFuture,
          readerAnnotationRepository,
          handlersProvider,
          selectionListenerFactory);

  @override
  Widget createPublicationNavigator({
    required WidgetBuilder waitingScreenBuilder,
    required WidgetErrorBuilder displayErrorBuilder,
    required Consumer<ReaderContext> onReaderContextCreated,
    required WrapperWidgetBuilder wrapper,
    required EpubController publicationController,
  }) =>
      EpubNavigator(
          waitingScreenBuilder: waitingScreenBuilder,
          displayErrorBuilder: displayErrorBuilder,
          onReaderContextCreated: onReaderContextCreated,
          wrapper: wrapper,
          epubController: publicationController);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => _viewerSettingsBloc),
          BlocProvider(create: (context) => _readerThemeBloc),
        ],
        child: Scaffold(
            body: Stack(
              children: [
                super.build(context),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // GestureDetector or IconButton for previous page navigation
                      GestureDetector(
                        onTap: () {
                          goToPreviousPage();
                        },
                        child: Icon(Icons.arrow_back, color: '#FB0101'.toColor(),),
                      ),
                      SizedBox(width: 8),
                      // Assuming state has a property to get the current page number
                      // Display the current page number here
                      Text(_currentPageNumber.toString(), style: TextStyle(color: Colors.black),), // Placeholder, replace with actual page number
                      SizedBox(width: 8),
                      // GestureDetector or IconButton for next page navigation
                      GestureDetector(
                        onTap: () {
                          // Implement your logic to navigate to the next page
                          // This might involve calling a method on your EpubController
                        },
                        child: Icon(Icons.arrow_forward, color: '#FB0101'.toColor()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
      );

  @override
  Widget buildBackground() => BlocBuilder(
        bloc: _readerThemeBloc,
        builder: (BuildContext context, ReaderThemeState state) => Container(
          color: state.readerTheme.backgroundColor,
        ),
      );

  @override
  Function0<List<RequestHandler>> get handlersProvider => () => [
        AssetsRequestHandler(
          'packages/mno_navigator/assets',
          assetProvider: _AssetProvider(),
        ),
        FetcherRequestHandler(
            readerContext.publication!, () => readerContext.viewportWidth,
            googleFonts: Fonts.googleFonts)
      ];
}

class _AssetProvider implements AssetProvider {
  @override
  Future<ByteData> load(String path) => rootBundle.load(path);
}
