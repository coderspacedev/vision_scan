import 'package:floor/floor.dart';
import 'package:visionscan/databases/qr_history.dart';

@dao
abstract class QrHistoryDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertHistory(QrHistory history);

  @Query('SELECT * FROM qr_history WHERE historyType = :type ORDER BY timestamp DESC')
  Future<List<QrHistory>> getHistoryByType(String type);

  @Query('DELETE FROM qr_history WHERE historyType = :type')
  Future<void> clearHistoryByType(String type);
}
