import 'package:flutter/cupertino.dart';
import 'package:visionscan/extensions/context.dart';

class QRCode {
  String? type;
  String? title;
  String? icon;

  QRCode({this.type, this.title, this.icon});

  QRCode.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['title'] = title;
    data['icon'] = icon;
    return data;
  }
}

List<QRCode> qrCodeList(BuildContext context) {
  return [
    QRCode(
      type: "qr",
      title: context.localization?.label_qr_email,
      icon: "assets/qr/ic_qr_email.svg",
    ),
    QRCode(
      type: "qr",
      title: context.localization?.label_qr_phone,
      icon: "assets/qr/ic_qr_phone.svg",
    ),
    QRCode(
      type: "qr",
      title: context.localization?.label_qr_message,
      icon: "assets/qr/ic_qr_message.svg",
    ),
    QRCode(
      type: "qr",
      title: context.localization?.label_qr_text,
      icon: "assets/qr/ic_qr_text.svg",
    ),
    QRCode(
      type: "qr",
      title: context.localization?.label_qr_url,
      icon: "assets/qr/ic_qr_url.svg",
    ),
    QRCode(
      type: "qr",
      title: context.localization?.label_qr_contact,
      icon: "assets/qr/ic_qr_contact.svg",
    ),
    // QRCode(type: "qr", title: context.localization?.label_qr_wifi, icon: "assets/qr/ic_qr_wifi.svg"),
    QRCode(
      type: "qr",
      title: context.localization?.label_qr_event,
      icon: "assets/qr/ic_qr_event.svg",
    ),
    QRCode(
      type: "qr",
      title: context.localization?.label_qr_location,
      icon: "assets/qr/ic_qr_location.svg",
    ),
    QRCode(
      type: "qr",
      title: context.localization?.label_qr_aztec,
      icon: "assets/qr/ic_qr_aztec.svg",
    ),
    QRCode(
      type: "qr",
      title: context.localization?.label_qr_data_matrix,
      icon: "assets/qr/ic_qr_data_matrix.svg",
    ),
    QRCode(
      type: "barcode",
      title: context.localization?.label_bar_codebar,
      icon: "assets/qr/ic_barcode_codebar.svg",
    ),
    QRCode(
      type: "barcode",
      title: context.localization?.label_bar_code39,
      icon: "assets/qr/ic_barcode_code39.svg",
    ),
    QRCode(
      type: "barcode",
      title: context.localization?.label_bar_code93,
      icon: "assets/qr/ic_barcode_code93.svg",
    ),
    QRCode(
      type: "barcode",
      title: context.localization?.label_bar_code128,
      icon: "assets/qr/ic_barcode_code128.svg",
    ),
    QRCode(
      type: "barcode",
      title: context.localization?.label_bar_ean8,
      icon: "assets/qr/ic_barcode_ean8.svg",
    ),
    QRCode(
      type: "barcode",
      title: context.localization?.label_bar_ean13,
      icon: "assets/qr/ic_barcode_ean13.svg",
    ),
    QRCode(
      type: "barcode",
      title: context.localization?.label_bar_pdf417,
      icon: "assets/qr/ic_barcode_pdf417.svg",
    ),
    QRCode(
      type: "barcode",
      title: context.localization?.label_bar_upca,
      icon: "assets/qr/ic_barcode_upca.svg",
    ),
    QRCode(
      type: "barcode",
      title: context.localization?.label_bar_itf,
      icon: "assets/qr/ic_barcode_itf.svg",
    ),
  ];
}
