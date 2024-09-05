import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Section: Navigation Menu
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Order Search'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Order Search Page
              },
            ),
            ListTile(
              leading: Icon(Icons.print),
              title: Text('Select Printer'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Print Settings Page
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text('Product Display'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Print Settings Page
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('Opening Hours'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Print Settings Page
              },
            ),
            ListTile(
              leading: Icon(Icons.android),
              title: Text('Supportend Version'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Print Settings Page
              },
            ),
            Divider(),

            // Second Section: Dropdown Fields
// Second Section: Dropdown Fields
            Text('Select Audio:'),
            FutureBuilder<List<String>>(
              future: fetchAudios(), // Function to fetch dropdown data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading data');
                } else {
                  return Container(
                    width: double.infinity, // Make dropdown full width
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded:
                            true, // Make dropdown expand to fill the container
                        value: snapshot.data!.first,
                        items: snapshot.data!
                            .map((format) => DropdownMenuItem(
                                  value: format,
                                  child: Text(format),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // Handle print format change
                        },
                      ),
                    ),
                  );
                }
              },
            ),
            Text('Print Format:'),
            FutureBuilder<List<String>>(
              future: fetchPrintFormats(), // Function to fetch dropdown data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading data');
                } else {
                  return Container(
                    width: double.infinity, // Make dropdown full width
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded:
                            true, // Make dropdown expand to fill the container
                        value: snapshot.data!.first,
                        items: snapshot.data!
                            .map((format) => DropdownMenuItem(
                                  value: format,
                                  child: Text(format),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // Handle print format change
                        },
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            Text('Print Copies:'),
            FutureBuilder<List<int>>(
              future: fetchPrintCopies(), // Function to fetch dropdown data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading data');
                } else {
                  return Container(
                    width: double.infinity, // Make dropdown full width
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        isExpanded:
                            true, // Make dropdown expand to fill the container
                        value: snapshot.data!.first,
                        items: snapshot.data!
                            .map((copies) => DropdownMenuItem(
                                  value: copies,
                                  child: Text(copies.toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // Handle print copies change
                        },
                      ),
                    ),
                  );
                }
              },
            ),

            Divider(),

            // Third Section: Toggle Buttons
            SwitchListTile(
              title: Text('Home Delivery'),
              value: true, // Replace with your state variable
              onChanged: (bool value) {
                // Handle toggle for home delivery mode
              },
            ),
            SwitchListTile(
              title: Text('Online Ordering'),
              value: false, // Replace with your state variable
              onChanged: (bool value) {
                // Handle toggle for online order mode
              },
            ),
          ],
        ),
      ),
    );
  }

  // Mock API calls for dropdown data
  Future<List<String>> fetchPrintFormats() async {
    // Replace with actual API call
    return ['Print Fromat(CP)', 'Print Format Normal'];
  }
  // Mock API calls for dropdown data
  Future<List<String>> fetchAudios() async {
    // Replace with actual API call
    return ['Nice Alarm', 'School Bell'];
  }

  Future<List<int>> fetchPrintCopies() async {
    // Replace with actual API call
    return [0,1, 2, 3, 4, 5];
  }
}
