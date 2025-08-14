import 'package:flutter/material.dart';

class AboutDialogWidget extends StatefulWidget {
  final String username;

  const AboutDialogWidget({Key? key, required this.username}) : super(key: key);

  @override
  _AboutDialogWidgetState createState() => _AboutDialogWidgetState();
}

class _AboutDialogWidgetState extends State<AboutDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.white),
                  SizedBox(width: 8),
                  Text('About', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '(Official Build) (64-bit)',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text('Application Version\n99.99.99', textAlign: TextAlign.center),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text('Database Version\n99.99.99', textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'SupplyWin App',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Copyright 2021 SupplyPro Inc. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [
                Text(
                  'Terms of Use',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
                Text(
                  'Privacy Policy',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
                Text(
                  'Terms of Services',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('CLOSE'),
            ),
          ],
        ),
      ),
    );
  }
}
