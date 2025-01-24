// File: report_generator_page.dart

import 'package:flutter/material.dart';

class ReportGeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generate Custom Reports',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Report Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add functionality to export as PDF
                    },
                    icon: Icon(Icons.picture_as_pdf),
                    label: Text('Export to PDF'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add functionality to export as Excel
                    },
                    icon: Icon(Icons.table_chart),
                    label: Text('Export to Excel'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with the actual report templates count
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.description, color: Colors.green),
                      title: Text('Report Template #${index + 1}'),
                      subtitle: Text('Details about template #${index + 1}.'),
                      onTap: () {
                        // Add functionality to use selected template
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
