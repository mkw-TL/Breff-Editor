import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_3/block_header.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart'; // other
import 'package:file_selector/file_selector.dart';
import 'package:provider/provider.dart';
import 'subfile_header.dart';
import 'section_header.dart';
import 'subfile_data.dart';
import 'block_header.dart';
import 'subfile_table.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: MainPage(),
    );
  }
}

List<String> splitAtExcl(String str, int index) {
  return [str.substring(0, index), str.substring(index, str.length)];
}

class AppState extends ChangeNotifier {
  XFile? phyl;
  String bits = "";
  late BlockHeader block;
  late SectionHeader sectionHeader;
  late SubFileTable subFileTable;

  XTypeGroup typeGroup = const XTypeGroup(
    label: 'images',
    extensions: <String>['breff'],
  );

  void pickFile() async {
    phyl = await openFile(acceptedTypeGroups: [typeGroup]);
    if (phyl != null) {
      debugPrint(phyl!.path.toString());
      debugPrint(phyl!.name.toString());
      Uint8List byteList = await phyl!.readAsBytes();
      StringBuffer buff = StringBuffer();
      int i = 0;
      for (var _ in byteList) {
        String tempString = byteList[i].toRadixString(16).padLeft(4, "0");
        buff.write(tempString);
        i++;
      }
      bits = buff.toString();
      debugPrint(bits);
      notifyListeners();
    }
  }

  void readFile(String bits) {
    bits = splitAtExcl(bits, 8)[1]; // remove first 8 bytes as padding
    block = BlockHeader(bytes: bits);
    bits = block.getOtherBytes(bits);
    sectionHeader = SectionHeader(bytes: bits);
    bits = sectionHeader.getOtherBytes(bits);
    subFileTable = SubFileTable(data: bits);
  }

  void saveFile() {
    StringBuffer out = StringBuffer();
    out.write("52454646FEFF0009");
    out.write(block.getStr());
    out.write(sectionHeader.getStr());
    out.write(subFileTable.getStr());
    String res = out.toString();
    assert(res.length == block.lenInBytes);
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reading and writing to files"),
      ),
      body: Row(
        children: [
          Consumer<AppState>(
            builder: (context, appState, child) {
              // Access the phyl variable from the AppState
              String phylInfo = appState.phyl?.name ?? "No file selected";
              return Center(
                child: Text(phylInfo),
              );
            },
          ),
          Center(
              child: TextButton(
                  onPressed: () =>
                      Provider.of<AppState>(context, listen: false).pickFile(),
                  child: Text("Get File")))
        ],
      ),
    );
  }
}
