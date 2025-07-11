import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visionscan/vision.dart';

class ScreenResult extends StatefulWidget {
  final String qrContent;

  const ScreenResult({super.key, required this.qrContent});

  @override
  State<ScreenResult> createState() => _ScreenResultState();
}

class _ScreenResultState extends State<ScreenResult> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      insertScanCodeHistory(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppAppBar(title: context.localization?.title_scan_result ?? '', onBack: () => Get.back()),
      body: Column(
        children: [
          AppContainer(
            width: double.infinity,
            margin: EdgeInsets.all(context.scale(12)),
            padding: EdgeInsets.all(context.scale(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppContainer(
                  width: context.scale(36),
                  height: context.scale(36),
                  child: Icon(getQRTypeIcon(widget.qrContent), size: context.scale(24)),
                ),
                SizedBox(width: context.scale(12)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detectQRType(widget.qrContent, context: context), style: context.bodyBoldLarge),
                    SizedBox(height: context.scale(4)),
                    Text(formattedDate(), style: context.bodySmall.copyWith(color: colorText.withAlpha(80))),
                  ],
                ),
              ],
            ),
          ),
          AppContainer(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: context.scale(12)),
            padding: EdgeInsets.all(context.scale(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.localization?.label_format ?? '', style: context.bodySmall.copyWith(color: colorText.withAlpha(80))),
                SizedBox(height: context.scale(4)),
                Text(widget.qrContent, style: context.bodyMedium),
              ],
            ),
          ),
          SizedBox(height: context.scale(12)),
          Padding(
            padding: EdgeInsets.all(context.scale(12)),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(text: context.localization?.action_copy ?? '', onPressed: () {}),
                ),
                SizedBox(width: context.scale(12)),
                Expanded(
                  child: AppButton(text: context.localization?.action_share ?? '', onPressed: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMM, yyyy hh:mm:ss a');
    return formatter.format(now);
  }

  String detectQRType(String value, {required BuildContext context}) {
    final lower = value.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return context.localization?.scan_type_url ?? 'URL';
    } else if (lower.startsWith('mailto:')) {
      return context.localization?.scan_type_email ?? 'Email';
    } else if (lower.startsWith('tel:')) {
      return context.localization?.scan_type_phone ?? 'Phone';
    } else if (lower.startsWith('sms:')) {
      return context.localization?.scan_type_sms ?? 'SMS';
    } else if (lower.startsWith('wifi:')) {
      return context.localization?.scan_type_wifi ?? 'WiFi';
    } else if (lower.startsWith('geo:')) {
      return context.localization?.scan_type_geo ?? 'Geo Location';
    } else if (lower.startsWith('begin:vcard') || lower.contains('mecard:')) {
      return context.localization?.scan_type_contact ?? 'Contact';
    } else if (lower.contains('begin:VEVENT'.toLowerCase())) {
      return context.localization?.scan_type_event ?? 'Calendar Event';
    } else if (RegExp(r'^[0-9]{8,}$').hasMatch(lower)) {
      return context.localization?.scan_type_barcode ?? 'Product Code / Barcode';
    } else {
      return context.localization?.scan_type_text ?? 'Text';
    }
  }

  IconData getQRTypeIcon(String value) {
    final lower = value.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return Icons.link;
    } else if (lower.startsWith('mailto:')) {
      return Icons.email;
    } else if (lower.startsWith('tel:')) {
      return Icons.phone;
    } else if (lower.startsWith('sms:')) {
      return Icons.sms;
    } else if (lower.startsWith('wifi:')) {
      return Icons.wifi;
    } else if (lower.startsWith('geo:')) {
      return Icons.location_on;
    } else if (lower.startsWith('begin:vcard') || lower.contains('mecard:')) {
      return Icons.contacts;
    } else if (lower.contains('begin:VEVENT'.toLowerCase())) {
      return Icons.event;
    } else if (RegExp(r'^[0-9]{8,}$').hasMatch(lower)) {
      return Icons.qr_code_2;
    } else {
      return Icons.text_fields;
    }
  }

  Future<void> insertScanCodeHistory({required BuildContext context}) async {
    final database = await $FloorAppDatabase.databaseBuilder('qr_history.db').build();

    final dao = database.qrHistoryDao;
    await dao.insertHistory(
      QrHistory(
        qrContent: widget.qrContent,
        type: detectQRType(widget.qrContent, context: context),
        style: '',
        color: '',
        brushType: '',
        isCornered: false,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        historyType: 'scan',
      ),
    );
  }
}
