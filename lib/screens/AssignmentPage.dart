import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'WidgetScreen.dart';

class AssignmentApp extends StatefulWidget {
  @override
  _AssignmentAppState createState() => _AssignmentAppState();
}

class _AssignmentAppState extends State<AssignmentApp> {
  List<Widget> widgetsOnPage = [];
  bool hasTextboxOrImage = false;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile; 

  Future<void> _pickImage(String source) async {
    final XFile? image = await _picker.pickImage(
      source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        widgetsOnPage.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: _imageFile == null
                  ? Center(child: Text("Tap to Upload Image"))
                  : Image.file(
                      _imageFile!,
                      fit: BoxFit.contain,  
                      width: double.infinity,  
                      height: double.infinity,
                    ),
            ),
          ),
        );
        hasTextboxOrImage = true;
      });
    }
  }

  void addWidgets(List<String> widgetTypes) {
    setState(() {
      for (var widgetType in widgetTypes) {
        if (widgetType == "Textbox") {
          widgetsOnPage.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter Text",
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          );
          hasTextboxOrImage = true;
        } else if (widgetType == "Imagebox") {
          widgetsOnPage.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Pick Image"),
                        content: Text("Choose source for image"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _pickImage('gallery');
                            },
                            child: Text("Gallery"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _pickImage('camera');
                            },
                            child: Text("Camera"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: Colors.grey[200],
                  child: _imageFile == null
                      ? Center(child: Text("Tap to Upload Image"))
                      : Image.file(
                          _imageFile!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                ),
              ),
            ),
          );
          hasTextboxOrImage = true;
        } else if (widgetType == "Save Button") {
          widgetsOnPage.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 160, 236, 177),
                  shape: RoundedRectangleBorder(),
                  side: BorderSide(
                    color: const Color.fromARGB(255, 27, 26, 26),
                    width: 2.0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () async {
                  if (!hasTextboxOrImage) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Add at least a Textbox or Imagebox to save!"),
                      ),
                    );
                  } else {
                    await saveDataToFirebase();
                  }
                },
                child: Text("Save"),
              ),
            ),
          );
        }
      }
    });
  }

  void resetState() {
    setState(() {
      widgetsOnPage.clear();
      hasTextboxOrImage = false;
      _imageFile = null;  
    });
  }

  Future<void> saveDataToFirebase() async {
    try {
      List<String> widgetData = [];
      for (var widget in widgetsOnPage) {
        if (widget is TextFormField) {
          widgetData.add((widget.controller?.text ?? ''));
        }
        if (widget is Image) {
          widgetData.add('ImagePathOrUrl');
        }
      }

      await FirebaseFirestore.instance.collection('widgets_data').add({
        'widgets': widgetData,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data saved successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving data: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Assignment App',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.06,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: resetState,
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView( 
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.75,  
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 241, 248, 239),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: widgetsOnPage.isEmpty
                    ? Center(
                        child: Text(
                          'No widget is added',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: widgetsOnPage,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.2, 
          0.0,
          MediaQuery.of(context).size.width * 0.2, 
          MediaQuery.of(context).size.height * 0.05, 
        ),
        child: ElevatedButton(
          onPressed: () async {
            final selectedWidgets = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WidgetScreen(),
              ),
            );

            if (selectedWidgets != null && selectedWidgets is List<String>) {
              resetState();
              addWidgets(selectedWidgets);
            }
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
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02), 
          ),
          child: Text(
            'Add Widgets',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.045, 
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
