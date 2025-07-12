import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'I10n/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Vision Scan'**
  String get app_name;

  /// No description provided for @app_slogan.
  ///
  /// In en, this message translates to:
  /// **'Scan Anything. Anywhere.'**
  String get app_slogan;

  /// No description provided for @tool_document_scanner.
  ///
  /// In en, this message translates to:
  /// **'Document Scanner'**
  String get tool_document_scanner;

  /// No description provided for @tool_qr_code_scanner.
  ///
  /// In en, this message translates to:
  /// **'QR Code Scanner'**
  String get tool_qr_code_scanner;

  /// No description provided for @tool_scanned_pdfs.
  ///
  /// In en, this message translates to:
  /// **'Scanned PDF'**
  String get tool_scanned_pdfs;

  /// No description provided for @tool_merge_pdfs.
  ///
  /// In en, this message translates to:
  /// **'Merge PDFs'**
  String get tool_merge_pdfs;

  /// No description provided for @tool_split_pdf.
  ///
  /// In en, this message translates to:
  /// **'Split PDF'**
  String get tool_split_pdf;

  /// No description provided for @tool_reorder_pdf.
  ///
  /// In en, this message translates to:
  /// **'Reorder PDF'**
  String get tool_reorder_pdf;

  /// No description provided for @tool_remove_page_pdf.
  ///
  /// In en, this message translates to:
  /// **'Remove Pages'**
  String get tool_remove_page_pdf;

  /// No description provided for @action_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get action_cancel;

  /// No description provided for @action_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get action_continue;

  /// No description provided for @action_merge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get action_merge;

  /// No description provided for @action_split.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get action_split;

  /// No description provided for @action_remove_pages.
  ///
  /// In en, this message translates to:
  /// **'Remove Pages'**
  String get action_remove_pages;

  /// No description provided for @action_reorder_pages.
  ///
  /// In en, this message translates to:
  /// **'Reorder Pages'**
  String get action_reorder_pages;

  /// No description provided for @label_choose_pdf_file.
  ///
  /// In en, this message translates to:
  /// **'Choose PDF file'**
  String get label_choose_pdf_file;

  /// No description provided for @body_supported_file.
  ///
  /// In en, this message translates to:
  /// **'Supported file: .Pdf'**
  String get body_supported_file;

  /// No description provided for @body_split_note.
  ///
  /// In en, this message translates to:
  /// **'Note: Split Range (e.g., 1-3,5):'**
  String get body_split_note;

  /// No description provided for @hint_split_box.
  ///
  /// In en, this message translates to:
  /// **'Enter page ranges'**
  String get hint_split_box;

  /// No description provided for @title_guide_qr_code.
  ///
  /// In en, this message translates to:
  /// **'Scan QR/Barcodes'**
  String get title_guide_qr_code;

  /// No description provided for @body_guide_qr_code_1.
  ///
  /// In en, this message translates to:
  /// **'Hold your device steady and point the camera at the QR code or barcode.'**
  String get body_guide_qr_code_1;

  /// No description provided for @body_guide_qr_code_2.
  ///
  /// In en, this message translates to:
  /// **'Make sure the entire code fits inside the green box.'**
  String get body_guide_qr_code_2;

  /// No description provided for @body_guide_qr_code_3.
  ///
  /// In en, this message translates to:
  /// **'Keep the area well-lit and avoid glare or blur.'**
  String get body_guide_qr_code_3;

  /// No description provided for @body_guide_qr_code_4.
  ///
  /// In en, this message translates to:
  /// **'The scanner only works when the code is fully visible within the frame.'**
  String get body_guide_qr_code_4;

  /// No description provided for @body_guide_qr_code_5.
  ///
  /// In en, this message translates to:
  /// **'Once detected, the code will be processed automatically.'**
  String get body_guide_qr_code_5;

  /// No description provided for @action_guide_qr_code.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get action_guide_qr_code;

  /// No description provided for @title_scan_result.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get title_scan_result;

  /// No description provided for @action_scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get action_scan;

  /// No description provided for @label_format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get label_format;

  /// No description provided for @scan_type_text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get scan_type_text;

  /// No description provided for @scan_type_url.
  ///
  /// In en, this message translates to:
  /// **'URL / Link'**
  String get scan_type_url;

  /// No description provided for @scan_type_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get scan_type_email;

  /// No description provided for @scan_type_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get scan_type_phone;

  /// No description provided for @scan_type_sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get scan_type_sms;

  /// No description provided for @scan_type_wifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get scan_type_wifi;

  /// No description provided for @scan_type_geo.
  ///
  /// In en, this message translates to:
  /// **'Geo'**
  String get scan_type_geo;

  /// No description provided for @scan_type_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact / vCard / MeCard'**
  String get scan_type_contact;

  /// No description provided for @scan_type_event.
  ///
  /// In en, this message translates to:
  /// **'Calendar / Event'**
  String get scan_type_event;

  /// No description provided for @scan_type_app_links.
  ///
  /// In en, this message translates to:
  /// **'App Links / Custom Schemes'**
  String get scan_type_app_links;

  /// No description provided for @scan_type_payment.
  ///
  /// In en, this message translates to:
  /// **'Social / Payment'**
  String get scan_type_payment;

  /// No description provided for @scan_type_barcode.
  ///
  /// In en, this message translates to:
  /// **'Product / Barcode'**
  String get scan_type_barcode;

  /// No description provided for @action_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get action_copy;

  /// No description provided for @action_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get action_share;

  /// No description provided for @action_save.
  ///
  /// In en, this message translates to:
  /// **'Generate & Save'**
  String get action_save;

  /// No description provided for @label_qr_code.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get label_qr_code;

  /// No description provided for @label_qr_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get label_qr_email;

  /// No description provided for @label_qr_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get label_qr_phone;

  /// No description provided for @label_qr_message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get label_qr_message;

  /// No description provided for @label_qr_text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get label_qr_text;

  /// No description provided for @label_qr_url.
  ///
  /// In en, this message translates to:
  /// **'Url'**
  String get label_qr_url;

  /// No description provided for @label_qr_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get label_qr_contact;

  /// No description provided for @label_qr_wifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get label_qr_wifi;

  /// No description provided for @label_qr_event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get label_qr_event;

  /// No description provided for @label_qr_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get label_qr_location;

  /// No description provided for @label_qr_aztec.
  ///
  /// In en, this message translates to:
  /// **'AZTEC'**
  String get label_qr_aztec;

  /// No description provided for @label_qr_data_matrix.
  ///
  /// In en, this message translates to:
  /// **'Data Matrix'**
  String get label_qr_data_matrix;

  /// No description provided for @label_bar_code.
  ///
  /// In en, this message translates to:
  /// **'Bar Code'**
  String get label_bar_code;

  /// No description provided for @label_bar_codebar.
  ///
  /// In en, this message translates to:
  /// **'Codebar'**
  String get label_bar_codebar;

  /// No description provided for @label_bar_code39.
  ///
  /// In en, this message translates to:
  /// **'Code 39'**
  String get label_bar_code39;

  /// No description provided for @label_bar_code93.
  ///
  /// In en, this message translates to:
  /// **'Code 93'**
  String get label_bar_code93;

  /// No description provided for @label_bar_code128.
  ///
  /// In en, this message translates to:
  /// **'Code 128'**
  String get label_bar_code128;

  /// No description provided for @label_bar_ean8.
  ///
  /// In en, this message translates to:
  /// **'EAN 8'**
  String get label_bar_ean8;

  /// No description provided for @label_bar_ean13.
  ///
  /// In en, this message translates to:
  /// **'EAN 13'**
  String get label_bar_ean13;

  /// No description provided for @label_bar_pdf417.
  ///
  /// In en, this message translates to:
  /// **'PDF 417'**
  String get label_bar_pdf417;

  /// No description provided for @label_bar_upca.
  ///
  /// In en, this message translates to:
  /// **'UPC A'**
  String get label_bar_upca;

  /// No description provided for @label_bar_itf.
  ///
  /// In en, this message translates to:
  /// **'ITF'**
  String get label_bar_itf;

  /// No description provided for @action_generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get action_generate;

  /// No description provided for @title_preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get title_preview;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
