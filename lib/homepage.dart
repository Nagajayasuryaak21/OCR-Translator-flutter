import 'package:firebase_ml_vision_raw_bytes/firebase_ml_vision_raw_bytes.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'translator_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = '';
  File? image;
  ImagePicker? imagePicker;
  FlutterTts flutterTts = FlutterTts();

  pickImageFromGalary() async {
    PickedFile? pickedFile =
        await imagePicker?.getImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);

    setState(() {
      image;
      performImageLabeling();
    });
  }

  pickImageFromCamera() async {
    PickedFile? pickedFile =
        await imagePicker?.getImage(source: ImageSource.camera);
    image = File(pickedFile!.path);

    setState(() {
      image;
      performImageLabeling();
    });
  }

  performImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(image);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result = "";
    setState(() {
      for (TextBlock block in visionText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += element.text + " ";
          }
        }
        result += "\n";
      }
    });
    print(result);
  }

  void onPressedLanguage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TranslatorScreen(image: image, result: result);
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Center(
          child: Text(
            'Translator',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 8,
              child: image != null
                  ? Image.file(image!, fit: BoxFit.fill)
                  : Container(
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          "Select Photo",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        pickImageFromGalary();
                      },
                      child: Material(
                        color: Colors.black12.withOpacity(0),
                        child: Icon(
                          Icons.add_box_sharp,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: MaterialButton(
                      onPressed: () {
                        pickImageFromCamera();
                      },
                      child: Material(
                        color: Colors.black12.withOpacity(0),
                        child: Icon(
                          Icons.camera,
                          size: 50.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                    child: Container(
                      color: Colors.black38.withOpacity(0),
                      child: MaterialButton(
                        onPressed: () {
                          onPressedLanguage();
                        },
                        child: Container(
                          child: image != null
                              ? Icon(
                                  Icons.text_format,
                                  color: Colors.white,
                                )
                              : Container(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
