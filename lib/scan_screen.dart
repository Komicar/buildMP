import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'database_helper.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(camera, ResolutionPreset.high);
    _initializeControllerFuture = _cameraController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _scanText() async {
    if (_isDetecting) return;
    setState(() {
      _isDetecting = true;
    });

    try {
      await _initializeControllerFuture;
      final image = await _cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final text = line.text;
          final info = await DatabaseHelper().getClassroomInfo(text);
          if (info != null) {
            _showClassroomInfo(info);
            setState(() {
              _isDetecting = false;
            });
            return;
          }
        }
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      _isDetecting = false;
    });
  }

  void _showClassroomInfo(String info) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Classroom Info'),
        content: Text(info),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_cameraController),
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _scanText,
                      child: Text('Scan'),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
