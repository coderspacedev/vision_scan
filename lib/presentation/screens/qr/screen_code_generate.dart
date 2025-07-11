import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:get/get.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:visionscan/presentation/screens/qr/screen_barcode_generate_result.dart';
import 'package:visionscan/presentation/screens/qr/screen_qr_generate_result.dart';
import 'package:visionscan/vision.dart';

class ScreenCodeGenerate extends StatefulWidget {
  final String type;
  final String title;

  const ScreenCodeGenerate({super.key, required this.type, required this.title});

  @override
  State<ScreenCodeGenerate> createState() => _ScreenCodeGenerateState();
}

class _ScreenCodeGenerateState extends State<ScreenCodeGenerate> {
  late List<TextEditingController> controllers;
  late List<String> fieldLabels;
  bool isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInitialized) return;

    final fieldMap = {
      context.localization?.label_qr_email ?? 'Email': ['Mail To', 'Mail CC', 'Mail BCC', 'Subject', 'Body'],
      context.localization?.label_qr_phone ?? 'Phone': ['Number'],
      context.localization?.label_qr_message ?? 'Message': ['Number', 'Via', 'Subject', 'Body'],
      context.localization?.label_qr_text ?? 'Text': ['Content'],
      context.localization?.label_qr_url ?? 'URL': ['URL'],
      context.localization?.label_qr_contact ?? 'Contact': [
        'Name',
        'Number',
        'Nickname',
        'Home Address',
        'Organization',
        'Work Address',
        'Birthday(dd/MM/yyyy)',
        'Email',
        'Note',
      ],
      context.localization?.label_qr_wifi ?? 'WiFi': ['Network'],
      context.localization?.label_qr_event ?? 'Event': ['Title', 'Starting date', 'Ending date', 'Organizer', 'Description'],
      context.localization?.label_qr_location ?? 'Location': ['Latitude', 'Longitude'],
      context.localization?.label_qr_aztec ?? 'Aztec': ['Text'],
      context.localization?.label_qr_data_matrix ?? 'DataMatrix': ['Text'],
      context.localization?.label_bar_codebar ?? 'Codebar': ['Text'],
      context.localization?.label_bar_code39 ?? 'Code39': ['Text'],
      context.localization?.label_bar_code93 ?? 'Code93': ['Text'],
      context.localization?.label_bar_code128 ?? 'Code128': ['Text'],
      context.localization?.label_bar_ean8 ?? 'EAN8': ['Text'],
      context.localization?.label_bar_ean13 ?? 'EAN13': ['Text'],
      context.localization?.label_bar_pdf417 ?? 'PDF417': ['Text'],
      context.localization?.label_bar_upca ?? 'UPCA': ['Text'],
      context.localization?.label_bar_itf ?? 'ITF': ['Text'],
    };

    fieldLabels = fieldMap[widget.title] ?? [];
    controllers = List.generate(fieldLabels.length, (_) => TextEditingController());
    isInitialized = true;
  }

  TextInputType getKeyboardType(String label) {
    final lowerLabel = label.toLowerCase();
    final lowerTitle = (widget.title ?? '').toLowerCase();

    final numericBarcodes = [
      context.localization?.label_bar_ean8,
      context.localization?.label_bar_ean13,
      context.localization?.label_bar_upca,
    ].map((e) => e?.toLowerCase()).toSet();

    if (numericBarcodes.contains(lowerTitle)) return TextInputType.number;

    if (lowerLabel.contains('email')) return TextInputType.emailAddress;
    if (lowerLabel.contains('number') || lowerLabel.contains('phone') || lowerLabel.contains('latitude') || lowerLabel.contains('longitude')) {
      return TextInputType.phone;
    }
    if (lowerLabel.contains('url')) return TextInputType.url;
    if (lowerLabel.contains('date')) return TextInputType.datetime;

    return TextInputType.text;
  }

  List<TextInputFormatter>? getInputFormatters(String label) {
    final lowerLabel = label.toLowerCase();
    final lowerTitle = (widget.title ?? '').toLowerCase();

    final numericBarcodes = [
      context.localization?.label_bar_ean8,
      context.localization?.label_bar_ean13,
      context.localization?.label_bar_upca,
    ].map((e) => e?.toLowerCase()).toSet();

    if (numericBarcodes.contains(lowerTitle) || lowerLabel.contains('number')) {
      return [FilteringTextInputFormatter.digitsOnly];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppAppBar(title: widget.title, onBack: () => Get.back()),
      body: Padding(
        padding: EdgeInsets.all(context.scale(24)),
        child: Column(
          children: [
            ...List.generate(fieldLabels.length, (index) {
              final isNumberField = fieldLabels[index].toLowerCase().contains('number');
              final isContact = widget.title == (context.localization?.label_qr_contact ?? 'Contact');
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: controllers[index],
                    hint: fieldLabels[index],
                    keyboardType: getKeyboardType(fieldLabels[index]),
                    inputFormatters: getInputFormatters(fieldLabels[index]),
                    suffixIcon: isNumberField
                        ? IconButton(
                            icon: Icon(Icons.contacts, color: colorAccent),
                            onPressed: () async {
                              final contact = await pickContactNumber();
                              if (contact != null) {
                                if (isContact) {
                                  for (int i = 0; i < fieldLabels.length; i++) {
                                    final label = fieldLabels[i].toLowerCase();
                                    if (label == 'name') {
                                      controllers[i].text = contact.fullName ?? '';
                                    } else if (label.contains('number')) {
                                      controllers[i].text = contact.phoneNumbers?.first ?? '';
                                    }
                                  }
                                } else {
                                  controllers[index].text = contact.phoneNumbers?.first ?? '';
                                }
                              }
                            },
                          )
                        : null,
                  ),
                  SizedBox(height: context.scale(8)),
                ],
              );
            }),
            SizedBox(height: context.scale(8)),
            AppButton(
              width: double.infinity,
              text: context.localization?.action_generate ?? '',
              onPressed: () {
                final buffer = StringBuffer();

                for (int i = 0; i < fieldLabels.length; i++) {
                  final label = fieldLabels[i];
                  final value = controllers[i].text.trim();

                  if (value.isNotEmpty) {
                    if (buffer.isNotEmpty) buffer.writeln();
                    if (label == 'Content' || label == 'Text') {
                      buffer.write(value);
                    } else {
                      buffer.write('$label : $value');
                    }
                  }
                }

                final result = buffer.toString();
                debugPrint('✅ Generated QR Content:\n$result');
                if (widget.type == 'qr') {
                  Get.to(ScreenQrGenerateResult(qrContent: result, type: widget.type));
                } else {
                  Get.to(ScreenBarCodeGenerateResult(barContent: result, type: widget.type));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Contact?> pickContactNumber() async {
    final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
    try {
      Contact? contact = await _contactPicker.selectContact();
      debugPrint(contact?.fullName);
      return contact;
    } catch (e) {
      debugPrint('Contact pick error: $e');
      return null;
    }
  }
}
