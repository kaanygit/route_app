import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// Title for accessible routes for disabled people
  ///
  /// In en, this message translates to:
  /// **'Easily Accessible Routes'**
  String get introTitle1;

  /// Content about accessible routes for disabled people
  ///
  /// In en, this message translates to:
  /// **'Discover specially designed accessible routes for people with disabilities.'**
  String get introContent1;

  /// Title about discovering accessible points
  ///
  /// In en, this message translates to:
  /// **'Discover Accessible Points'**
  String get introTitle2;

  /// Content about accessible restrooms, markets, and other services
  ///
  /// In en, this message translates to:
  /// **'Find accessible restrooms, markets, and more along the way.'**
  String get introContent2;

  /// Title for safe and easy navigation
  ///
  /// In en, this message translates to:
  /// **'Safe and Easy Navigation'**
  String get introTitle3;

  /// Content about planning a trip with curb-friendly and safe routes
  ///
  /// In en, this message translates to:
  /// **'Plan your trip with curb-friendly and safe routes.'**
  String get introContent3;

  /// No description provided for @app_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get app_yes;

  /// No description provided for @app_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get app_no;

  /// No description provided for @intro_screen_next_button.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get intro_screen_next_button;

  /// No description provided for @intro_screen_submit_button.
  ///
  /// In en, this message translates to:
  /// **'Allow Location'**
  String get intro_screen_submit_button;

  /// No description provided for @location_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Selection Screen'**
  String get location_screen_title;

  /// No description provided for @location_screen_titles_body.
  ///
  /// In en, this message translates to:
  /// **'Do you want to allow location access?'**
  String get location_screen_titles_body;

  /// No description provided for @location_screen_submit_button.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get location_screen_submit_button;

  /// No description provided for @location_screen_unsubmit_button.
  ///
  /// In en, this message translates to:
  /// **'Do not allow'**
  String get location_screen_unsubmit_button;

  /// No description provided for @location_screen_alert_diaglog_title.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get location_screen_alert_diaglog_title;

  /// No description provided for @location_screen_alert_diaglog_title2.
  ///
  /// In en, this message translates to:
  /// **'Location Service Disabled'**
  String get location_screen_alert_diaglog_title2;

  /// No description provided for @location_screen_alert_diaglog_content.
  ///
  /// In en, this message translates to:
  /// **'The app requires constant location access to function properly.'**
  String get location_screen_alert_diaglog_content;

  /// No description provided for @location_screen_alert_diaglog_content2.
  ///
  /// In en, this message translates to:
  /// **'Your location service must be on for the app to function correctly.'**
  String get location_screen_alert_diaglog_content2;

  /// No description provided for @location_screen_alert_diaglog_unsubmit.
  ///
  /// In en, this message translates to:
  /// **'Close the App'**
  String get location_screen_alert_diaglog_unsubmit;

  /// No description provided for @application_title.
  ///
  /// In en, this message translates to:
  /// **'Accessible Route'**
  String get application_title;

  /// No description provided for @language_selection.
  ///
  /// In en, this message translates to:
  /// **'Language successfully changed!'**
  String get language_selection;

  /// No description provided for @auth_password_title.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password_title;

  /// No description provided for @auth_username_title.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get auth_username_title;

  /// No description provided for @auth_repassword_title.
  ///
  /// In en, this message translates to:
  /// **'Re-enter Password'**
  String get auth_repassword_title;

  /// No description provided for @auth_forgotpassword_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get auth_forgotpassword_title;

  /// No description provided for @auth_forgotpassword_submit_button.
  ///
  /// In en, this message translates to:
  /// **'Send Password Reset Email'**
  String get auth_forgotpassword_submit_button;

  /// No description provided for @auth_createAccount_title.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get auth_createAccount_title;

  /// No description provided for @auth_signIn_title.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get auth_signIn_title;

  /// No description provided for @auth_signInWithGoogle_title.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get auth_signInWithGoogle_title;

  /// No description provided for @auth_forgotpasswor_inputmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get auth_forgotpasswor_inputmail;

  /// No description provided for @auth_forgotpasswor_inputmail_content.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email for password reset'**
  String get auth_forgotpasswor_inputmail_content;

  /// No description provided for @forgot_password_wrong1.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email.'**
  String get forgot_password_wrong1;

  /// No description provided for @forgot_password_wrong2.
  ///
  /// In en, this message translates to:
  /// **'The password must be at least 6 characters.'**
  String get forgot_password_wrong2;

  /// No description provided for @forgot_password_wrong3.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get forgot_password_wrong3;

  /// No description provided for @forgot_password_wrong4.
  ///
  /// In en, this message translates to:
  /// **'Username cannot be empty.'**
  String get forgot_password_wrong4;

  /// No description provided for @forgot_password_send_success.
  ///
  /// In en, this message translates to:
  /// **'Email sent! Please check your inbox.'**
  String get forgot_password_send_success;

  /// No description provided for @forgot_password_unsend_message.
  ///
  /// In en, this message translates to:
  /// **'Error: Password reset email could not be sent.'**
  String get forgot_password_unsend_message;

  /// No description provided for @admin_panel_title.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get admin_panel_title;

  /// No description provided for @admin_user_management_title.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get admin_user_management_title;

  /// No description provided for @admin_user_management_user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get admin_user_management_user;

  /// No description provided for @admin_user_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get admin_user_edit_title;

  /// No description provided for @admin_user_editAndSave_title.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get admin_user_editAndSave_title;

  /// No description provided for @admin_user_management_admin_yetki.
  ///
  /// In en, this message translates to:
  /// **'Grant Admin Privileges'**
  String get admin_user_management_admin_yetki;

  /// No description provided for @admin_user_management_admin_yetki_content.
  ///
  /// In en, this message translates to:
  /// **'You can grant/revoke admin privileges for this user.'**
  String get admin_user_management_admin_yetki_content;

  /// No description provided for @admin_user_management_dondurma_yetki.
  ///
  /// In en, this message translates to:
  /// **'Freeze Account'**
  String get admin_user_management_dondurma_yetki;

  /// No description provided for @admin_user_management_dondurma_yetki_content.
  ///
  /// In en, this message translates to:
  /// **'You can freeze or activate the user’s account.'**
  String get admin_user_management_dondurma_yetki_content;

  /// No description provided for @admin_reports_title.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get admin_reports_title;

  /// No description provided for @admin_reports_total_user.
  ///
  /// In en, this message translates to:
  /// **'Total Number of Users'**
  String get admin_reports_total_user;

  /// No description provided for @admin_reports_total_place.
  ///
  /// In en, this message translates to:
  /// **'Total Number of Places'**
  String get admin_reports_total_place;

  /// No description provided for @admin_reports_average_app.
  ///
  /// In en, this message translates to:
  /// **'Average App Usage Time'**
  String get admin_reports_average_app;

  /// No description provided for @admin_reports_average_app_user.
  ///
  /// In en, this message translates to:
  /// **'App Usage Time by Users'**
  String get admin_reports_average_app_user;

  /// No description provided for @admin_settigs_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get admin_settigs_title;

  /// No description provided for @admin_settigs_dark_mode_title.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get admin_settigs_dark_mode_title;

  /// No description provided for @admin_settigs_dark_mode_content.
  ///
  /// In en, this message translates to:
  /// **'Switch the app to dark mode'**
  String get admin_settigs_dark_mode_content;

  /// No description provided for @admin_settigs_language_title.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get admin_settigs_language_title;

  /// No description provided for @admin_settigs_language_content.
  ///
  /// In en, this message translates to:
  /// **'Change the app\'s language'**
  String get admin_settigs_language_content;

  /// No description provided for @admin_feedback_all_title.
  ///
  /// In en, this message translates to:
  /// **'Feedbacks'**
  String get admin_feedback_all_title;

  /// No description provided for @admin_feedback_all_title_user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get admin_feedback_all_title_user;

  /// No description provided for @admin_feedback_all_title_user_feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get admin_feedback_all_title_user_feedback;

  /// No description provided for @admin_feedback_all_title_user_feedback_textfiled_content.
  ///
  /// In en, this message translates to:
  /// **'Write your response here...'**
  String get admin_feedback_all_title_user_feedback_textfiled_content;

  /// No description provided for @admin_feedback_all_title_user_feedback_send_button.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get admin_feedback_all_title_user_feedback_send_button;

  /// No description provided for @admin_panel_logout_title.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log out?'**
  String get admin_panel_logout_title;

  /// No description provided for @admin_panel_logout_content.
  ///
  /// In en, this message translates to:
  /// **'If you log out, all your progress will be lost. Do you want to continue?'**
  String get admin_panel_logout_content;

  /// No description provided for @user_bottom_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get user_bottom_home;

  /// No description provided for @user_bottom_calender.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get user_bottom_calender;

  /// No description provided for @user_bottom_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get user_bottom_search;

  /// No description provided for @user_bottom_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get user_bottom_profile;

  /// No description provided for @user_allview_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Discover Places'**
  String get user_allview_screen_title;

  /// No description provided for @user_discover_title.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get user_discover_title;

  /// No description provided for @user_discover_title_row_1.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get user_discover_title_row_1;

  /// No description provided for @user_discover_title_row_2.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get user_discover_title_row_2;

  /// No description provided for @user_discover_title_row_3.
  ///
  /// In en, this message translates to:
  /// **'Most Visited'**
  String get user_discover_title_row_3;

  /// No description provided for @user_discover_recommend_title.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get user_discover_recommend_title;

  /// No description provided for @user_discover_view_all_title.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get user_discover_view_all_title;

  /// No description provided for @user_calender_content.
  ///
  /// In en, this message translates to:
  /// **'There is no event today.'**
  String get user_calender_content;

  /// No description provided for @user_search_textfield_content.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get user_search_textfield_content;

  /// No description provided for @user_search_content.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find the place you\'re looking for? Let\'s start searching!'**
  String get user_search_content;

  /// No description provided for @user_profile_title.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get user_profile_title;

  /// No description provided for @user_profile_hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get user_profile_hi;

  /// No description provided for @user_profile_personal_information_title.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get user_profile_personal_information_title;

  /// No description provided for @user_profile_faq_title.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get user_profile_faq_title;

  /// No description provided for @user_profile_darkmode_title.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get user_profile_darkmode_title;

  /// No description provided for @user_profile_language_title.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get user_profile_language_title;

  /// No description provided for @user_profile_feedback_title.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get user_profile_feedback_title;

  /// No description provided for @user_profile_feedback_title_submit.
  ///
  /// In en, this message translates to:
  /// **'Your feedback has been submitted'**
  String get user_profile_feedback_title_submit;

  /// No description provided for @user_profile_logout_title.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get user_profile_logout_title;

  /// No description provided for @user_profile_logout_show_title.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log out?'**
  String get user_profile_logout_show_title;

  /// No description provided for @user_profile_logout_show_title_content.
  ///
  /// In en, this message translates to:
  /// **'If you log out, all your progress will be lost. Do you want to continue?'**
  String get user_profile_logout_show_title_content;

  /// No description provided for @user_place_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Place Details'**
  String get user_place_screen_title;

  /// No description provided for @user_place_screen_route_start_button.
  ///
  /// In en, this message translates to:
  /// **'Start Route'**
  String get user_place_screen_route_start_button;

  /// No description provided for @user_profile_screen_displayname_title.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get user_profile_screen_displayname_title;

  /// No description provided for @user_profile_screen_phoneNumber_title.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get user_profile_screen_phoneNumber_title;

  /// No description provided for @user_profile_screen_address_title.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get user_profile_screen_address_title;

  /// No description provided for @user_profile_screen_educationLevel_title.
  ///
  /// In en, this message translates to:
  /// **'Education Level'**
  String get user_profile_screen_educationLevel_title;

  /// No description provided for @user_dark_mode_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme Settings'**
  String get user_dark_mode_screen_title;

  /// No description provided for @user_dark_mode_screen_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get user_dark_mode_screen_appearance;

  /// No description provided for @user_dark_mode_screen_title_content1.
  ///
  /// In en, this message translates to:
  /// **'Enable Dark Theme'**
  String get user_dark_mode_screen_title_content1;

  /// No description provided for @user_dark_mode_screen_title_content2.
  ///
  /// In en, this message translates to:
  /// **'Dark theme is currently disabled. Enjoy the light theme!'**
  String get user_dark_mode_screen_title_content2;

  /// No description provided for @user_language_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get user_language_screen_title;

  /// No description provided for @user_language_screen_title_content.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get user_language_screen_title_content;

  /// No description provided for @user_language_screen_title_content_complete.
  ///
  /// In en, this message translates to:
  /// **'Language changed!'**
  String get user_language_screen_title_content_complete;

  /// No description provided for @user_feedback_screen_titles.
  ///
  /// In en, this message translates to:
  /// **'Send us your feedback'**
  String get user_feedback_screen_titles;

  /// No description provided for @user_feedback_screen_textfield_content.
  ///
  /// In en, this message translates to:
  /// **'Write your feedback here...'**
  String get user_feedback_screen_textfield_content;

  /// No description provided for @user_feedback_screen_send_button_title.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get user_feedback_screen_send_button_title;

  /// No description provided for @frozenscreen_frozen_title_content.
  ///
  /// In en, this message translates to:
  /// **'Your account has been frozen. You can send feedback for more information.'**
  String get frozenscreen_frozen_title_content;

  /// No description provided for @frozenscreen_frozen_title.
  ///
  /// In en, this message translates to:
  /// **'Your Account is Frozen'**
  String get frozenscreen_frozen_title;

  /// No description provided for @maps_screen_end_route_button_submit.
  ///
  /// In en, this message translates to:
  /// **'Do you want to end the route?'**
  String get maps_screen_end_route_button_submit;

  /// No description provided for @maps_screen_end_route_button_submit2.
  ///
  /// In en, this message translates to:
  /// **'End Route'**
  String get maps_screen_end_route_button_submit2;

  /// No description provided for @maps_screen_follow_route.
  ///
  /// In en, this message translates to:
  /// **'Please follow this order:'**
  String get maps_screen_follow_route;

  /// No description provided for @route_complete_submit_button.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get route_complete_submit_button;

  /// No description provided for @route_complete_tebrik.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get route_complete_tebrik;

  /// No description provided for @route_complete_content.
  ///
  /// In en, this message translates to:
  /// **'You have successfully completed the route.'**
  String get route_complete_content;

  /// No description provided for @route_complete_title.
  ///
  /// In en, this message translates to:
  /// **'Route Completed'**
  String get route_complete_title;

  /// No description provided for @color_red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get color_red;

  /// No description provided for @color_blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get color_blue;

  /// No description provided for @color_yellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get color_yellow;

  /// No description provided for @color_turuncu.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get color_turuncu;

  /// No description provided for @color_black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get color_black;

  /// No description provided for @app_calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get app_calculate;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
