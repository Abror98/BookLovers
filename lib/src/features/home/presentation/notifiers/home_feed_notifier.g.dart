// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_feed_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeFeedNotifierHash() => r'5daa399a59b2e3bb9062b2b786210296ecd21452';

/// See also [HomeFeedNotifier].
@ProviderFor(HomeFeedNotifier)
final homeFeedNotifierProvider = AutoDisposeAsyncNotifierProvider<
    HomeFeedNotifier,
    ({CategoryFeed popularFeed, CategoryFeed recentFeed})>.internal(
  HomeFeedNotifier.new,
  name: r'homeFeedNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeFeedNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeFeedNotifier = AutoDisposeAsyncNotifier<
    ({CategoryFeed popularFeed, CategoryFeed recentFeed})>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
