// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'Vision Scan';

  @override
  String get app_slogan => 'Scan Anything. Anywhere.';

  @override
  String get tool_document_scanner => 'Document Scanner';

  @override
  String get tool_qr_code_scanner => 'QR Code Scanner';

  @override
  String get tool_scanned_pdfs => 'Scanned PDF';

  @override
  String get title_guide_qr_code => 'Scan QR/Barcodes';

  @override
  String get body_guide_qr_code_1 =>
      'Hold your device steady and point the camera at the QR code or barcode.';

  @override
  String get body_guide_qr_code_2 =>
      'Make sure the entire code fits inside the green box.';

  @override
  String get body_guide_qr_code_3 =>
      'Keep the area well-lit and avoid glare or blur.';

  @override
  String get body_guide_qr_code_4 =>
      'The scanner only works when the code is fully visible within the frame.';

  @override
  String get body_guide_qr_code_5 =>
      'Once detected, the code will be processed automatically.';

  @override
  String get action_guide_qr_code => 'Got it';

  @override
  String get title_scan_result => 'Scan Result';

  @override
  String get action_scan => 'Scan';

  @override
  String get label_format => 'Format';

  @override
  String get scan_type_text => 'Text';

  @override
  String get scan_type_url => 'URL / Link';

  @override
  String get scan_type_email => 'Email';

  @override
  String get scan_type_phone => 'Phone';

  @override
  String get scan_type_sms => 'SMS';

  @override
  String get scan_type_wifi => 'WiFi';

  @override
  String get scan_type_geo => 'Geo';

  @override
  String get scan_type_contact => 'Contact / vCard / MeCard';

  @override
  String get scan_type_event => 'Calendar / Event';

  @override
  String get scan_type_app_links => 'App Links / Custom Schemes';

  @override
  String get scan_type_payment => 'Social / Payment';

  @override
  String get scan_type_barcode => 'Product / Barcode';

  @override
  String get action_copy => 'Copy';

  @override
  String get action_share => 'Share';

  @override
  String get action_save => 'Generate & Save';

  @override
  String get label_qr_code => 'QR Code';

  @override
  String get label_qr_email => 'Email';

  @override
  String get label_qr_phone => 'Phone';

  @override
  String get label_qr_message => 'Message';

  @override
  String get label_qr_text => 'Text';

  @override
  String get label_qr_url => 'Url';

  @override
  String get label_qr_contact => 'Contact';

  @override
  String get label_qr_wifi => 'WiFi';

  @override
  String get label_qr_event => 'Event';

  @override
  String get label_qr_location => 'Location';

  @override
  String get label_qr_aztec => 'AZTEC';

  @override
  String get label_qr_data_matrix => 'Data Matrix';

  @override
  String get label_bar_code => 'Bar Code';

  @override
  String get label_bar_codebar => 'Codebar';

  @override
  String get label_bar_code39 => 'Code 39';

  @override
  String get label_bar_code93 => 'Code 93';

  @override
  String get label_bar_code128 => 'Code 128';

  @override
  String get label_bar_ean8 => 'EAN 8';

  @override
  String get label_bar_ean13 => 'EAN 13';

  @override
  String get label_bar_pdf417 => 'PDF 417';

  @override
  String get label_bar_upca => 'UPC A';

  @override
  String get label_bar_itf => 'ITF';

  @override
  String get action_generate => 'Generate';

  @override
  String get title_preview => 'Preview';
}
