import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('fa'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'RepairAI'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @schematic.
  ///
  /// In en, this message translates to:
  /// **'Schematic'**
  String get schematic;

  /// No description provided for @solutions.
  ///
  /// In en, this message translates to:
  /// **'Solutions'**
  String get solutions;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @searchSchematics.
  ///
  /// In en, this message translates to:
  /// **'Search schematics...'**
  String get searchSchematics;

  /// No description provided for @searchSolutions.
  ///
  /// In en, this message translates to:
  /// **'Search solutions...'**
  String get searchSolutions;

  /// No description provided for @noSchematicsFound.
  ///
  /// In en, this message translates to:
  /// **'No schematics found'**
  String get noSchematicsFound;

  /// No description provided for @noSolutionsFound.
  ///
  /// In en, this message translates to:
  /// **'No solutions found'**
  String get noSolutionsFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @viewFullScreen.
  ///
  /// In en, this message translates to:
  /// **'View Full Screen'**
  String get viewFullScreen;

  /// No description provided for @aiIndex.
  ///
  /// In en, this message translates to:
  /// **'AI Index'**
  String get aiIndex;

  /// No description provided for @relatedImages.
  ///
  /// In en, this message translates to:
  /// **'Related Images'**
  String get relatedImages;

  /// No description provided for @viewFullSolution.
  ///
  /// In en, this message translates to:
  /// **'View Full Solution'**
  String get viewFullSolution;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'👋 Welcome to RepairAI Chat!'**
  String get welcomeMessage;

  /// No description provided for @welcomeContent.
  ///
  /// In en, this message translates to:
  /// **'To get started, please configure your AI API key in Settings:\n1. Go to Settings (bottom right)\n2. Add your Gemini or OpenRouter API key\n3. Return here to start chatting'**
  String get welcomeContent;

  /// No description provided for @repairHelp.
  ///
  /// In en, this message translates to:
  /// **'I\'m here to help with:\n• Device repair problems and solutions\n• Technical questions about electronics\n• Schematic interpretations\n• Troubleshooting tips'**
  String get repairHelp;

  /// No description provided for @startConversation.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation'**
  String get startConversation;

  /// No description provided for @configureApiKey.
  ///
  /// In en, this message translates to:
  /// **'Configure your API key in Settings first'**
  String get configureApiKey;

  /// No description provided for @askAboutRepairs.
  ///
  /// In en, this message translates to:
  /// **'Ask me about device repairs'**
  String get askAboutRepairs;

  /// No description provided for @clearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat?'**
  String get clearChat;

  /// No description provided for @clearChatMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all messages in this conversation.'**
  String get clearChatMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @deleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete conversation'**
  String get deleteConversation;

  /// No description provided for @apiKeys.
  ///
  /// In en, this message translates to:
  /// **'API Keys'**
  String get apiKeys;

  /// No description provided for @geminiApiKey.
  ///
  /// In en, this message translates to:
  /// **'Google Gemini API Key'**
  String get geminiApiKey;

  /// No description provided for @openRouterApiKey.
  ///
  /// In en, this message translates to:
  /// **'OpenRouter API Key'**
  String get openRouterApiKey;

  /// No description provided for @enterApiKey.
  ///
  /// In en, this message translates to:
  /// **'Enter your API key'**
  String get enterApiKey;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open Source'**
  String get openSource;

  /// No description provided for @communityDriven.
  ///
  /// In en, this message translates to:
  /// **'Community Driven'**
  String get communityDriven;

  /// No description provided for @contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contribute;

  /// No description provided for @submitSchematic.
  ///
  /// In en, this message translates to:
  /// **'Submit Schematic'**
  String get submitSchematic;

  /// No description provided for @submitSolution.
  ///
  /// In en, this message translates to:
  /// **'Submit Solution'**
  String get submitSolution;

  /// No description provided for @submitIdea.
  ///
  /// In en, this message translates to:
  /// **'Submit Ideas'**
  String get submitIdea;

  /// No description provided for @shareSchematics.
  ///
  /// In en, this message translates to:
  /// **'Share circuit diagrams with the community'**
  String get shareSchematics;

  /// No description provided for @shareSolutions.
  ///
  /// In en, this message translates to:
  /// **'Share repair solutions and guides'**
  String get shareSolutions;

  /// No description provided for @suggestFeatures.
  ///
  /// In en, this message translates to:
  /// **'Suggest new features and improvements'**
  String get suggestFeatures;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github;

  /// No description provided for @viewOnGithub.
  ///
  /// In en, this message translates to:
  /// **'View on GitHub'**
  String get viewOnGithub;

  /// No description provided for @contributeViaPr.
  ///
  /// In en, this message translates to:
  /// **'Contribute via PR'**
  String get contributeViaPr;

  /// No description provided for @reportIssues.
  ///
  /// In en, this message translates to:
  /// **'Report Issues'**
  String get reportIssues;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @submitContent.
  ///
  /// In en, this message translates to:
  /// **'To submit content to RepairAI:'**
  String get submitContent;

  /// No description provided for @forkRepo.
  ///
  /// In en, this message translates to:
  /// **'Fork the GitHub repository'**
  String get forkRepo;

  /// No description provided for @addContent.
  ///
  /// In en, this message translates to:
  /// **'Add your content to the data folder'**
  String get addContent;

  /// No description provided for @submitPullRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit a Pull Request'**
  String get submitPullRequest;

  /// No description provided for @reviewAndMerge.
  ///
  /// In en, this message translates to:
  /// **'Our team will review and merge'**
  String get reviewAndMerge;

  /// No description provided for @alternativeSubmit.
  ///
  /// In en, this message translates to:
  /// **'Alternatively, you can submit through the app and our team will help process it.'**
  String get alternativeSubmit;

  /// No description provided for @goToGithub.
  ///
  /// In en, this message translates to:
  /// **'Go to GitHub'**
  String get goToGithub;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @cache.
  ///
  /// In en, this message translates to:
  /// **'Cache'**
  String get cache;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get cacheCleared;

  /// No description provided for @defaultModel.
  ///
  /// In en, this message translates to:
  /// **'Default AI Model'**
  String get defaultModel;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @persian.
  ///
  /// In en, this message translates to:
  /// **'Persian (Farsi)'**
  String get persian;
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
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
