// import 'dart:async';
// import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_3/block_header.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:file_picker/file_picker.dart'; // other
import 'package:file_selector/file_selector.dart';
import 'package:provider/provider.dart';
// import 'subfile_header.dart';
import 'section_header.dart';
// import 'subfile_data.dart';
// import 'block_header.dart';
import 'subfile_table.dart';
// import 'package:get/get.dart';

List<Widget> subFileWidgets = <Widget>[];

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: const MyApp(),
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const SubFilePage(),
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
        String tempString = byteList[i].toRadixString(16).padLeft(2, "0");
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
    print(res.length);
    // assert(res.length == int.parse(block.getThisBytes(), radix: 16));
  }
}

class SubFilePage extends StatefulWidget {
  const SubFilePage({super.key});

  @override
  State<SubFilePage> createState() => _SubFilePageState();
}

void noop() {
  1 + 1;
}

class _SubFilePageState extends State<SubFilePage> {
  Widget rowOfThree(BuildContext context, String str1, String str2, String str3) {
    return Flexible(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("$str1", textScaler: TextScaler.linear(.3)),
                Text("$str2", textScaler: TextScaler.linear(.3)),
                Text("$str3", textScaler: TextScaler.linear(.3)),
          ]),
        );
  }

  Widget firstColumn(BuildContext context) {
    String col1Prim;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        rowOfThree(context, "Size", "Scale", "Rotation"),
            Consumer<AppState>(
            builder: (context, appState, child) {
              // Access the phyl variable from the AppState
              col1Prim = appState.subFileTable.subFileDataList[0].col1Primary;
              ColoredBox(color: col1Prim)
            }

        // nop
        TextButton(onPressed: () => noop(), child: Text("Colors")),
        TextButton(onPressed: () => noop(), child: Text("Texture Names")),
        TextButton(onPressed: () => noop(), child: Text("Settings")),
        TextButton(onPressed: () => noop(), child: Text("mTex1, mtex2, mtex3")),
      ],
    );
  }

  Widget secondColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: () => noop(), child: Text("Misc")),
        TextButton(onPressed: () => noop(), child: Text("Misc Settings")),
        TextButton(onPressed: () => noop(), child: Text("Emitter Details")),
        TextButton(onPressed: () => noop(), child: Text("Shape")),
        TextButton(onPressed: () => noop(), child: Text("Dims")),
      ],
    );
  }

  Widget thirdColumn(BuildContext context) {
    return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () => noop(), child: Text("Particle Details")),
                TextButton(
                    onPressed: () => noop(),
                    child: Text("Particle type, life, etc")),
                TextButton(onPressed: () => noop(), child: Text("TEV here")),
              ],
            );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: Column(children: <Widget>[
        SizedBox(
            child: Container(
          color: Colors.blue.shade200,
          child: Row(
            children: <Widget>[
              TextButton(onPressed: () => noop(), child: const Text("Save")),
              TextButton(onPressed: () => noop(), child: const Text("Save as")),
              TextButton(onPressed: () => noop(), child: const Text("Open")),
            ],
          ),
        )),
        SizedBox(
          child: Container(
            color: Colors.blue.shade100,
            child: ElevatedButtonTheme(
              data: ElevatedButtonThemeData(
                  style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.teal.shade300),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 7)))),
              )),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    onPressed: () => noop(),
                    child: const Text("SubFile1"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      onPressed: () => noop(), child: const Text("SubFile2")),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      onPressed: () => noop(), child: const Text("SubFile3")),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      onPressed: () => noop(), child: const Text("+")),
                ),
              ]),
            ),
          ),
        ),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            firstColumn(context),
            secondColumn(context),
            thirdColumn(context),
          ],
        )),
      ]),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String phylDat = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reading and writing to files"),
      ),
      body: Column(
        children: [
          Consumer<AppState>(
            builder: (context, appState, child) {
              // Access the phyl variable from the AppState
              String phylInfo = appState.phyl?.name ?? "No file selected";
              phylDat = appState.bits;
              return Row(children: [Text(phylInfo), Text(phylDat)]);
            },
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () =>
                      Provider.of<AppState>(context, listen: false).pickFile(),
                  child: const Text("Get File")),
              TextButton(
                  onPressed: () => Provider.of<AppState>(context, listen: false)
                      .readFile(phylDat),
                  child: const Text("Read File"))
            ],
          ),
        ],
      ),
    );
  }
}
