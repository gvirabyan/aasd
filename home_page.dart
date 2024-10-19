import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'history_page.dart'; // Import your HistoryPage
import 'settings_page.dart'; // Import your SettingsPage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0; // Track the currently selected page
  String _orderDetails = ''; // Variable to hold the order details

  // List of pages
  final List<Widget> _pages = [
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))), // Placeholder for Home Page
    HistoryPage(), // Reference to HistoryPage
    SettingsPage(), // Reference to SettingsPage
  ];

  @override
  void initState() {
    super.initState();
    _loadOrder(); // Load the stored order when the page initializes
  }

  // Load the order from shared preferences
  Future<void> _loadOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _orderDetails = prefs.getString('order') ?? ''; // Retrieve the order or set to empty
    });
  }

  // Function to switch pages when a button is pressed
  void _navigateToPage(int index) {
    setState(() {
      _currentPageIndex = index; // Update the current page index
    });
  }

  // Function to show the Add Order dialog
  void _showAddOrderDialog() {
    TextEditingController hourController = TextEditingController(); // Controller for hour input
    DateTime currentDate = DateTime.now(); // Initialize with the current date

    Future<void> _selectTime(BuildContext context) async {
      TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDate),
      );

      if (picked != null) {
        setState(() {
          // Format selected time and update the controller
          hourController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Start Date: ${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}'),
              TextField(
                readOnly: true, // Make it read-only
                decoration: InputDecoration(
                  labelText: 'Hour (HH:MM)',
                  hintText: 'Select time',
                ),
                onTap: () => _selectTime(context), // Open time picker on tap
                controller: hourController, // Display selected time
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String hour = hourController.text;
                String formattedDate = '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
                _saveOrder('$formattedDate $hour'); // Save the date and hour
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Add Order'),
            ),
          ],
        );
      },
    );
  }

  // Save the order to shared preferences
  Future<void> _saveOrder(String order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> orders = prefs.getStringList('orders') ?? []; // Get existing orders or create a new list
    orders.add(order); // Add the new order to the list
    await prefs.setStringList('orders', orders); // Save the updated list back to shared preferences
    setState(() {
      _orderDetails = order; // Update the order details in the state
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow, Colors.orange], // Gradient from yellow to orange
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content
            children: [
              if (_currentPageIndex == 0) // Only show Add Order on Home Page
                Center(
                  child: ElevatedButton(
                    onPressed: _showAddOrderDialog, // Show the add order dialog when pressed
                    child: Text('Add Order'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              SizedBox(height: 20), // Space before displaying the order details
              if (_orderDetails.isNotEmpty && _currentPageIndex == 0) // Show the order details if available and on Home Page
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Current Order: $_orderDetails',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
            ],
          ),
          // Bottom navigation buttons
          // Bottom navigation buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20), // Add padding for buttons
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _navigateToPage(0); // Navigate to Home
                    },
                    child: Text('Home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPageIndex == 0 ? Colors.orange : Colors.grey, // Change color based on selection
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      textStyle: TextStyle(fontSize: 18), // Larger font for buttons
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _navigateToPage(1); // Navigate to History
                    },
                    child: Text('History'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPageIndex == 1 ? Colors.orange : Colors.grey, // Change color based on selection
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      textStyle: TextStyle(fontSize: 18), // Larger font for buttons
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _navigateToPage(2); // Navigate to Settings
                    },
                    child: Text('Settings'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPageIndex == 2 ? Colors.orange : Colors.grey, // Change color based on selection
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      textStyle: TextStyle(fontSize: 18), // Larger font for buttons
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
