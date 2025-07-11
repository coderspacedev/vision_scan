import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionscan/vision.dart';

class ScreenQrHistory extends StatefulWidget {
  const ScreenQrHistory({super.key});

  @override
  State<ScreenQrHistory> createState() => _ScreenQrHistoryState();
}

class _ScreenQrHistoryState extends State<ScreenQrHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colorBackground,
        appBar: AppAppBar(
          title: 'History',
          onBack: () => Get.back(),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(context.scale(24)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: false,
                indicatorPadding: EdgeInsets.symmetric(horizontal: context.scale(56)),
                tabs: [
                  Tab(text: 'Scan'),
                  Tab(text: 'Generate'),
                ],
                labelStyle: context.bodyBoldMedium,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(child: TabBarView(children: [_buildScan(), _buildGenerate()])),
          ],
        ),
      ),
    );
  }

  Widget _buildScan() {
    return FutureBuilder<List<QrHistory>>(
      future: _getHistoryByType('scan'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: context.bodyBoldMedium));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No scanned history', style: context.bodyBoldMedium));
        }

        final history = snapshot.data!;
        return ListView.separated(
          padding: EdgeInsets.only(top: context.scale(12)),
          separatorBuilder: (context, index) =>
              Divider(color: colorText.withAlpha(20), thickness: 0.5, indent: context.scale(16), endIndent: context.scale(16)),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: context.scale(12), vertical: context.scale(0)),
              leading: AppContainer(color: colorCard, padding: EdgeInsets.all(context.scale(12)), child: Icon(getQRTypeIcon(item.qrContent))),
              title: Text(item.qrContent.contains(':')
                  ? item.qrContent.split(':').sublist(1).join(':').trim()
                  : item.qrContent, style: context.bodyBoldMedium),
              subtitle: Row(
                children: [
                  Text(item.type, style: context.bodyBoldSmall.copyWith(color: colorText.withAlpha(100))),
                  SizedBox(width: context.scale(8)),
                  Text('${DateTime.fromMillisecondsSinceEpoch(item.timestamp)}', style: context.bodySmall.copyWith(color: colorText.withAlpha(100))),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGenerate() {
    return FutureBuilder<List<QrHistory>>(
      future: _getHistoryByType('generate'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(width: context.scale(24), height: context.scale(24), child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: context.bodyBoldMedium));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No generated history', style: context.bodyBoldMedium));
        }

        final history = snapshot.data!;
        return ListView.separated(
          padding: EdgeInsets.only(top: context.scale(12)),
          separatorBuilder: (context, index) =>
              Divider(color: colorText.withAlpha(20), thickness: 0.5, indent: context.scale(16), endIndent: context.scale(16)),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: context.scale(12), vertical: context.scale(0)),
              leading: AppContainer(color: colorCard, padding: EdgeInsets.all(context.scale(12)), child: Icon(getQRTypeIcon(item.qrContent))),
              title: Text(item.qrContent.contains(':')
                  ? item.qrContent.split(':').sublist(1).join(':').trim()
                  : item.qrContent, style: context.bodyBoldMedium),
              subtitle: Row(
                children: [
                  Text(item.type, style: context.bodyBoldSmall.copyWith(color: colorText.withAlpha(100))),
                  SizedBox(width: context.scale(8)),
                  Text('${DateTime.fromMillisecondsSinceEpoch(item.timestamp)}', style: context.bodySmall.copyWith(color: colorText.withAlpha(100))),
                ],
              ),
            );
          },
        );
      },
    );
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

  Future<List<QrHistory>> _getHistoryByType(String type) async {
    final database = await $FloorAppDatabase.databaseBuilder('qr_history.db').build();
    final dao = database.qrHistoryDao;
    return dao.getHistoryByType(type);
  }
}
