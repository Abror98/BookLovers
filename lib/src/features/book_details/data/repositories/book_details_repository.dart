import 'package:openlib/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookDetailsRepository extends BookRepository {
  BookDetailsRepository(super.httpClient);

  Future<BookRepositoryData> getRelatedFeed(String url) {
    final String stripedUrl = url.replaceAll(baseURL, '');
    final successOrFailure = getCategory(stripedUrl);
    return successOrFailure;
  }
}

final bookDetailsRepositoryProvider =
    Provider.autoDispose<BookDetailsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return BookDetailsRepository(dio);
});
