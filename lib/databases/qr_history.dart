import 'package:floor/floor.dart';

@Entity(tableName: 'qr_history')
class QrHistory {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String qrContent;
  final String type;
  final String style;
  final String color;
  final String brushType;
  final bool isCornered;
  final int timestamp;

  final String historyType;

  QrHistory({
    this.id,
    required this.qrContent,
    required this.type,
    required this.style,
    required this.color,
    required this.brushType,
    required this.isCornered,
    required this.timestamp,
    required this.historyType,
  });
}
