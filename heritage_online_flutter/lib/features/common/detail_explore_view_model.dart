import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/ui/components/detail_explore_section.dart';

/// 详情探索区 ViewModel — 独立加载 digest/context/blended
/// 附加区块失败不影响正文
class DetailExploreViewModel extends StateNotifier<DetailExploreState> {
  final HeritageRepository _repository;
  final String id;
  final String contentType; // 'article', 'directoryItem', 'inheritor'

  DetailExploreViewModel(
    this._repository, {
    required this.id,
    required this.contentType,
  }) : super(const DetailExploreState()) {
    _loadAll();
  }

  void _loadAll() {
    _loadDigest();
    _loadBlended();
    _loadContext();
  }

  Future<void> _loadDigest() async {
    state = DetailExploreState(
      digest: state.digest,
      digestLoading: true,
      digestError: null,
      context: state.context,
      contextLoading: state.contextLoading,
      contextError: state.contextError,
      blended: state.blended,
      blendedLoading: state.blendedLoading,
      blendedError: state.blendedError,
    );

    try {
      final digest = await _fetchDigest();
      state = DetailExploreState(
        digest: digest,
        digestLoading: false,
        digestError: null,
        context: state.context,
        contextLoading: state.contextLoading,
        contextError: state.contextError,
        blended: state.blended,
        blendedLoading: state.blendedLoading,
        blendedError: state.blendedError,
      );
    } catch (e) {
      state = DetailExploreState(
        digest: state.digest,
        digestLoading: false,
        digestError: e.toString(),
        context: state.context,
        contextLoading: state.contextLoading,
        contextError: state.contextError,
        blended: state.blended,
        blendedLoading: state.blendedLoading,
        blendedError: state.blendedError,
      );
    }
  }

  Future<void> _loadBlended() async {
    state = DetailExploreState(
      digest: state.digest,
      digestLoading: state.digestLoading,
      digestError: state.digestError,
      context: state.context,
      contextLoading: state.contextLoading,
      contextError: state.contextError,
      blended: state.blended,
      blendedLoading: true,
      blendedError: null,
    );

    try {
      final blended = await _repository.blendedRecommendations(
        contentType,
        id,
      );
      state = DetailExploreState(
        digest: state.digest,
        digestLoading: state.digestLoading,
        digestError: state.digestError,
        context: state.context,
        contextLoading: state.contextLoading,
        contextError: state.contextError,
        blended: blended,
        blendedLoading: false,
        blendedError: null,
      );
    } catch (e) {
      state = DetailExploreState(
        digest: state.digest,
        digestLoading: state.digestLoading,
        digestError: state.digestError,
        context: state.context,
        contextLoading: state.contextLoading,
        contextError: state.contextError,
        blended: state.blended,
        blendedLoading: false,
        blendedError: e.toString(),
      );
    }
  }

  Future<void> _loadContext() async {
    state = DetailExploreState(
      digest: state.digest,
      digestLoading: state.digestLoading,
      digestError: state.digestError,
      context: state.context,
      contextLoading: true,
      contextError: null,
      blended: state.blended,
      blendedLoading: state.blendedLoading,
      blendedError: state.blendedError,
    );

    try {
      final context = await _fetchContext();
      state = DetailExploreState(
        digest: state.digest,
        digestLoading: state.digestLoading,
        digestError: state.digestError,
        context: context,
        contextLoading: false,
        contextError: null,
        blended: state.blended,
        blendedLoading: state.blendedLoading,
        blendedError: state.blendedError,
      );
    } catch (e) {
      state = DetailExploreState(
        digest: state.digest,
        digestLoading: state.digestLoading,
        digestError: state.digestError,
        context: state.context,
        contextLoading: false,
        contextError: e.toString(),
        blended: state.blended,
        blendedLoading: state.blendedLoading,
        blendedError: state.blendedError,
      );
    }
  }

  Future<dynamic> _fetchDigest() async {
    switch (contentType) {
      case 'article':
        return _repository.articleDigest(id);
      case 'directoryItem':
        return _repository.directoryItemDigest(id);
      case 'inheritor':
        return _repository.inheritorDigest(id);
      default:
        throw ArgumentError('Unknown content type: $contentType');
    }
  }

  Future<dynamic> _fetchContext() async {
    switch (contentType) {
      case 'article':
        return _repository.articleContext(id);
      case 'directoryItem':
        return _repository.directoryItemContext(id);
      case 'inheritor':
        return _repository.inheritorContext(id);
      default:
        throw ArgumentError('Unknown content type: $contentType');
    }
  }

  void retryDigest() => _loadDigest();
  void retryBlended() => _loadBlended();
  void retryContext() => _loadContext();
}

/// 详情探索区参数
class DetailExploreParams {
  final String id;
  final String contentType;

  const DetailExploreParams({
    required this.id,
    required this.contentType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailExploreParams &&
          id == other.id &&
          contentType == other.contentType;

  @override
  int get hashCode => id.hashCode ^ contentType.hashCode;
}

/// 详情探索区 ViewModel Provider
final detailExploreViewModelProvider = StateNotifierProvider.autoDispose
    .family<DetailExploreViewModel, DetailExploreState, DetailExploreParams>(
  (ref, params) {
    final repository = ref.watch(heritageRepositoryProvider);
    return DetailExploreViewModel(
      repository,
      id: params.id,
      contentType: params.contentType,
    );
  },
);
