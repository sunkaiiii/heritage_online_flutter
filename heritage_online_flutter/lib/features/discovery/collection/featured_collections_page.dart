import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/collection_dtos.dart';
import 'package:heritage_online_flutter/features/discovery/collection/collection_detail_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 精选合集列表页
class FeaturedCollectionsListPage extends ConsumerWidget {
  final VoidCallback onBack;

  const FeaturedCollectionsListPage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final repository = ref.watch(heritageRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.discoveryFeaturedCollections),
      ),
      body: PageBackground(
        child: FutureBuilder<List<FeaturedCollectionDto>>(
          future: repository.featuredCollections(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPlaceholder();
            }

            if (snapshot.hasError) {
              return ErrorRetryRow(
                message: l10n.commonError,
                onRetry: () => ref.invalidate(heritageRepositoryProvider),
              );
            }

            final collections = snapshot.data ?? [];
            if (collections.isEmpty) {
              return EmptyState(message: l10n.commonEmpty);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: collections.length,
              itemBuilder: (context, index) {
                final item = collections[index];
                return _FeaturedCollectionCard(
                  collection: item,
                  l10n: l10n,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CollectionDetailPage(
                          collectionId: item.id,
                          onBack: () => Navigator.of(context).pop(),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// 精选合集卡片
class _FeaturedCollectionCard extends StatelessWidget {
  final FeaturedCollectionDto collection;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _FeaturedCollectionCard({
    required this.collection,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ContentCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.collections_bookmark,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collection.title ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (collection.subtitle != null &&
                      collection.subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      collection.subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (collection.itemCount > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.collectionItemCount(collection.itemCount),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
