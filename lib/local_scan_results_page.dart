import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/classes/database/localdb.dart';
import 'package:wwgnfcscoringsystem/classes/scan_results.dart';

class LocalScanResultsPage extends StatefulWidget {
  const LocalScanResultsPage({Key? key}) : super(key: key);

  @override
  State<LocalScanResultsPage> createState() => _LocalScanResultsPageState();
}

class _LocalScanResultsPageState extends State<LocalScanResultsPage> {
  final LocalDB _localDB = LocalDB.instance;
  List<ScanData> _scanData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<ScanData> data = await _localDB.listScanData();
    setState(() {
      _scanData = data;
      _isLoading = false;
    });
  }

  Future<void> _clearData() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Clear'),
        content: const Text(
          'Are you sure you want to wipe all local scan data?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _localDB.clearScanData();
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Local scan data cleared')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Scan Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scanData.isEmpty
          ? const Center(child: Text('No local scan data found'))
          : ListView.builder(
              itemCount: _scanData.length,
              itemBuilder: (context, index) {
                final scan = _scanData[index];
                return ListTile(
                  title: Text('Tag: ${scan.gameTag}'),
                  subtitle: Text(
                    'Time: ${scan.scanTime} | Result: ${scan.result} | Offline: ${scan.offline}',
                  ),
                );
              },
            ),
    );
  }
}
