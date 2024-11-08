// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Easily Accessible Routes`
  String get introTitle1 {
    return Intl.message(
      'Easily Accessible Routes',
      name: 'introTitle1',
      desc: 'Title for accessible routes for disabled people',
      args: [],
    );
  }

  /// `Discover specially designed accessible routes for people with disabilities.`
  String get introContent1 {
    return Intl.message(
      'Discover specially designed accessible routes for people with disabilities.',
      name: 'introContent1',
      desc: 'Content about accessible routes for disabled people',
      args: [],
    );
  }

  /// `Discover Accessible Points`
  String get introTitle2 {
    return Intl.message(
      'Discover Accessible Points',
      name: 'introTitle2',
      desc: 'Title about discovering accessible points',
      args: [],
    );
  }

  /// `Find accessible restrooms, markets, and more along the way.`
  String get introContent2 {
    return Intl.message(
      'Find accessible restrooms, markets, and more along the way.',
      name: 'introContent2',
      desc: 'Content about accessible restrooms, markets, and other services',
      args: [],
    );
  }

  /// `Safe and Easy Navigation`
  String get introTitle3 {
    return Intl.message(
      'Safe and Easy Navigation',
      name: 'introTitle3',
      desc: 'Title for safe and easy navigation',
      args: [],
    );
  }

  /// `Plan your trip with curb-friendly and safe routes.`
  String get introContent3 {
    return Intl.message(
      'Plan your trip with curb-friendly and safe routes.',
      name: 'introContent3',
      desc: 'Content about planning a trip with curb-friendly and safe routes',
      args: [],
    );
  }

  /// `Yes`
  String get app_yes {
    return Intl.message(
      'Yes',
      name: 'app_yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get app_no {
    return Intl.message(
      'No',
      name: 'app_no',
      desc: '',
      args: [],
    );
  }

  /// `Turn On Sound`
  String get maps_screen_open_volume {
    return Intl.message(
      'Turn On Sound',
      name: 'maps_screen_open_volume',
      desc: '',
      args: [],
    );
  }

  /// `Turn Off Sound`
  String get maps_screen_closed_volume {
    return Intl.message(
      'Turn Off Sound',
      name: 'maps_screen_closed_volume',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get intro_screen_next_button {
    return Intl.message(
      'Next',
      name: 'intro_screen_next_button',
      desc: '',
      args: [],
    );
  }

  /// `Allow Location`
  String get intro_screen_submit_button {
    return Intl.message(
      'Allow Location',
      name: 'intro_screen_submit_button',
      desc: '',
      args: [],
    );
  }

  /// `Selection Screen`
  String get location_screen_title {
    return Intl.message(
      'Selection Screen',
      name: 'location_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to allow location access?`
  String get location_screen_titles_body {
    return Intl.message(
      'Do you want to allow location access?',
      name: 'location_screen_titles_body',
      desc: '',
      args: [],
    );
  }

  /// `Allow`
  String get location_screen_submit_button {
    return Intl.message(
      'Allow',
      name: 'location_screen_submit_button',
      desc: '',
      args: [],
    );
  }

  /// `Do not allow`
  String get location_screen_unsubmit_button {
    return Intl.message(
      'Do not allow',
      name: 'location_screen_unsubmit_button',
      desc: '',
      args: [],
    );
  }

  /// `Location Permission Required`
  String get location_screen_alert_diaglog_title {
    return Intl.message(
      'Location Permission Required',
      name: 'location_screen_alert_diaglog_title',
      desc: '',
      args: [],
    );
  }

  /// `Location Service Disabled`
  String get location_screen_alert_diaglog_title2 {
    return Intl.message(
      'Location Service Disabled',
      name: 'location_screen_alert_diaglog_title2',
      desc: '',
      args: [],
    );
  }

  /// `The app requires constant location access to function properly.`
  String get location_screen_alert_diaglog_content {
    return Intl.message(
      'The app requires constant location access to function properly.',
      name: 'location_screen_alert_diaglog_content',
      desc: '',
      args: [],
    );
  }

  /// `Your location service must be on for the app to function correctly.`
  String get location_screen_alert_diaglog_content2 {
    return Intl.message(
      'Your location service must be on for the app to function correctly.',
      name: 'location_screen_alert_diaglog_content2',
      desc: '',
      args: [],
    );
  }

  /// `Close the App`
  String get location_screen_alert_diaglog_unsubmit {
    return Intl.message(
      'Close the App',
      name: 'location_screen_alert_diaglog_unsubmit',
      desc: '',
      args: [],
    );
  }

  /// `Accessible Route`
  String get application_title {
    return Intl.message(
      'Accessible Route',
      name: 'application_title',
      desc: '',
      args: [],
    );
  }

  /// `Language successfully changed!`
  String get language_selection {
    return Intl.message(
      'Language successfully changed!',
      name: 'language_selection',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get auth_password_title {
    return Intl.message(
      'Password',
      name: 'auth_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get auth_username_title {
    return Intl.message(
      'Username',
      name: 'auth_username_title',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter Password`
  String get auth_repassword_title {
    return Intl.message(
      'Re-enter Password',
      name: 'auth_repassword_title',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get auth_forgotpassword_title {
    return Intl.message(
      'Forgot Password',
      name: 'auth_forgotpassword_title',
      desc: '',
      args: [],
    );
  }

  /// `Send Password Reset Email`
  String get auth_forgotpassword_submit_button {
    return Intl.message(
      'Send Password Reset Email',
      name: 'auth_forgotpassword_submit_button',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get auth_createAccount_title {
    return Intl.message(
      'Sign Up',
      name: 'auth_createAccount_title',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get auth_signIn_title {
    return Intl.message(
      'Sign In',
      name: 'auth_signIn_title',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get auth_signInWithGoogle_title {
    return Intl.message(
      'Sign in with Google',
      name: 'auth_signInWithGoogle_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get auth_forgotpasswor_inputmail {
    return Intl.message(
      'Enter your email',
      name: 'auth_forgotpasswor_inputmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email for password reset`
  String get auth_forgotpasswor_inputmail_content {
    return Intl.message(
      'Please enter your email for password reset',
      name: 'auth_forgotpasswor_inputmail_content',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email.`
  String get forgot_password_wrong1 {
    return Intl.message(
      'Please enter a valid email.',
      name: 'forgot_password_wrong1',
      desc: '',
      args: [],
    );
  }

  /// `The password must be at least 6 characters.`
  String get forgot_password_wrong2 {
    return Intl.message(
      'The password must be at least 6 characters.',
      name: 'forgot_password_wrong2',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get forgot_password_wrong3 {
    return Intl.message(
      'Passwords do not match.',
      name: 'forgot_password_wrong3',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be empty.`
  String get forgot_password_wrong4 {
    return Intl.message(
      'Username cannot be empty.',
      name: 'forgot_password_wrong4',
      desc: '',
      args: [],
    );
  }

  /// `Email sent! Please check your inbox.`
  String get forgot_password_send_success {
    return Intl.message(
      'Email sent! Please check your inbox.',
      name: 'forgot_password_send_success',
      desc: '',
      args: [],
    );
  }

  /// `Error: Password reset email could not be sent.`
  String get forgot_password_unsend_message {
    return Intl.message(
      'Error: Password reset email could not be sent.',
      name: 'forgot_password_unsend_message',
      desc: '',
      args: [],
    );
  }

  /// `Admin Panel`
  String get admin_panel_title {
    return Intl.message(
      'Admin Panel',
      name: 'admin_panel_title',
      desc: '',
      args: [],
    );
  }

  /// `User Management`
  String get admin_user_management_title {
    return Intl.message(
      'User Management',
      name: 'admin_user_management_title',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get admin_user_management_user {
    return Intl.message(
      'User',
      name: 'admin_user_management_user',
      desc: '',
      args: [],
    );
  }

  /// `Edit User`
  String get admin_user_edit_title {
    return Intl.message(
      'Edit User',
      name: 'admin_user_edit_title',
      desc: '',
      args: [],
    );
  }

  /// `Edit User`
  String get admin_user_editAndSave_title {
    return Intl.message(
      'Edit User',
      name: 'admin_user_editAndSave_title',
      desc: '',
      args: [],
    );
  }

  /// `Grant Admin Privileges`
  String get admin_user_management_admin_yetki {
    return Intl.message(
      'Grant Admin Privileges',
      name: 'admin_user_management_admin_yetki',
      desc: '',
      args: [],
    );
  }

  /// `You can grant/revoke admin privileges for this user.`
  String get admin_user_management_admin_yetki_content {
    return Intl.message(
      'You can grant/revoke admin privileges for this user.',
      name: 'admin_user_management_admin_yetki_content',
      desc: '',
      args: [],
    );
  }

  /// `Freeze Account`
  String get admin_user_management_dondurma_yetki {
    return Intl.message(
      'Freeze Account',
      name: 'admin_user_management_dondurma_yetki',
      desc: '',
      args: [],
    );
  }

  /// `You can freeze or activate the user’s account.`
  String get admin_user_management_dondurma_yetki_content {
    return Intl.message(
      'You can freeze or activate the user’s account.',
      name: 'admin_user_management_dondurma_yetki_content',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get admin_reports_title {
    return Intl.message(
      'Reports',
      name: 'admin_reports_title',
      desc: '',
      args: [],
    );
  }

  /// `Total Number of Users`
  String get admin_reports_total_user {
    return Intl.message(
      'Total Number of Users',
      name: 'admin_reports_total_user',
      desc: '',
      args: [],
    );
  }

  /// `Total Number of Places`
  String get admin_reports_total_place {
    return Intl.message(
      'Total Number of Places',
      name: 'admin_reports_total_place',
      desc: '',
      args: [],
    );
  }

  /// `Average App Usage Time`
  String get admin_reports_average_app {
    return Intl.message(
      'Average App Usage Time',
      name: 'admin_reports_average_app',
      desc: '',
      args: [],
    );
  }

  /// `App Usage Time by Users`
  String get admin_reports_average_app_user {
    return Intl.message(
      'App Usage Time by Users',
      name: 'admin_reports_average_app_user',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get admin_settigs_title {
    return Intl.message(
      'Settings',
      name: 'admin_settigs_title',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get admin_settigs_dark_mode_title {
    return Intl.message(
      'Dark Mode',
      name: 'admin_settigs_dark_mode_title',
      desc: '',
      args: [],
    );
  }

  /// `Switch the app to dark mode`
  String get admin_settigs_dark_mode_content {
    return Intl.message(
      'Switch the app to dark mode',
      name: 'admin_settigs_dark_mode_content',
      desc: '',
      args: [],
    );
  }

  /// `Language Settings`
  String get admin_settigs_language_title {
    return Intl.message(
      'Language Settings',
      name: 'admin_settigs_language_title',
      desc: '',
      args: [],
    );
  }

  /// `Change the app's language`
  String get admin_settigs_language_content {
    return Intl.message(
      'Change the app\'s language',
      name: 'admin_settigs_language_content',
      desc: '',
      args: [],
    );
  }

  /// `Feedbacks`
  String get admin_feedback_all_title {
    return Intl.message(
      'Feedbacks',
      name: 'admin_feedback_all_title',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get admin_feedback_all_title_user {
    return Intl.message(
      'User',
      name: 'admin_feedback_all_title_user',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get admin_feedback_all_title_user_feedback {
    return Intl.message(
      'Feedback',
      name: 'admin_feedback_all_title_user_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Write your response here...`
  String get admin_feedback_all_title_user_feedback_textfiled_content {
    return Intl.message(
      'Write your response here...',
      name: 'admin_feedback_all_title_user_feedback_textfiled_content',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get admin_feedback_all_title_user_feedback_send_button {
    return Intl.message(
      'Reply',
      name: 'admin_feedback_all_title_user_feedback_send_button',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to log out?`
  String get admin_panel_logout_title {
    return Intl.message(
      'Do you want to log out?',
      name: 'admin_panel_logout_title',
      desc: '',
      args: [],
    );
  }

  /// `If you log out, all your progress will be lost. Do you want to continue?`
  String get admin_panel_logout_content {
    return Intl.message(
      'If you log out, all your progress will be lost. Do you want to continue?',
      name: 'admin_panel_logout_content',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get user_bottom_home {
    return Intl.message(
      'Home',
      name: 'user_bottom_home',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get user_bottom_calender {
    return Intl.message(
      'Calendar',
      name: 'user_bottom_calender',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get user_bottom_search {
    return Intl.message(
      'Search',
      name: 'user_bottom_search',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get user_bottom_profile {
    return Intl.message(
      'Profile',
      name: 'user_bottom_profile',
      desc: '',
      args: [],
    );
  }

  /// `Discover Places`
  String get user_allview_screen_title {
    return Intl.message(
      'Discover Places',
      name: 'user_allview_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Discover`
  String get user_discover_title {
    return Intl.message(
      'Discover',
      name: 'user_discover_title',
      desc: '',
      args: [],
    );
  }

  /// `Popular`
  String get user_discover_title_row_1 {
    return Intl.message(
      'Popular',
      name: 'user_discover_title_row_1',
      desc: '',
      args: [],
    );
  }

  /// `Featured`
  String get user_discover_title_row_2 {
    return Intl.message(
      'Featured',
      name: 'user_discover_title_row_2',
      desc: '',
      args: [],
    );
  }

  /// `Most Visited`
  String get user_discover_title_row_3 {
    return Intl.message(
      'Most Visited',
      name: 'user_discover_title_row_3',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get user_discover_recommend_title {
    return Intl.message(
      'Recommended',
      name: 'user_discover_recommend_title',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get user_discover_view_all_title {
    return Intl.message(
      'View All',
      name: 'user_discover_view_all_title',
      desc: '',
      args: [],
    );
  }

  /// `There is no event today.`
  String get user_calender_content {
    return Intl.message(
      'There is no event today.',
      name: 'user_calender_content',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get user_search_textfield_content {
    return Intl.message(
      'Search...',
      name: 'user_search_textfield_content',
      desc: '',
      args: [],
    );
  }

  /// `Can't find the place you're looking for? Let's start searching!`
  String get user_search_content {
    return Intl.message(
      'Can\'t find the place you\'re looking for? Let\'s start searching!',
      name: 'user_search_content',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get user_profile_title {
    return Intl.message(
      'My Profile',
      name: 'user_profile_title',
      desc: '',
      args: [],
    );
  }

  /// `Hi`
  String get user_profile_hi {
    return Intl.message(
      'Hi',
      name: 'user_profile_hi',
      desc: '',
      args: [],
    );
  }

  /// `User Information`
  String get user_profile_personal_information_title {
    return Intl.message(
      'User Information',
      name: 'user_profile_personal_information_title',
      desc: '',
      args: [],
    );
  }

  /// `Frequently Asked Questions`
  String get user_profile_faq_title {
    return Intl.message(
      'Frequently Asked Questions',
      name: 'user_profile_faq_title',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get user_profile_darkmode_title {
    return Intl.message(
      'Dark Mode',
      name: 'user_profile_darkmode_title',
      desc: '',
      args: [],
    );
  }

  /// `Language Settings`
  String get user_profile_language_title {
    return Intl.message(
      'Language Settings',
      name: 'user_profile_language_title',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get user_profile_feedback_title {
    return Intl.message(
      'Feedback',
      name: 'user_profile_feedback_title',
      desc: '',
      args: [],
    );
  }

  /// `Your feedback has been submitted`
  String get user_profile_feedback_title_submit {
    return Intl.message(
      'Your feedback has been submitted',
      name: 'user_profile_feedback_title_submit',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get user_profile_logout_title {
    return Intl.message(
      'Log Out',
      name: 'user_profile_logout_title',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to log out?`
  String get user_profile_logout_show_title {
    return Intl.message(
      'Do you want to log out?',
      name: 'user_profile_logout_show_title',
      desc: '',
      args: [],
    );
  }

  /// `If you log out, all your progress will be lost. Do you want to continue?`
  String get user_profile_logout_show_title_content {
    return Intl.message(
      'If you log out, all your progress will be lost. Do you want to continue?',
      name: 'user_profile_logout_show_title_content',
      desc: '',
      args: [],
    );
  }

  /// `Location Permission Denied`
  String get location_permission_denied {
    return Intl.message(
      'Location Permission Denied',
      name: 'location_permission_denied',
      desc: '',
      args: [],
    );
  }

  /// `Please allow location permission in the settings.`
  String get please_allow_permission_in_settings {
    return Intl.message(
      'Please allow location permission in the settings.',
      name: 'please_allow_permission_in_settings',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get open_settings {
    return Intl.message(
      'Open Settings',
      name: 'open_settings',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get search_hint {
    return Intl.message(
      'Search...',
      name: 'search_hint',
      desc: '',
      args: [],
    );
  }

  /// `No results found. Please check your search terms.`
  String get no_results_found {
    return Intl.message(
      'No results found. Please check your search terms.',
      name: 'no_results_found',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have a place to search? Let’s get started!`
  String get no_place_to_search {
    return Intl.message(
      'Don’t have a place to search? Let’s get started!',
      name: 'no_place_to_search',
      desc: '',
      args: [],
    );
  }

  /// `Place Details`
  String get user_place_screen_title {
    return Intl.message(
      'Place Details',
      name: 'user_place_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Start Route`
  String get user_place_screen_route_start_button {
    return Intl.message(
      'Start Route',
      name: 'user_place_screen_route_start_button',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get user_profile_screen_displayname_title {
    return Intl.message(
      'Full Name',
      name: 'user_profile_screen_displayname_title',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get user_profile_screen_phoneNumber_title {
    return Intl.message(
      'Phone Number',
      name: 'user_profile_screen_phoneNumber_title',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get user_profile_screen_address_title {
    return Intl.message(
      'Address',
      name: 'user_profile_screen_address_title',
      desc: '',
      args: [],
    );
  }

  /// `Education Level`
  String get user_profile_screen_educationLevel_title {
    return Intl.message(
      'Education Level',
      name: 'user_profile_screen_educationLevel_title',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme Settings`
  String get user_dark_mode_screen_title {
    return Intl.message(
      'Dark Theme Settings',
      name: 'user_dark_mode_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get user_dark_mode_screen_appearance {
    return Intl.message(
      'Appearance',
      name: 'user_dark_mode_screen_appearance',
      desc: '',
      args: [],
    );
  }

  /// `Enable Dark Theme`
  String get user_dark_mode_screen_title_content1 {
    return Intl.message(
      'Enable Dark Theme',
      name: 'user_dark_mode_screen_title_content1',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme is currently disabled. Enjoy the light theme!`
  String get user_dark_mode_screen_title_content2 {
    return Intl.message(
      'Dark theme is currently disabled. Enjoy the light theme!',
      name: 'user_dark_mode_screen_title_content2',
      desc: '',
      args: [],
    );
  }

  /// `Language Settings`
  String get user_language_screen_title {
    return Intl.message(
      'Language Settings',
      name: 'user_language_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Choose Language`
  String get user_language_screen_title_content {
    return Intl.message(
      'Choose Language',
      name: 'user_language_screen_title_content',
      desc: '',
      args: [],
    );
  }

  /// `Language changed!`
  String get user_language_screen_title_content_complete {
    return Intl.message(
      'Language changed!',
      name: 'user_language_screen_title_content_complete',
      desc: '',
      args: [],
    );
  }

  /// `Send us your feedback`
  String get user_feedback_screen_titles {
    return Intl.message(
      'Send us your feedback',
      name: 'user_feedback_screen_titles',
      desc: '',
      args: [],
    );
  }

  /// `Write your feedback here...`
  String get user_feedback_screen_textfield_content {
    return Intl.message(
      'Write your feedback here...',
      name: 'user_feedback_screen_textfield_content',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get user_feedback_screen_send_button_title {
    return Intl.message(
      'Send',
      name: 'user_feedback_screen_send_button_title',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been frozen. You can send feedback for more information.`
  String get frozenscreen_frozen_title_content {
    return Intl.message(
      'Your account has been frozen. You can send feedback for more information.',
      name: 'frozenscreen_frozen_title_content',
      desc: '',
      args: [],
    );
  }

  /// `Your Account is Frozen`
  String get frozenscreen_frozen_title {
    return Intl.message(
      'Your Account is Frozen',
      name: 'frozenscreen_frozen_title',
      desc: '',
      args: [],
    );
  }

  /// `How can I use the route app?`
  String get faq_question_1 {
    return Intl.message(
      'How can I use the route app?',
      name: 'faq_question_1',
      desc: '',
      args: [],
    );
  }

  /// `The Route app is designed to make it easier for disabled individuals to access certain points. You can select a location from your main screen and receive recommendations like restrooms and markets along the way.`
  String get faq_answer_1 {
    return Intl.message(
      'The Route app is designed to make it easier for disabled individuals to access certain points. You can select a location from your main screen and receive recommendations like restrooms and markets along the way.',
      name: 'faq_answer_1',
      desc: '',
      args: [],
    );
  }

  /// `Which places are available in the app?`
  String get faq_question_2 {
    return Intl.message(
      'Which places are available in the app?',
      name: 'faq_question_2',
      desc: '',
      args: [],
    );
  }

  /// `The app offers various places including mosques, museums, and cultural sites.`
  String get faq_answer_2 {
    return Intl.message(
      'The app offers various places including mosques, museums, and cultural sites.',
      name: 'faq_answer_2',
      desc: '',
      args: [],
    );
  }

  /// `I forgot my password, what should I do?`
  String get faq_question_3 {
    return Intl.message(
      'I forgot my password, what should I do?',
      name: 'faq_question_3',
      desc: '',
      args: [],
    );
  }

  /// `You can click on the 'Forgot my password' option on the login screen, enter your email, and receive a password reset link. Please check your spam folder if you don't see the email.`
  String get faq_answer_3 {
    return Intl.message(
      'You can click on the \'Forgot my password\' option on the login screen, enter your email, and receive a password reset link. Please check your spam folder if you don\'t see the email.',
      name: 'faq_answer_3',
      desc: '',
      args: [],
    );
  }

  /// `Is the app free?`
  String get faq_question_4 {
    return Intl.message(
      'Is the app free?',
      name: 'faq_question_4',
      desc: '',
      args: [],
    );
  }

  /// `Yes, the app is completely free. However, there are optional in-app purchases for extra features.`
  String get faq_answer_4 {
    return Intl.message(
      'Yes, the app is completely free. However, there are optional in-app purchases for extra features.',
      name: 'faq_answer_4',
      desc: '',
      args: [],
    );
  }

  /// `What should I do if I experience a problem?`
  String get faq_question_5 {
    return Intl.message(
      'What should I do if I experience a problem?',
      name: 'faq_question_5',
      desc: '',
      args: [],
    );
  }

  /// `If you experience any problems, you can send feedback directly through the app without needing to fill out a form.`
  String get faq_answer_5 {
    return Intl.message(
      'If you experience any problems, you can send feedback directly through the app without needing to fill out a form.',
      name: 'faq_answer_5',
      desc: '',
      args: [],
    );
  }

  /// `What languages does the app support?`
  String get faq_question_6 {
    return Intl.message(
      'What languages does the app support?',
      name: 'faq_question_6',
      desc: '',
      args: [],
    );
  }

  /// `The app supports both English and Turkish.`
  String get faq_answer_6 {
    return Intl.message(
      'The app supports both English and Turkish.',
      name: 'faq_answer_6',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to end the route?`
  String get maps_screen_end_route_button_submit {
    return Intl.message(
      'Do you want to end the route?',
      name: 'maps_screen_end_route_button_submit',
      desc: '',
      args: [],
    );
  }

  /// `End Route`
  String get maps_screen_end_route_button_submit2 {
    return Intl.message(
      'End Route',
      name: 'maps_screen_end_route_button_submit2',
      desc: '',
      args: [],
    );
  }

  /// `Please follow this order:`
  String get maps_screen_follow_route {
    return Intl.message(
      'Please follow this order:',
      name: 'maps_screen_follow_route',
      desc: '',
      args: [],
    );
  }

  /// `Return to Home`
  String get route_complete_submit_button {
    return Intl.message(
      'Return to Home',
      name: 'route_complete_submit_button',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations!`
  String get route_complete_tebrik {
    return Intl.message(
      'Congratulations!',
      name: 'route_complete_tebrik',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully completed the route.`
  String get route_complete_content {
    return Intl.message(
      'You have successfully completed the route.',
      name: 'route_complete_content',
      desc: '',
      args: [],
    );
  }

  /// `You are here`
  String get route_complete_locations {
    return Intl.message(
      'You are here',
      name: 'route_complete_locations',
      desc: '',
      args: [],
    );
  }

  /// `Route Completed`
  String get route_complete_title {
    return Intl.message(
      'Route Completed',
      name: 'route_complete_title',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get color_red {
    return Intl.message(
      'Red',
      name: 'color_red',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get color_blue {
    return Intl.message(
      'Blue',
      name: 'color_blue',
      desc: '',
      args: [],
    );
  }

  /// `Yellow`
  String get color_yellow {
    return Intl.message(
      'Yellow',
      name: 'color_yellow',
      desc: '',
      args: [],
    );
  }

  /// `Orange`
  String get color_turuncu {
    return Intl.message(
      'Orange',
      name: 'color_turuncu',
      desc: '',
      args: [],
    );
  }

  /// `Black`
  String get color_black {
    return Intl.message(
      'Black',
      name: 'color_black',
      desc: '',
      args: [],
    );
  }

  /// `Calculating...`
  String get app_calculate {
    return Intl.message(
      'Calculating...',
      name: 'app_calculate',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
