// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_feed_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genreFeedNotifierHash() => r'64ded0ad63eb41c4f7fd6702d3fafa19e6bde301';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$GenreFeedNotifier
    extends BuildlessAutoDisposeAsyncNotifier<GenreFeedData> {
  late final String url;

  FutureOr<GenreFeedData> build(
    String url,
  );
}

/// See also [GenreFeedNotifier].
@ProviderFor(GenreFeedNotifier)
const genreFeedNotifierProvider = GenreFeedNotifierFamily();

/// See also [GenreFeedNotifier].
class GenreFeedNotifierFamily extends Family<AsyncValue<GenreFeedData>> {
  /// See also [GenreFeedNotifier].
  const GenreFeedNotifierFamily();

  /// See also [GenreFeedNotifier].
  GenreFeedNotifierProvider call(
    String url,
  ) {
    return GenreFeedNotifierProvider(
      url,
    );
  }

  @override
  GenreFeedNotifierProvider getProviderOverride(
    covariant GenreFeedNotifierProvider provider,
  ) {
    return call(
      provider.url,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'genreFeedNotifierProvider';
}

/// See also [GenreFeedNotifier].
class GenreFeedNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    GenreFeedNotifier, GenreFeedData> {
  /// See also [GenreFeedNotifier].
  GenreFeedNotifierProvider(
    String url,
  ) : this._internal(
          () => GenreFeedNotifier()..url = url,
          from: genreFeedNotifierProvider,
          name: r'genreFeedNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genreFeedNotifierHash,
          dependencies: GenreFeedNotifierFamily._dependencies,
          allTransitiveDependencies:
              GenreFeedNotifierFamily._allTransitiveDependencies,
          url: url,
        );

  GenreFeedNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  FutureOr<GenreFeedData> runNotifierBuild(
    covariant GenreFeedNotifier notifier,
  ) {
    return notifier.build(
      url,
    );
  }

  @override
  Override overrideWith(GenreFeedNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: GenreFeedNotifierProvider._internal(
        () => create()..url = url,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GenreFeedNotifier, GenreFeedData>
      createElement() {
    return _GenreFeedNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenreFeedNotifierProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GenreFeedNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<GenreFeedData> {
  /// The parameter `url` of this provider.
  String get url;
}

class _GenreFeedNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GenreFeedNotifier,
        GenreFeedData> with GenreFeedNotifierRef {
  _GenreFeedNotifierProviderElement(super.provider);

  @override
  String get url => (origin as GenreFeedNotifierProvider).url;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
