import 'package:flutter/material.dart';
import 'language_data.dart';
import 'dart:io';
import 'package:translator/translator.dart';

class TranslatorScreen extends StatefulWidget {
  final image;
  final result;
  TranslatorScreen({required this.image, required this.result});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  String selectedCurrency = 'Tamil';
  String result = "";
  Translation? outPutTxt;
  File? image;
  GoogleTranslator? translator;
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in languages.keys) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      style: TextStyle(color: Colors.white, fontSize: 15.0),
      dropdownColor: Colors.black45,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });
      },
    );
  }

  void Update() {
    setState(() {
      result = widget.result;
      image = widget.image;
    });
    translator = GoogleTranslator();
    getResult();
  }

  void getResult() async {
    var translation = await translator?.translate("${result}",
        to: '${languages[selectedCurrency]}');
    print(translation);
    setState(() {
      outPutTxt = translation;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text(
          "Translator",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        color: Colors.black54,
                        height: 250.0,
                        padding: EdgeInsets.all(10),
                        child: InteractiveViewer(
                          panEnabled: false, // Set it to false
                          boundaryMargin: EdgeInsets.all(100),
                          minScale: 0.5,
                          maxScale: 2,
                          child: Image.file(image!),
                        )),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black54,
                      height: 250.0,
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            androidDropdown(),
                            SizedBox(
                              height: 10.0,
                            ),
                            Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.green,
                              child: MaterialButton(
                                elevation: 0,
                                color: Colors.green,
                                onPressed: () {
                                  getResult();
                                },
                                child: Text(
                                  "Get",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
                    child: Text(
                      outPutTxt != null ? "${outPutTxt}" : "",
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
