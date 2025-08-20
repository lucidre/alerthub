import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
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
    Locale('es'),
    Locale('en'),
    Locale('fr'),
    Locale('zh')
  ];

  /// No description provided for @a.
  ///
  /// In en, this message translates to:
  /// **'a'**
  String get a;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully.'**
  String get accountCreated;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get addEvent;

  /// No description provided for @addressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found, something went wrong!'**
  String get addressNotFound;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the'**
  String get agreeToTerms;

  /// No description provided for @alertHub.
  ///
  /// In en, this message translates to:
  /// **'AlertHub'**
  String get alertHub;

  /// No description provided for @alertMode.
  ///
  /// In en, this message translates to:
  /// **'ALERT MODE'**
  String get alertMode;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @castVoteInstruction.
  ///
  /// In en, this message translates to:
  /// **'Kindly cast your vote on whether you find this event accurate or inaccurate. Before voting, make sure to verify all details, including the description and location.'**
  String get castVoteInstruction;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @clearAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Clear all notifications?'**
  String get clearAllNotifications;

  /// No description provided for @clearNotifications.
  ///
  /// In en, this message translates to:
  /// **'Clear Notifications'**
  String get clearNotifications;

  /// No description provided for @clickToSelectImages.
  ///
  /// In en, this message translates to:
  /// **'Click to select image(s)'**
  String get clickToSelectImages;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @communityValidification.
  ///
  /// In en, this message translates to:
  /// **'Community Validification'**
  String get communityValidification;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @continueS.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueS;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'created'**
  String get created;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEvent;

  /// No description provided for @creatorInformation.
  ///
  /// In en, this message translates to:
  /// **'Creator Information'**
  String get creatorInformation;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'This is your current location'**
  String get currentLocation;

  /// No description provided for @dataCannotBeChanged.
  ///
  /// In en, this message translates to:
  /// **'This data cannot be changed.'**
  String get dataCannotBeChanged;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteBar.
  ///
  /// In en, this message translates to:
  /// **'Delete Bar'**
  String get deleteBar;

  /// No description provided for @deleteEvent.
  ///
  /// In en, this message translates to:
  /// **'Delete this event?'**
  String get deleteEvent;

  /// No description provided for @deleteEventDescription.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible.'**
  String get deleteEventDescription;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @disableCheckboxEndDate.
  ///
  /// In en, this message translates to:
  /// **'Kindly disable the checkbox below to select an end date'**
  String get disableCheckboxEndDate;

  /// No description provided for @disableCheckboxStartDate.
  ///
  /// In en, this message translates to:
  /// **'Kindly disable the checkbox below to select a start date'**
  String get disableCheckboxStartDate;

  /// No description provided for @discoverEvents.
  ///
  /// In en, this message translates to:
  /// **'Discover events around you.'**
  String get discoverEvents;

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get editEvent;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmailAddress;

  /// No description provided for @enterEmailToRecoverAccount.
  ///
  /// In en, this message translates to:
  /// **'Enter the email associated with your account to recover your account.'**
  String get enterEmailToRecoverAccount;

  /// No description provided for @enterEventDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter event description'**
  String get enterEventDescription;

  /// No description provided for @enterEventLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter event location'**
  String get enterEventLocation;

  /// No description provided for @enterEventName.
  ///
  /// In en, this message translates to:
  /// **'Enter event name'**
  String get enterEventName;

  /// No description provided for @enterEventNameOrLocation.
  ///
  /// In en, this message translates to:
  /// **'Kindly enter an event name or location to search.'**
  String get enterEventNameOrLocation;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name.'**
  String get enterFullName;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Kindly enter a valid email.'**
  String get enterValidEmail;

  /// No description provided for @enterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Kindly enter a valid phone number.'**
  String get enterValidPhoneNumber;

  /// No description provided for @errorFetchingProfile.
  ///
  /// In en, this message translates to:
  /// **'An error occurred fetching your profile. Kindly refresh this page'**
  String get errorFetchingProfile;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while picking the image.'**
  String get errorPickingImage;

  /// No description provided for @eventAccurate.
  ///
  /// In en, this message translates to:
  /// **'Event accurate'**
  String get eventAccurate;

  /// No description provided for @eventComments.
  ///
  /// In en, this message translates to:
  /// **'Event Comments'**
  String get eventComments;

  /// No description provided for @eventCreated.
  ///
  /// In en, this message translates to:
  /// **'Your event has been created'**
  String get eventCreated;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Event date'**
  String get eventDate;

  /// No description provided for @eventHasBeen.
  ///
  /// In en, this message translates to:
  /// **'Your event has been'**
  String get eventHasBeen;

  /// No description provided for @eventInaccurate.
  ///
  /// In en, this message translates to:
  /// **'Event inaccurate'**
  String get eventInaccurate;

  /// No description provided for @eventLocation.
  ///
  /// In en, this message translates to:
  /// **'Event Location'**
  String get eventLocation;

  /// No description provided for @eventPriority.
  ///
  /// In en, this message translates to:
  /// **'Event Priority'**
  String get eventPriority;

  /// No description provided for @eventValidity.
  ///
  /// In en, this message translates to:
  /// **'Event Validity'**
  String get eventValidity;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Image(s)'**
  String get images;

  /// No description provided for @informationAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Kindly make sure the information you provide is accurate. Once your event is uploaded, it will be verified by other users. If it is found to be false, it will be removed.'**
  String get informationAccuracy;

  /// No description provided for @irreversibleAction.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible.'**
  String get irreversibleAction;

  /// No description provided for @kindlyFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Kindly fill all fields.'**
  String get kindlyFillAllFields;

  /// No description provided for @kindlySelectAddress.
  ///
  /// In en, this message translates to:
  /// **'Kindly select an address'**
  String get kindlySelectAddress;

  /// No description provided for @kindlyWait.
  ///
  /// In en, this message translates to:
  /// **'Kindly wait till the current operation is complete.'**
  String get kindlyWait;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @latestEventInfo.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with everything happening around you! From traffic updates and accidents to parties and community events, our users provide real-time information on all the action. Join us and never miss a beat!'**
  String get latestEventInfo;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutBar.
  ///
  /// In en, this message translates to:
  /// **'Logout Bar'**
  String get logoutBar;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @mapView.
  ///
  /// In en, this message translates to:
  /// **'Map View'**
  String get mapView;

  /// No description provided for @moreResultOptions.
  ///
  /// In en, this message translates to:
  /// **'more result options'**
  String get moreResultOptions;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nearbyEvents.
  ///
  /// In en, this message translates to:
  /// **'Nearby Events'**
  String get nearbyEvents;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'No Events'**
  String get noEvents;

  /// No description provided for @noEventsNearby.
  ///
  /// In en, this message translates to:
  /// **'There are no events happening within 500 meters of your current location.'**
  String get noEventsNearby;

  /// No description provided for @noNetworkConnection.
  ///
  /// In en, this message translates to:
  /// **'No Network Connection.'**
  String get noNetworkConnection;

  /// No description provided for @noParameter.
  ///
  /// In en, this message translates to:
  /// **'No Parameter'**
  String get noParameter;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @ofUse.
  ///
  /// In en, this message translates to:
  /// **'of use'**
  String get ofUse;

  /// No description provided for @ongoingEvents.
  ///
  /// In en, this message translates to:
  /// **'Ongoing Events'**
  String get ongoingEvents;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be more than 6 letters.'**
  String get passwordLength;

  /// No description provided for @passwordsMustMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords must be the same.'**
  String get passwordsMustMatch;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @pickAddress.
  ///
  /// In en, this message translates to:
  /// **'Pick Address'**
  String get pickAddress;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileEdited.
  ///
  /// In en, this message translates to:
  /// **'Your profile has been successfully edited.'**
  String get profileEdited;

  /// No description provided for @provideDescription.
  ///
  /// In en, this message translates to:
  /// **'Kindly provide a description.'**
  String get provideDescription;

  /// No description provided for @provideEmail.
  ///
  /// In en, this message translates to:
  /// **'Kindly provide your email.'**
  String get provideEmail;

  /// No description provided for @provideEventName.
  ///
  /// In en, this message translates to:
  /// **'Kindly provide the event name.'**
  String get provideEventName;

  /// No description provided for @provideFullName.
  ///
  /// In en, this message translates to:
  /// **'Kindly provide your full name.'**
  String get provideFullName;

  /// No description provided for @providePassword.
  ///
  /// In en, this message translates to:
  /// **'Kindly provide your password.'**
  String get providePassword;

  /// No description provided for @providePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Kindly provide a phone number.'**
  String get providePhoneNumber;

  /// No description provided for @provideReasonForChoice.
  ///
  /// In en, this message translates to:
  /// **'Provide a reason for your choice.'**
  String get provideReasonForChoice;

  /// No description provided for @reasonForChoice.
  ///
  /// In en, this message translates to:
  /// **'Reason for your choice'**
  String get reasonForChoice;

  /// No description provided for @reenterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reenterPassword;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @resetPasswordMailSent.
  ///
  /// In en, this message translates to:
  /// **'A reset password mail has been sent to your account'**
  String get resetPasswordMailSent;

  /// No description provided for @searchEventNameOrLocation.
  ///
  /// In en, this message translates to:
  /// **'Search event name or location'**
  String get searchEventNameOrLocation;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @selectAddress.
  ///
  /// In en, this message translates to:
  /// **'Select Address'**
  String get selectAddress;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select your country'**
  String get selectCountry;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select end date'**
  String get selectEndDate;

  /// No description provided for @selectEventAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Kindly select if the event is accurate or not.'**
  String get selectEventAccuracy;

  /// No description provided for @selectFromMap.
  ///
  /// In en, this message translates to:
  /// **'Select from map'**
  String get selectFromMap;

  /// No description provided for @selectPriority.
  ///
  /// In en, this message translates to:
  /// **'Select the priority'**
  String get selectPriority;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select start date'**
  String get selectStartDate;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @shorterTitle.
  ///
  /// In en, this message translates to:
  /// **'Kindly enter a shorter title.'**
  String get shorterTitle;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @tapOnMapToGetAddress.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to get address'**
  String get tapOnMapToGetAddress;

  /// No description provided for @tapToShow.
  ///
  /// In en, this message translates to:
  /// **'Tap to show'**
  String get tapToShow;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @termsAndConditionsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions of Use'**
  String get termsAndConditionsOfUse;

  /// No description provided for @unknownEndDate.
  ///
  /// In en, this message translates to:
  /// **'I do not know the end date'**
  String get unknownEndDate;

  /// No description provided for @unknownStartDate.
  ///
  /// In en, this message translates to:
  /// **'I do not know the start date'**
  String get unknownStartDate;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'updated'**
  String get updated;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @usersVotedAccurate.
  ///
  /// In en, this message translates to:
  /// **'users voted accurate'**
  String get usersVotedAccurate;

  /// No description provided for @usersVotedInaccurate.
  ///
  /// In en, this message translates to:
  /// **'users voted inaccurate'**
  String get usersVotedInaccurate;

  /// No description provided for @validity.
  ///
  /// In en, this message translates to:
  /// **'Validity'**
  String get validity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @viewEvent.
  ///
  /// In en, this message translates to:
  /// **'View Event'**
  String get viewEvent;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on map'**
  String get viewOnMap;

  /// No description provided for @vote.
  ///
  /// In en, this message translates to:
  /// **'Vote'**
  String get vote;

  /// No description provided for @voteAndComment.
  ///
  /// In en, this message translates to:
  /// **'Vote and Comment'**
  String get voteAndComment;

  /// No description provided for @voteSaved.
  ///
  /// In en, this message translates to:
  /// **'Your vote has been successfully saved.'**
  String get voteSaved;

  /// No description provided for @welcomeToAlertHub.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AlertHub'**
  String get welcomeToAlertHub;

  /// No description provided for @youHaveNotCreatedEvent.
  ///
  /// In en, this message translates to:
  /// **'You have not created any events.'**
  String get youHaveNotCreatedEvent;

  /// No description provided for @yourPostedEvents.
  ///
  /// In en, this message translates to:
  /// **'Your Posted Events'**
  String get yourPostedEvents;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @deleteYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteYourAccount;

  /// No description provided for @deletionOfAllData.
  ///
  /// In en, this message translates to:
  /// **'This action will result in the deletion of all your data.'**
  String get deletionOfAllData;

  /// No description provided for @changeAccountPassword.
  ///
  /// In en, this message translates to:
  /// **'Change account password?'**
  String get changeAccountPassword;

  /// No description provided for @mailSentAndLoggedOut.
  ///
  /// In en, this message translates to:
  /// **'A mail would be sent to your account and you would be logged out of all devices.'**
  String get mailSentAndLoggedOut;

  /// No description provided for @xTwitter.
  ///
  /// In en, this message translates to:
  /// **'X (Twitter)'**
  String get xTwitter;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @errorLoggingOut.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while logging you out.'**
  String get errorLoggingOut;

  /// No description provided for @logoutFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Logout from this device?'**
  String get logoutFromDevice;

  /// No description provided for @clearStoredData.
  ///
  /// In en, this message translates to:
  /// **'This would clear all stored user data from this device.'**
  String get clearStoredData;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;
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
      <String>['es', 'en', 'fr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
