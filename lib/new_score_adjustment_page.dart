import 'package:flutter/material.dart';
import 'package:wwgnfcscoringsystem/classes/database/datamanager.dart';

class NewScoreAdjustmentPage extends StatefulWidget {
  final int gameID;

  const NewScoreAdjustmentPage({Key? key, required this.gameID}) : super(key: key);

  @override
  State<NewScoreAdjustmentPage> createState() => _NewScoreAdjustmentPageState();
}

class _NewScoreAdjustmentPageState extends State<NewScoreAdjustmentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gameTagController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final DataManager _dataManager = DataManager();
  bool _isSubmitting = false;

  Future<void> _submitAdjustment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      bool success = await _dataManager.webAPI.submitScoreAdjustment(
        widget.gameID,
        _gameTagController.text,
        double.parse(_pointsController.text),
        _commentController.text,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Score adjustment submitted successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit score adjustment')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Score Adjustment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _gameTagController,
                decoration: const InputDecoration(labelText: 'Gametag'),
                validator: (value) => value!.isEmpty ? 'Please enter a Gametag' : null,
              ),
              TextFormField(
                controller: _pointsController,
                decoration: const InputDecoration(labelText: 'Points Adjustment'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter points' : null,
              ),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: 'Comment'),
                validator: (value) => value!.isEmpty ? 'Please enter a comment' : null,
              ),
              const SizedBox(height: 20),
              _isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitAdjustment,
                      child: const Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
