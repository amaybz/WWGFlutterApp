import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/classes/scan_results.dart';

class LocalScanDetailPage extends StatelessWidget {
  final ScanData scan;

  const LocalScanDetailPage({Key? key, required this.scan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailTile('Game Tag', scan.gameTag ?? 'N/A'),
            _buildDetailTile('Scan Time', scan.scanTime ?? 'N/A'),
            _buildDetailTile('Base ID', scan.baseID?.toString() ?? 'N/A'),
            _buildDetailTile('Activity ID', scan.activityID?.toString() ?? 'N/A'),
            _buildDetailTile('Result', scan.result ?? 'N/A'),
            _buildDetailTile('Comment', scan.comment ?? 'N/A'),
            _buildDetailTile('Result Value', scan.resultValue?.toString() ?? 'N/A'),
            _buildDetailTile('Offline', scan.offline == 1 ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}
