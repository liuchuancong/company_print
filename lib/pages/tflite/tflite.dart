import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

class TflitePage extends StatefulWidget {
  const TflitePage({super.key});

  @override
  State<TflitePage> createState() => _TflitePageState();
}

class _TflitePageState extends State<TflitePage> {
  String _ocrText = '';
  Map<String, String> tessimgs = {
    "kor": "https://raw.githubusercontent.com/khjde1207/tesseract_ocr/master/example/assets/test1.png",
    "en": "https://tesseract.projectnaptha.com/img/eng_bw.png",
    "ch_sim": "https://tesseract.projectnaptha.com/img/chi_sim.png",
    "ru": "https://tesseract.projectnaptha.com/img/rus.png",
  };
  var langList = ["kor", "eng", "deu", "chi_sim"];
  var selectList = ["eng", "kor"];
  String path = "";
  bool bload = false;

  bool bDownloadtessFile = false;
  // "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FqCviW%2FbtqGWTUaYLo%2FwD3ZE6r3ARZqi4MkUbcGm0%2Fimg.png";
  var urlEditController = TextEditingController()..text = "https://tesseract.projectnaptha.com/img/eng_bw.png";

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void runFilePiker() async {
    // android && ios only
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _ocr(pickedFile.path);
    }
  }

  void _ocr(url) async {
    if (selectList.isEmpty) {
      return;
    }
    path = url;
    if (kIsWeb == false && (url.indexOf("http://") == 0 || url.indexOf("https://") == 0)) {
      Directory tempDir = await getTemporaryDirectory();
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      String dir = tempDir.path;
      File file = File('$dir/test.jpg');
      await file.writeAsBytes(bytes);
      url = file.path;
    }
    var langs = selectList.join("+");

    bload = true;
    setState(() {});

    _ocrText = await FlutterTesseractOcr.extractText(url, language: langs, args: {
      "preserve_interword_spaces": "1",
    });

    bload = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('android tesseract ocr'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  title: const Text('Select Url'),
                                  children: tessimgs
                                      .map((key, value) {
                                        return MapEntry(
                                            key,
                                            SimpleDialogOption(
                                                onPressed: () {
                                                  urlEditController.text = value;
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(key),
                                                    const Text(" : "),
                                                    Flexible(child: Text(value)),
                                                  ],
                                                )));
                                      })
                                      .values
                                      .toList(),
                                );
                              });
                        },
                        child: const Text("urls")),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'input image url',
                        ),
                        controller: urlEditController,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _ocr(urlEditController.text);
                        },
                        child: const Text("Run")),
                  ],
                ),
                Row(
                  children: [
                    ...langList.map((e) {
                      return Row(children: [
                        Checkbox(
                            value: selectList.contains(e),
                            onChanged: (v) async {
                              // dynamic add Tessdata
                              if (kIsWeb == false) {
                                Directory dir = Directory(await FlutterTesseractOcr.getTessdataPath());
                                if (!dir.existsSync()) {
                                  dir.create();
                                }
                                bool isInstalled = false;
                                dir.listSync().forEach((element) {
                                  String name = element.path.split('/').last;
                                  // if (name == 'deu.traineddata') {
                                  //   element.delete();
                                  // }
                                  isInstalled |= name == '$e.traineddata';
                                });
                                if (!isInstalled) {
                                  bDownloadtessFile = true;
                                  setState(() {});
                                  HttpClient httpClient = HttpClient();
                                  HttpClientRequest request = await httpClient.getUrl(
                                      Uri.parse('https://github.com/tesseract-ocr/tessdata/raw/main/$e.traineddata'));
                                  HttpClientResponse response = await request.close();
                                  Uint8List bytes = await consolidateHttpClientResponseBytes(response);
                                  String dir = await FlutterTesseractOcr.getTessdataPath();
                                  File file = File('$dir/$e.traineddata');
                                  await file.writeAsBytes(bytes);
                                  bDownloadtessFile = false;
                                  setState(() {});
                                }
                              }
                              if (!selectList.contains(e)) {
                                selectList.add(e);
                              } else {
                                selectList.remove(e);
                              }
                              setState(() {});
                            }),
                        Text(e)
                      ]);
                    }),
                  ],
                ),
                Expanded(
                    child: ListView(
                  children: [
                    path.isEmpty
                        ? Container()
                        : path.contains("http")
                            ? Image.network(path)
                            : Image.file(File(path)),
                    bload
                        ? const Column(children: [CircularProgressIndicator()])
                        : Text(
                            _ocrText,
                          ),
                  ],
                ))
              ],
            ),
          ),
          Container(
            color: Colors.black26,
            child: bDownloadtessFile
                ? const Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator(), Text('download Trained language files')],
                  ))
                : const SizedBox(),
          )
        ],
      ),

      floatingActionButton: kIsWeb
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                runFilePiker();
                // _ocr("");
              },
              tooltip: 'OCR',
              child: const Icon(Icons.add),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
