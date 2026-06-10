import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Heritage Online'**
  String get appTitle;

  /// Bottom navigation tab for articles
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get tabArticles;

  /// Bottom navigation tab for directory items
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get tabDirectory;

  /// Bottom navigation tab for inheritors
  ///
  /// In en, this message translates to:
  /// **'Inheritors'**
  String get tabInheritors;

  /// Bottom navigation tab for discovery
  ///
  /// In en, this message translates to:
  /// **'Discovery'**
  String get tabDiscovery;

  /// Common retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// Common loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// Common error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// Common empty state message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get commonEmpty;

  /// Common see all button
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get commonSeeAll;

  /// Common confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// Common cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings language option
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Settings theme option
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// Settings page appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// Settings page language section title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// Theme mode selection title
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get settingsThemeModeTitle;

  /// Language mode selection title
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingsLanguageModeTitle;

  /// System language option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  /// Simplified Chinese language option
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get settingsLanguageSimplifiedChinese;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// Content type: article
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get contentTypeArticle;

  /// Content type: directory
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get contentTypeDirectory;

  /// Content type: inheritor
  ///
  /// In en, this message translates to:
  /// **'Inheritor'**
  String get contentTypeInheritor;

  /// Content type: collection
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get contentTypeCollection;

  /// Content type: explore topic
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get contentTypeTopic;

  /// Article category: news
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get categoryNews;

  /// Article category: forum
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get categoryForum;

  /// Article category: special topic
  ///
  /// In en, this message translates to:
  /// **'Specials'**
  String get categorySpecialTopic;

  /// Directory kind: national project
  ///
  /// In en, this message translates to:
  /// **'National Project'**
  String get directoryKindNationalProject;

  /// Directory kind: cultural eco zone
  ///
  /// In en, this message translates to:
  /// **'Cultural Eco Zone'**
  String get directoryKindCulturalEcoZone;

  /// Directory kind: productive protection base
  ///
  /// In en, this message translates to:
  /// **'Protection Base'**
  String get directoryKindProductiveProtectionBase;

  /// Directory kind: UNESCO entry
  ///
  /// In en, this message translates to:
  /// **'UNESCO'**
  String get directoryKindUnescoEntry;

  /// Directory kind: China UNESCO entry
  ///
  /// In en, this message translates to:
  /// **'China UNESCO'**
  String get directoryKindChinaUnescoEntry;

  /// Directory kind: contracting state
  ///
  /// In en, this message translates to:
  /// **'Contracting State'**
  String get directoryKindContractingState;

  /// Reading path source: blended recommendation
  ///
  /// In en, this message translates to:
  /// **'Blended'**
  String get readingPathSourceBlendedRecommendation;

  /// Reading path source: related
  ///
  /// In en, this message translates to:
  /// **'Related'**
  String get readingPathSourceRelated;

  /// Reading path source: recommendation
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get readingPathSourceRecommendation;

  /// Reading path source: semantic recommendation
  ///
  /// In en, this message translates to:
  /// **'Semantic'**
  String get readingPathSourceSemanticRecommendation;

  /// Reading path source: collection
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get readingPathSourceCollection;

  /// Reading path source: graph
  ///
  /// In en, this message translates to:
  /// **'Graph'**
  String get readingPathSourceGraph;

  /// Reading path source: explore topic
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get readingPathSourceExploreTopic;

  /// Reading path source: list
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get readingPathSourceList;

  /// Articles page header title
  ///
  /// In en, this message translates to:
  /// **'E迹'**
  String get articlesHeaderTitle;

  /// Articles page header subtitle
  ///
  /// In en, this message translates to:
  /// **'Heritage news, forums and specials'**
  String get articlesHeaderSubtitle;

  /// Latest articles section title
  ///
  /// In en, this message translates to:
  /// **'Latest Articles'**
  String get articlesLatestTitle;

  /// Articles search field label
  ///
  /// In en, this message translates to:
  /// **'Search articles'**
  String get articlesSearchLabel;

  /// Articles search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Title or keywords'**
  String get articlesSearchPlaceholder;

  /// Directory page list tab
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get directoryTabList;

  /// Directory page statistics tab
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get directoryTabStatistics;

  /// Directory detail page title
  ///
  /// In en, this message translates to:
  /// **'Directory Detail'**
  String get directoryDetailTitle;

  /// Inheritor detail page title
  ///
  /// In en, this message translates to:
  /// **'Inheritor Detail'**
  String get inheritorDetailTitle;

  /// Inheritors list empty state message
  ///
  /// In en, this message translates to:
  /// **'No inheritors available at the moment.'**
  String get inheritorsEmptyMessage;

  /// Unnamed inheritor
  ///
  /// In en, this message translates to:
  /// **'Unnamed Inheritor'**
  String get unnamedInheritor;

  /// Gender filter: male
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get filterGenderMale;

  /// Gender filter: female
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get filterGenderFemale;

  /// Inheritor detail related projects title
  ///
  /// In en, this message translates to:
  /// **'Related Projects'**
  String get inheritorRelatedProjectsTitle;

  /// Inheritor detail related inheritors title
  ///
  /// In en, this message translates to:
  /// **'Related Inheritors'**
  String get inheritorRelatedInheritorsTitle;

  /// Favorites list empty state message
  ///
  /// In en, this message translates to:
  /// **'No favorites yet.'**
  String get favoritesEmptyMessage;

  /// Recently viewed list empty state message
  ///
  /// In en, this message translates to:
  /// **'No browsing history yet.'**
  String get recentEmptyMessage;

  /// Clear recently viewed button
  ///
  /// In en, this message translates to:
  /// **'Clear Recent'**
  String get actionClearRecent;

  /// Unable to open URL error message
  ///
  /// In en, this message translates to:
  /// **'Unable to open link'**
  String get errorOpenUrl;

  /// Reading path empty state message
  ///
  /// In en, this message translates to:
  /// **'Your exploration path will appear here after browsing details'**
  String get readingPathEmpty;

  /// Clear reading path button
  ///
  /// In en, this message translates to:
  /// **'Clear Reading Path'**
  String get readingPathClear;

  /// Discovery page taxonomy entry
  ///
  /// In en, this message translates to:
  /// **'Taxonomy'**
  String get discoveryTaxonomy;

  /// Discovery page data stories entry
  ///
  /// In en, this message translates to:
  /// **'Data Stories'**
  String get discoveryStories;

  /// Discovery page serendipity entry
  ///
  /// In en, this message translates to:
  /// **'Serendipity'**
  String get discoverySerendipity;

  /// Search results empty message
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchEmptyMessage;

  /// Search button text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchLabel;

  /// Search input placeholder
  ///
  /// In en, this message translates to:
  /// **'Search heritage content'**
  String get searchPlaceholder;

  /// Search result count
  ///
  /// In en, this message translates to:
  /// **'{count} result(s)'**
  String searchResultCount(int count);

  /// Search filter button
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get searchFilter;

  /// Search filter sheet title
  ///
  /// In en, this message translates to:
  /// **'Search Filters'**
  String get searchFilterTitle;

  /// Clear all search filters button
  ///
  /// In en, this message translates to:
  /// **'Clear all filters'**
  String get searchFilterClearAll;

  /// Load more button
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get searchLoadMore;

  /// Search type: all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get searchTypeAny;

  /// Serendipity button loading text
  ///
  /// In en, this message translates to:
  /// **'Exploring…'**
  String get discoverySerendipityLoading;

  /// Deep dive button and page title
  ///
  /// In en, this message translates to:
  /// **'Deep Dive'**
  String get discoveryDeepDive;

  /// Discovery page today section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Discovery'**
  String get discoveryToday;

  /// Discovery page trending section title
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get discoveryTrending;

  /// Discovery page weekly section title
  ///
  /// In en, this message translates to:
  /// **'This Week\'s Heritage'**
  String get discoveryWeekly;

  /// Article detail page title
  ///
  /// In en, this message translates to:
  /// **'Article Detail'**
  String get articleDetailTitle;

  /// Directory page title
  ///
  /// In en, this message translates to:
  /// **'Heritage Directory'**
  String get directoryTitle;

  /// Directory page subtitle
  ///
  /// In en, this message translates to:
  /// **'Projects, eco zones, protection bases and UNESCO entries'**
  String get directorySubtitle;

  /// Directory search field label
  ///
  /// In en, this message translates to:
  /// **'Search directory'**
  String get directorySearchLabel;

  /// Directory search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Project name, region or category'**
  String get directorySearchPlaceholder;

  /// Inheritors page title
  ///
  /// In en, this message translates to:
  /// **'Representative Inheritors'**
  String get inheritorsTitle;

  /// Inheritors page subtitle
  ///
  /// In en, this message translates to:
  /// **'Browse inheritor profiles by project, category and region'**
  String get inheritorsSubtitle;

  /// Inheritors search field label
  ///
  /// In en, this message translates to:
  /// **'Search inheritors'**
  String get inheritorsSearchLabel;

  /// Inheritors search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Name, project, region or category'**
  String get inheritorsSearchPlaceholder;

  /// Discovery page title
  ///
  /// In en, this message translates to:
  /// **'Discovery'**
  String get discoveryTitle;

  /// Discovery page subtitle
  ///
  /// In en, this message translates to:
  /// **'Explore, learning paths and featured collections'**
  String get discoverySubtitle;

  /// Discovery search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search heritage content'**
  String get discoverySearchPlaceholder;

  /// Discovery today's explore
  ///
  /// In en, this message translates to:
  /// **'Today\'s Explore'**
  String get discoveryExploreTopics;

  /// Discovery learning paths
  ///
  /// In en, this message translates to:
  /// **'Learning Paths'**
  String get discoveryLearningPaths;

  /// Discovery featured collections
  ///
  /// In en, this message translates to:
  /// **'Featured Collections'**
  String get discoveryFeaturedCollections;

  /// Discovery region atlas
  ///
  /// In en, this message translates to:
  /// **'Region Atlas'**
  String get discoveryRegionAtlas;

  /// Discovery timeline
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get discoveryTimeline;

  /// Discovery timeline subtitle
  ///
  /// In en, this message translates to:
  /// **'Browse heritage content by year'**
  String get discoveryTimelineSubtitle;

  /// Explore topic detail timeline section title
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get exploreTopicTimeline;

  /// Explore topic detail related topics section title
  ///
  /// In en, this message translates to:
  /// **'Related Topics'**
  String get exploreTopicRelated;

  /// Learning path featured items section title
  ///
  /// In en, this message translates to:
  /// **'Featured Items'**
  String get learningFeaturedItems;

  /// Learning path steps section title
  ///
  /// In en, this message translates to:
  /// **'Learning Steps'**
  String get learningPathSteps;

  /// Learning path related topics section title
  ///
  /// In en, this message translates to:
  /// **'Related Topics'**
  String get learningRelatedTopics;

  /// Learning path featured content section title
  ///
  /// In en, this message translates to:
  /// **'Featured Content'**
  String get learningPathFeatured;

  /// Filter button
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterButton;

  /// Clear filters button
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get filterClear;

  /// Apply filters button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get filterApply;

  /// Filter sheet title
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// Year filter field label
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get filterFieldYear;

  /// Year filter chip label
  ///
  /// In en, this message translates to:
  /// **'Year: {year}'**
  String filterLabelYear(String year);

  /// Year filter field placeholder
  ///
  /// In en, this message translates to:
  /// **'e.g. 2024'**
  String get filterPlaceholderYear;

  /// Invalid year format message
  ///
  /// In en, this message translates to:
  /// **'Please enter a 4-digit year'**
  String get filterInvalidYear;

  /// My page title
  ///
  /// In en, this message translates to:
  /// **'My Page'**
  String get myTitle;

  /// Favorites tab
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTab;

  /// Recent tab
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentTab;

  /// Reading path tab
  ///
  /// In en, this message translates to:
  /// **'Reading Path'**
  String get readingPathTab;

  /// Favorite action
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get actionFavorite;

  /// Unfavorite action
  ///
  /// In en, this message translates to:
  /// **'Unfavorite'**
  String get actionUnfavorite;

  /// View source button
  ///
  /// In en, this message translates to:
  /// **'View Source'**
  String get actionViewSource;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// Refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actionRefresh;

  /// Network unavailable error
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Please check your connection.'**
  String get errorNetworkUnavailable;

  /// Request timeout error
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again later.'**
  String get errorTimeout;

  /// Server unavailable error
  ///
  /// In en, this message translates to:
  /// **'Service temporarily unavailable.'**
  String get errorServerUnavailable;

  /// Content may be stale hint
  ///
  /// In en, this message translates to:
  /// **'Content may not be up to date'**
  String get contentMayBeStale;

  /// Brand fallback text
  ///
  /// In en, this message translates to:
  /// **'E迹'**
  String get brandFallback;

  /// Settings my page entry description
  ///
  /// In en, this message translates to:
  /// **'Favorites, Recent & Reading Path'**
  String get settingsMyPageDescription;

  /// Image preview title
  ///
  /// In en, this message translates to:
  /// **'Preview Image'**
  String get previewImage;

  /// Close image preview
  ///
  /// In en, this message translates to:
  /// **'Close Preview'**
  String get previewClose;

  /// Image preview page indicator
  ///
  /// In en, this message translates to:
  /// **'{currentPage} / {totalPages}'**
  String previewPageIndicator(int currentPage, int totalPages);

  /// Detail page author label
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get detailLabelAuthor;

  /// Detail page editor label
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get detailLabelEditor;

  /// Detail page source label
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get detailLabelSource;

  /// Article detail related articles section title
  ///
  /// In en, this message translates to:
  /// **'Related Articles'**
  String get articleRelatedTitle;

  /// Statistics overview title with kind
  ///
  /// In en, this message translates to:
  /// **'{kind} Overview'**
  String directoryStatisticsOverviewFormat(String kind);

  /// Year breakdown section title
  ///
  /// In en, this message translates to:
  /// **'By Year'**
  String get directoryStatisticsYearBreakdown;

  /// Category breakdown section title
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get directoryStatisticsCategoryBreakdown;

  /// Region breakdown section title
  ///
  /// In en, this message translates to:
  /// **'By Region'**
  String get directoryStatisticsRegionBreakdown;

  /// Total item count
  ///
  /// In en, this message translates to:
  /// **'{total} items in total'**
  String directoryStatisticsTotalItems(int total);

  /// Statistics generation date
  ///
  /// In en, this message translates to:
  /// **'Generated at {date}'**
  String directoryStatisticsGeneratedAt(String date);

  /// Number of statistic dimensions
  ///
  /// In en, this message translates to:
  /// **'{count} dimensions'**
  String directoryStatisticsDimensions(int count);

  /// Region filter field label
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get filterFieldRegion;

  /// Category filter field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filterFieldCategory;

  /// List type filter field label
  ///
  /// In en, this message translates to:
  /// **'List type'**
  String get filterFieldListType;

  /// Region filter placeholder
  ///
  /// In en, this message translates to:
  /// **'e.g. Beijing'**
  String get filterPlaceholderRegion;

  /// List type filter placeholder
  ///
  /// In en, this message translates to:
  /// **'e.g. representative'**
  String get filterPlaceholderListType;

  /// Kind filter field label
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get filterFieldKind;

  /// Has image filter field label
  ///
  /// In en, this message translates to:
  /// **'Has image'**
  String get filterFieldHasImage;

  /// Has image filter: yes
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get filterHasImageYes;

  /// Has image filter: no
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get filterHasImageNo;

  /// Directory detail gallery section title
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get directoryDetailGallery;

  /// Directory detail related projects title
  ///
  /// In en, this message translates to:
  /// **'Related Projects'**
  String get directoryDetailRelatedProjects;

  /// Directory detail related inheritors title
  ///
  /// In en, this message translates to:
  /// **'Related Inheritors'**
  String get directoryDetailRelatedInheritors;

  /// Directory detail related documents title
  ///
  /// In en, this message translates to:
  /// **'Related Documents'**
  String get directoryDetailRelatedDocuments;

  /// FactCard category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get factLabelCategory;

  /// FactCard region label
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get factLabelRegion;

  /// FactCard project code label
  ///
  /// In en, this message translates to:
  /// **'Project No.'**
  String get factLabelProjectCode;

  /// FactCard batch label
  ///
  /// In en, this message translates to:
  /// **'Batch'**
  String get factLabelBatch;

  /// FactCard year label
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get factLabelYear;

  /// FactCard list type label
  ///
  /// In en, this message translates to:
  /// **'List Type'**
  String get factLabelListType;

  /// FactCard nomination type label
  ///
  /// In en, this message translates to:
  /// **'Nomination'**
  String get factLabelNominationType;

  /// FactCard protection unit label
  ///
  /// In en, this message translates to:
  /// **'Protection Unit'**
  String get factLabelProtectionUnit;

  /// FactCard gender label
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get factLabelGender;

  /// FactCard birth date label
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get factLabelBirthDate;

  /// FactCard ethnicity label
  ///
  /// In en, this message translates to:
  /// **'Ethnicity'**
  String get factLabelEthnicity;

  /// FactCard representative project label
  ///
  /// In en, this message translates to:
  /// **'Representative Project'**
  String get factLabelRepresentativeProject;

  /// Timeline select year prompt
  ///
  /// In en, this message translates to:
  /// **'Select a year to browse'**
  String get timelineSelectYear;

  /// Timeline load more button
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get timelineLoadMore;

  /// Timeline type filter: all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get timelineTypeAll;

  /// Timeline year bucket stats
  ///
  /// In en, this message translates to:
  /// **'{total} items · {articles} articles · {directories} directory · {inheritors} inheritors'**
  String timelineYearStats(
    int total,
    int articles,
    int directories,
    int inheritors,
  );

  /// Timeline empty items message
  ///
  /// In en, this message translates to:
  /// **'No content for this year'**
  String get timelineNoItems;

  /// Region atlas total region count
  ///
  /// In en, this message translates to:
  /// **'{count} regions'**
  String regionAtlasTotalRegions(int count);

  /// Region detail total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get regionAtlasTotal;

  /// Region atlas directory item count label
  ///
  /// In en, this message translates to:
  /// **'Directory Items'**
  String get regionAtlasDirectoryItems;

  /// Region atlas inheritor count label
  ///
  /// In en, this message translates to:
  /// **'Inheritors'**
  String get regionAtlasInheritors;

  /// Region detail category breakdown title
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get regionAtlasCategoryBreakdown;

  /// Region detail kind breakdown title
  ///
  /// In en, this message translates to:
  /// **'By Kind'**
  String get regionAtlasKindBreakdown;

  /// Region detail featured directory items title
  ///
  /// In en, this message translates to:
  /// **'Featured Directory'**
  String get regionAtlasFeaturedDirectory;

  /// Region detail featured inheritors title
  ///
  /// In en, this message translates to:
  /// **'Featured Inheritors'**
  String get regionAtlasFeaturedInheritors;

  /// Region detail related articles title
  ///
  /// In en, this message translates to:
  /// **'Related Articles'**
  String get regionAtlasRelatedArticles;

  /// Region detail related regions title
  ///
  /// In en, this message translates to:
  /// **'Related Regions'**
  String get regionAtlasRelatedRegions;

  /// Collection item count
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String collectionItemCount(int count);

  /// Collection empty items message
  ///
  /// In en, this message translates to:
  /// **'This collection is empty'**
  String get collectionEmptyItems;

  /// Detail page explore section title
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreSectionTitle;

  /// Content digest section title
  ///
  /// In en, this message translates to:
  /// **'Quick Read'**
  String get digestTitle;

  /// Digest reading time
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String digestReadingTime(int minutes);

  /// Digest highlights section
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get digestHighlights;

  /// Digest key facts section
  ///
  /// In en, this message translates to:
  /// **'Key Facts'**
  String get digestKeyFacts;

  /// Blended recommendations section title
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get blendedRecommendationsTitle;

  /// Context related items section title
  ///
  /// In en, this message translates to:
  /// **'Related'**
  String get contextRelatedTitle;

  /// Context recommendations section title
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get contextRecommendationsTitle;

  /// Context semantic recommendations section title
  ///
  /// In en, this message translates to:
  /// **'Semantic Recommendations'**
  String get contextSemanticTitle;

  /// Context collections section title
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get contextCollectionsTitle;

  /// Context explore topics section title
  ///
  /// In en, this message translates to:
  /// **'Explore Topics'**
  String get contextTopicsTitle;

  /// Context graph relationships section title
  ///
  /// In en, this message translates to:
  /// **'Relationships'**
  String get contextGraphTitle;

  /// Stories index: browse by region
  ///
  /// In en, this message translates to:
  /// **'By Region'**
  String get storiesByRegion;

  /// Stories index: browse by category
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get storiesByCategory;

  /// Stories index: browse by year
  ///
  /// In en, this message translates to:
  /// **'By Year'**
  String get storiesByYear;

  /// Story reading time
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String storiesReadingTime(int minutes);

  /// Taxonomy page categories tab
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get taxonomyTabCategories;

  /// Taxonomy page regions tab
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get taxonomyTabRegions;

  /// Taxonomy page kinds tab
  ///
  /// In en, this message translates to:
  /// **'Kinds'**
  String get taxonomyTabKinds;

  /// Taxonomy directory item count
  ///
  /// In en, this message translates to:
  /// **'Directory Items'**
  String get taxonomyDirectoryItems;

  /// Taxonomy inheritor count
  ///
  /// In en, this message translates to:
  /// **'Inheritors'**
  String get taxonomyInheritors;

  /// Taxonomy article count
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get taxonomyArticles;

  /// Compare page title
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compareTitle;

  /// Compare type: region
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get compareTypeRegion;

  /// Compare type: category
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get compareTypeCategory;

  /// Compare type: kind
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get compareTypeKind;

  /// Compare left side label
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get compareLeftLabel;

  /// Compare right side label
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get compareRightLabel;

  /// Compare start button
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compareStartButton;

  /// Compare shared categories section
  ///
  /// In en, this message translates to:
  /// **'Shared Categories'**
  String get compareSharedCategories;

  /// Compare left unique items
  ///
  /// In en, this message translates to:
  /// **'Unique to Left'**
  String get compareUniqueLeft;

  /// Compare right unique items
  ///
  /// In en, this message translates to:
  /// **'Unique to Right'**
  String get compareUniqueRight;

  /// Compare validation: empty input
  ///
  /// In en, this message translates to:
  /// **'Both sides must be filled'**
  String get compareValidationEmpty;

  /// Compare validation: same input
  ///
  /// In en, this message translates to:
  /// **'Both sides cannot be the same'**
  String get compareValidationSame;

  /// Compare stat: total count
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get compareStatTotal;

  /// Error message when URL is empty
  ///
  /// In en, this message translates to:
  /// **'URL is empty'**
  String get urlLaunchEmpty;

  /// Error message when URL format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid URL format'**
  String get urlLaunchInvalid;

  /// Error message when URL scheme is not http/https
  ///
  /// In en, this message translates to:
  /// **'Unsupported URL scheme'**
  String get urlLaunchUnsupportedScheme;

  /// Error message when URL cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Cannot open URL'**
  String get urlLaunchCannotOpen;

  /// Error message when URL launch fails
  ///
  /// In en, this message translates to:
  /// **'Failed to open URL'**
  String get urlLaunchFailed;

  /// Button to collapse digest highlights
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get digestCollapse;

  /// Button to expand digest highlights
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get digestExpand;

  /// No description provided for @storyRegionBeijing.
  ///
  /// In en, this message translates to:
  /// **'Beijing'**
  String get storyRegionBeijing;

  /// No description provided for @storyRegionShanghai.
  ///
  /// In en, this message translates to:
  /// **'Shanghai'**
  String get storyRegionShanghai;

  /// No description provided for @storyRegionSichuan.
  ///
  /// In en, this message translates to:
  /// **'Sichuan'**
  String get storyRegionSichuan;

  /// No description provided for @storyRegionJiangsu.
  ///
  /// In en, this message translates to:
  /// **'Jiangsu'**
  String get storyRegionJiangsu;

  /// No description provided for @storyRegionZhejiang.
  ///
  /// In en, this message translates to:
  /// **'Zhejiang'**
  String get storyRegionZhejiang;

  /// No description provided for @storyRegionGuangdong.
  ///
  /// In en, this message translates to:
  /// **'Guangdong'**
  String get storyRegionGuangdong;

  /// No description provided for @storyCategoryTraditionalCraft.
  ///
  /// In en, this message translates to:
  /// **'Traditional Craft'**
  String get storyCategoryTraditionalCraft;

  /// No description provided for @storyCategoryTraditionalMusic.
  ///
  /// In en, this message translates to:
  /// **'Traditional Music'**
  String get storyCategoryTraditionalMusic;

  /// No description provided for @storyCategoryTraditionalDrama.
  ///
  /// In en, this message translates to:
  /// **'Traditional Drama'**
  String get storyCategoryTraditionalDrama;

  /// No description provided for @storyCategoryTraditionalArt.
  ///
  /// In en, this message translates to:
  /// **'Traditional Art'**
  String get storyCategoryTraditionalArt;

  /// No description provided for @storyCategoryFolkCustom.
  ///
  /// In en, this message translates to:
  /// **'Folk Custom'**
  String get storyCategoryFolkCustom;

  /// No description provided for @storyCategoryFolkLiterature.
  ///
  /// In en, this message translates to:
  /// **'Folk Literature'**
  String get storyCategoryFolkLiterature;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
