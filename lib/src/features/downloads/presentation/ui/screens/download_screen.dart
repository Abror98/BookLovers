import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:openlib/src/common/application/services/ad_banner.dart';
import 'package:openlib/src/common/common.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iridium_reader_widget/views/viewers/epub_screen.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  static const uuid = Uuid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.isSmallScreen ? null : Colors.transparent,
        centerTitle: true,
        title: const Text('Downloads'),
      ),
      body: ref.watch(downloadsNotifierProvider).maybeWhen(
            orElse: () => const EmptyView(),
            data: (books) {
              if (books.isEmpty) return const EmptyView();
              return SingleChildScrollView(
                child: SizedBox(
                  height: 1.sh,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: books.length,
                          itemBuilder: (BuildContext context, int index) {
                            if(index % 5 == 0 && index != 0){
                              return BannerAdmob();
                            }
                            final book = books[index];
                              return Dismissible(
                              key: ObjectKey(uuid.v4()),
                              direction: DismissDirection.endToStart,
                              background: const _DismissibleBackground(),
                              onDismissed: (d) {
                                ref
                                    .watch(downloadsNotifierProvider.notifier)
                                    .deleteBook(book['id'] as String);
                              },
                              child: InkWell(
                                onTap: () async {
                                  final path = book['path'] as String;
                                  final bookFile = File(path);
                                  if (bookFile.existsSync()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return EpubScreen.fromPath(filePath: path);
                                        },
                                      ),
                                    );
                                  } else {
                                    context.showSnackBarUsingText(
                                      'Could not find the book file. Please download it again.',
                                    );
                                    ref
                                        .read(downloadsNotifierProvider.notifier)
                                        .deleteBook(book['id'] as String);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 15,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        imageUrl: book['image'] as String,
                                        placeholder: (context, url) => const SizedBox(
                                          height: 70.0,
                                          width: 70.0,
                                          child: LoadingWidget(),
                                        ),
                                        errorWidget: (context, url, error) => Image.asset(
                                          'assets/images/place.png',
                                          fit: BoxFit.cover,
                                          height: 70.0,
                                          width: 70.0,
                                        ),
                                        fit: BoxFit.cover,
                                        height: 70.0,
                                        width: 70.0,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              book['name'] as String,
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'COMPLETED',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: context
                                                        .theme.colorScheme.secondary,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  book['size'] as String,
                                                  style: const TextStyle(
                                                    fontSize: 13.0,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );

                          },
                          separatorBuilder: (BuildContext context, int index) {
                            if(books.length  == index && books.length < 5){
                              return BannerAdmob();
                            }
                            return const Divider();
                          },
                        ),
                      ),
                      books.length < 5 ? BannerAdmob() : const SizedBox()
                    ],
                  ),
                ),
              );

            },
          ),
    );
  }
}

class _DismissibleBackground extends StatelessWidget {
  const _DismissibleBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: const Icon(Feather.trash_2, color: Colors.white),
    );
  }
}
