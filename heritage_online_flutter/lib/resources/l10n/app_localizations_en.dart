// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Heritage Online';

  @override
  String get tabArticles => 'Articles';

  @override
  String get tabDirectory => 'Directory';

  @override
  String get tabInheritors => 'Inheritors';

  @override
  String get tabDiscovery => 'Discovery';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonEmpty => 'No data available';

  @override
  String get commonSeeAll => 'See All';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsThemeModeTitle => 'Theme Mode';

  @override
  String get settingsLanguageModeTitle => 'App Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageSimplifiedChinese => '简体中文';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get contentTypeArticle => 'Article';

  @override
  String get contentTypeDirectory => 'Directory';

  @override
  String get contentTypeInheritor => 'Inheritor';

  @override
  String get contentTypeCollection => 'Collection';

  @override
  String get contentTypeTopic => 'Topic';

  @override
  String get categoryNews => 'News';

  @override
  String get categoryForum => 'Forum';

  @override
  String get categorySpecialTopic => 'Specials';

  @override
  String get directoryKindNationalProject => 'National Project';

  @override
  String get directoryKindCulturalEcoZone => 'Cultural Eco Zone';

  @override
  String get directoryKindProductiveProtectionBase => 'Protection Base';

  @override
  String get directoryKindUnescoEntry => 'UNESCO';

  @override
  String get directoryKindChinaUnescoEntry => 'China UNESCO';

  @override
  String get directoryKindContractingState => 'Contracting State';

  @override
  String get readingPathSourceBlendedRecommendation => 'Blended';

  @override
  String get readingPathSourceRelated => 'Related';

  @override
  String get readingPathSourceRecommendation => 'Recommendation';

  @override
  String get readingPathSourceSemanticRecommendation => 'Semantic';

  @override
  String get readingPathSourceCollection => 'Collection';

  @override
  String get readingPathSourceGraph => 'Graph';

  @override
  String get readingPathSourceExploreTopic => 'Topic';

  @override
  String get readingPathSourceList => 'List';

  @override
  String get articlesHeaderTitle => 'E迹';

  @override
  String get articlesHeaderSubtitle => 'Heritage news, forums and specials';

  @override
  String get articlesLatestTitle => 'Latest Articles';

  @override
  String get articlesSearchLabel => 'Search articles';

  @override
  String get articlesSearchPlaceholder => 'Title or keywords';

  @override
  String get directoryTabList => 'Directory';

  @override
  String get directoryTabStatistics => 'Statistics';

  @override
  String get directoryDetailTitle => 'Directory Detail';

  @override
  String get inheritorDetailTitle => 'Inheritor Detail';

  @override
  String get inheritorsEmptyMessage => 'No inheritors available at the moment.';

  @override
  String get unnamedInheritor => 'Unnamed Inheritor';

  @override
  String get filterGenderMale => 'Male';

  @override
  String get filterGenderFemale => 'Female';

  @override
  String get inheritorRelatedProjectsTitle => 'Related Projects';

  @override
  String get inheritorRelatedInheritorsTitle => 'Related Inheritors';

  @override
  String get favoritesEmptyMessage => 'No favorites yet.';

  @override
  String get recentEmptyMessage => 'No browsing history yet.';

  @override
  String get actionClearRecent => 'Clear Recent';

  @override
  String get errorOpenUrl => 'Unable to open link';

  @override
  String get readingPathEmpty =>
      'Your exploration path will appear here after browsing details';

  @override
  String get readingPathClear => 'Clear Reading Path';

  @override
  String get discoveryTaxonomy => 'Taxonomy';

  @override
  String get discoveryStories => 'Data Stories';

  @override
  String get discoverySerendipity => 'Serendipity';

  @override
  String get searchEmptyMessage => 'No results found';

  @override
  String get searchLabel => 'Search';

  @override
  String get searchPlaceholder => 'Search heritage content';

  @override
  String searchResultCount(int count) {
    return '$count result(s)';
  }

  @override
  String get searchFilter => 'Filter';

  @override
  String get searchFilterTitle => 'Search Filters';

  @override
  String get searchFilterClearAll => 'Clear all filters';

  @override
  String get searchLoadMore => 'Load more';

  @override
  String get searchTypeAny => 'All';

  @override
  String get discoverySerendipityLoading => 'Exploring…';

  @override
  String get discoveryDeepDive => 'Deep Dive';

  @override
  String get discoveryToday => 'Today\'s Discovery';

  @override
  String get discoveryTrending => 'Trending';

  @override
  String get discoveryWeekly => 'This Week\'s Heritage';

  @override
  String get articleDetailTitle => 'Article Detail';

  @override
  String get directoryTitle => 'Heritage Directory';

  @override
  String get directorySubtitle =>
      'Projects, eco zones, protection bases and UNESCO entries';

  @override
  String get directorySearchLabel => 'Search directory';

  @override
  String get directorySearchPlaceholder => 'Project name, region or category';

  @override
  String get inheritorsTitle => 'Representative Inheritors';

  @override
  String get inheritorsSubtitle =>
      'Browse inheritor profiles by project, category and region';

  @override
  String get inheritorsSearchLabel => 'Search inheritors';

  @override
  String get inheritorsSearchPlaceholder => 'Name, project, region or category';

  @override
  String get discoveryTitle => 'Discovery';

  @override
  String get discoverySubtitle =>
      'Explore, learning paths and featured collections';

  @override
  String get discoverySearchPlaceholder => 'Search heritage content';

  @override
  String get discoveryExploreTopics => 'Today\'s Explore';

  @override
  String get discoveryLearningPaths => 'Learning Paths';

  @override
  String get discoveryFeaturedCollections => 'Featured Collections';

  @override
  String get discoveryRegionAtlas => 'Region Atlas';

  @override
  String get discoveryTimeline => 'Timeline';

  @override
  String get discoveryTimelineSubtitle => 'Browse heritage content by year';

  @override
  String get exploreTopicTimeline => 'Timeline';

  @override
  String get exploreTopicRelated => 'Related Topics';

  @override
  String get learningFeaturedItems => 'Featured Items';

  @override
  String get learningPathSteps => 'Learning Steps';

  @override
  String get learningRelatedTopics => 'Related Topics';

  @override
  String get learningPathFeatured => 'Featured Content';

  @override
  String get filterButton => 'Filter';

  @override
  String get filterClear => 'Clear filters';

  @override
  String get filterApply => 'Apply';

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterFieldYear => 'Year';

  @override
  String filterLabelYear(String year) {
    return 'Year: $year';
  }

  @override
  String get filterPlaceholderYear => 'e.g. 2024';

  @override
  String get filterInvalidYear => 'Please enter a 4-digit year';

  @override
  String get myTitle => 'My Page';

  @override
  String get favoritesTab => 'Favorites';

  @override
  String get recentTab => 'Recent';

  @override
  String get readingPathTab => 'Reading Path';

  @override
  String get actionFavorite => 'Favorite';

  @override
  String get actionUnfavorite => 'Unfavorite';

  @override
  String get actionViewSource => 'View Source';

  @override
  String get actionBack => 'Back';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get errorNetworkUnavailable =>
      'Network unavailable. Please check your connection.';

  @override
  String get errorTimeout => 'Request timed out. Please try again later.';

  @override
  String get errorServerUnavailable => 'Service temporarily unavailable.';

  @override
  String get contentMayBeStale => 'Content may not be up to date';

  @override
  String get brandFallback => 'E迹';

  @override
  String get settingsMyPageDescription => 'Favorites, Recent & Reading Path';

  @override
  String get previewImage => 'Preview Image';

  @override
  String get previewClose => 'Close Preview';

  @override
  String previewPageIndicator(int currentPage, int totalPages) {
    return '$currentPage / $totalPages';
  }

  @override
  String get detailLabelAuthor => 'Author';

  @override
  String get detailLabelEditor => 'Editor';

  @override
  String get detailLabelSource => 'Source';

  @override
  String get articleRelatedTitle => 'Related Articles';

  @override
  String directoryStatisticsOverviewFormat(String kind) {
    return '$kind Overview';
  }

  @override
  String get directoryStatisticsYearBreakdown => 'By Year';

  @override
  String get directoryStatisticsCategoryBreakdown => 'By Category';

  @override
  String get directoryStatisticsRegionBreakdown => 'By Region';

  @override
  String directoryStatisticsTotalItems(int total) {
    return '$total items in total';
  }

  @override
  String directoryStatisticsGeneratedAt(String date) {
    return 'Generated at $date';
  }

  @override
  String directoryStatisticsDimensions(int count) {
    return '$count dimensions';
  }

  @override
  String get filterFieldRegion => 'Region';

  @override
  String get filterFieldCategory => 'Category';

  @override
  String get filterFieldListType => 'List type';

  @override
  String get filterPlaceholderRegion => 'e.g. Beijing';

  @override
  String get filterPlaceholderListType => 'e.g. representative';

  @override
  String get filterFieldKind => 'Kind';

  @override
  String get filterFieldHasImage => 'Has image';

  @override
  String get filterHasImageYes => 'Yes';

  @override
  String get filterHasImageNo => 'No';

  @override
  String get directoryDetailGallery => 'Gallery';

  @override
  String get directoryDetailRelatedProjects => 'Related Projects';

  @override
  String get directoryDetailRelatedInheritors => 'Related Inheritors';

  @override
  String get directoryDetailRelatedDocuments => 'Related Documents';

  @override
  String get factLabelCategory => 'Category';

  @override
  String get factLabelRegion => 'Region';

  @override
  String get factLabelProjectCode => 'Project No.';

  @override
  String get factLabelBatch => 'Batch';

  @override
  String get factLabelYear => 'Year';

  @override
  String get factLabelListType => 'List Type';

  @override
  String get factLabelNominationType => 'Nomination';

  @override
  String get factLabelProtectionUnit => 'Protection Unit';

  @override
  String get factLabelGender => 'Gender';

  @override
  String get factLabelBirthDate => 'Birth Date';

  @override
  String get factLabelEthnicity => 'Ethnicity';

  @override
  String get factLabelRepresentativeProject => 'Representative Project';

  @override
  String get timelineSelectYear => 'Select a year to browse';

  @override
  String get timelineLoadMore => 'Load more';

  @override
  String get timelineTypeAll => 'All';

  @override
  String timelineYearStats(
    int total,
    int articles,
    int directories,
    int inheritors,
  ) {
    return '$total items · $articles articles · $directories directory · $inheritors inheritors';
  }

  @override
  String get timelineNoItems => 'No content for this year';

  @override
  String regionAtlasTotalRegions(int count) {
    return '$count regions';
  }

  @override
  String get regionAtlasTotal => 'Total';

  @override
  String get regionAtlasDirectoryItems => 'Directory Items';

  @override
  String get regionAtlasInheritors => 'Inheritors';

  @override
  String get regionAtlasCategoryBreakdown => 'By Category';

  @override
  String get regionAtlasKindBreakdown => 'By Kind';

  @override
  String get regionAtlasFeaturedDirectory => 'Featured Directory';

  @override
  String get regionAtlasFeaturedInheritors => 'Featured Inheritors';

  @override
  String get regionAtlasRelatedArticles => 'Related Articles';

  @override
  String get regionAtlasRelatedRegions => 'Related Regions';

  @override
  String collectionItemCount(int count) {
    return '$count items';
  }

  @override
  String get collectionEmptyItems => 'This collection is empty';

  @override
  String get exploreSectionTitle => 'Explore';

  @override
  String get digestTitle => 'Quick Read';

  @override
  String digestReadingTime(int minutes) {
    return '$minutes min read';
  }

  @override
  String get digestHighlights => 'Highlights';

  @override
  String get digestKeyFacts => 'Key Facts';

  @override
  String get blendedRecommendationsTitle => 'Recommended for You';

  @override
  String get contextRelatedTitle => 'Related';

  @override
  String get contextRecommendationsTitle => 'Recommendations';

  @override
  String get contextSemanticTitle => 'Semantic Recommendations';

  @override
  String get contextCollectionsTitle => 'Collections';

  @override
  String get contextTopicsTitle => 'Explore Topics';

  @override
  String get contextGraphTitle => 'Relationships';

  @override
  String get storiesByRegion => 'By Region';

  @override
  String get storiesByCategory => 'By Category';

  @override
  String get storiesByYear => 'By Year';

  @override
  String storiesReadingTime(int minutes) {
    return '$minutes min read';
  }

  @override
  String get taxonomyTabCategories => 'Categories';

  @override
  String get taxonomyTabRegions => 'Regions';

  @override
  String get taxonomyTabKinds => 'Kinds';

  @override
  String get taxonomyDirectoryItems => 'Directory Items';

  @override
  String get taxonomyInheritors => 'Inheritors';

  @override
  String get taxonomyArticles => 'Articles';

  @override
  String get compareTitle => 'Compare';

  @override
  String get compareTypeRegion => 'Region';

  @override
  String get compareTypeCategory => 'Category';

  @override
  String get compareTypeKind => 'Kind';

  @override
  String get compareLeftLabel => 'Left';

  @override
  String get compareRightLabel => 'Right';

  @override
  String get compareStartButton => 'Compare';

  @override
  String get compareSharedCategories => 'Shared Categories';

  @override
  String get compareUniqueLeft => 'Unique to Left';

  @override
  String get compareUniqueRight => 'Unique to Right';

  @override
  String get compareValidationEmpty => 'Both sides must be filled';

  @override
  String get compareValidationSame => 'Both sides cannot be the same';

  @override
  String get compareStatTotal => 'Total';

  @override
  String get urlLaunchEmpty => 'URL is empty';

  @override
  String get urlLaunchInvalid => 'Invalid URL format';

  @override
  String get urlLaunchUnsupportedScheme => 'Unsupported URL scheme';

  @override
  String get urlLaunchCannotOpen => 'Cannot open URL';

  @override
  String get urlLaunchFailed => 'Failed to open URL';

  @override
  String get digestCollapse => 'Collapse';

  @override
  String get digestExpand => 'Expand';

  @override
  String get storyRegionBeijing => 'Beijing';

  @override
  String get storyRegionShanghai => 'Shanghai';

  @override
  String get storyRegionSichuan => 'Sichuan';

  @override
  String get storyRegionJiangsu => 'Jiangsu';

  @override
  String get storyRegionZhejiang => 'Zhejiang';

  @override
  String get storyRegionGuangdong => 'Guangdong';

  @override
  String get storyCategoryTraditionalCraft => 'Traditional Craft';

  @override
  String get storyCategoryTraditionalMusic => 'Traditional Music';

  @override
  String get storyCategoryTraditionalDrama => 'Traditional Drama';

  @override
  String get storyCategoryTraditionalArt => 'Traditional Art';

  @override
  String get storyCategoryFolkCustom => 'Folk Custom';

  @override
  String get storyCategoryFolkLiterature => 'Folk Literature';
}
