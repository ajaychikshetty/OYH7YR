import 'package:flutter/material.dart';

class WidgetScreen extends StatefulWidget {
  @override
  _WidgetScreenState createState() => _WidgetScreenState();
}

class _WidgetScreenState extends State<WidgetScreen> {
  Map<String, bool> widgetSelections = {
    "Textbox": false,
    "Imagebox": false,
    "Save Button": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: null,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            _buildWidgetItem("Textbox"),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            _buildWidgetItem("Imagebox"),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            _buildWidgetItem("Save Button"),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.2, // 20% of screen width
          0.0,
          MediaQuery.of(context).size.width * 0.2, // 20% of screen width
          MediaQuery.of(context).size.height * 0.05, // 5% of screen height
        ),
        child: ElevatedButton(
          onPressed: () {
            final selectedWidgets = widgetSelections.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList();

            Navigator.pop(context, selectedWidgets);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 160, 236, 177),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            side: BorderSide(
              color: const Color.fromARGB(255, 27, 26, 26),
              width: 2.0,
            ),
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02), // 2% of screen height
          ),
          child: Text(
            'Import Widgets',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04, // 4% of screen width
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetItem(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widgetSelections[title] = !(widgetSelections[title] ?? false);
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1, // 10% of screen width
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 215, 213, 213),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05), // 5% of screen width
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.circle,
                      color: widgetSelections[title] == true
                          ? Colors.green
                          : Colors.grey,
                      size: MediaQuery.of(context).size.width * 0.05, // Dynamic size for circle
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05, // Dynamic font size based on screen width
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
