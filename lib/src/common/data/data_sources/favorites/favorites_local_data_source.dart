import 'package:openlib/src/common/common.dart';

abstract class FavoritesLocalDataSource {
  const FavoritesLocalDataSource();

  Future<void> addBook(Entry book, String id);

  Future<void> deleteBook(String id);

  Stream<List<Entry>> favoritesListStream();

  Future<void> clearBooks();
}
