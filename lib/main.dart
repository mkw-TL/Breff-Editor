// import 'dart:async';
// import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_3/block_header.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:file_picker/file_picker.dart'; // other
import 'package:file_selector/file_selector.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:provider/provider.dart';
import 'subfile_header.dart';
import 'section_header.dart';
import 'subfile_data.dart';
import 'block_header.dart';
import 'subfile_table.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabbed_view/tabbed_view.dart';
// import 'package:get/get.dart';

List<Widget> subFileWidgets = <Widget>[];

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: const MyApp(),
  ));
  DesktopWindow.setMinWindowSize(Size(600, 400));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Namer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade300),
        textTheme: GoogleFonts.cabinCondensedTextTheme(textTheme),
      ),
      home: const Material(child: SubFilePage()),
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
  //
  Widget topMenu(context) {
    return SizedBox(
        child: Container(
      color: Colors.blue.shade200,
      child: Row(
        children: <Widget>[
          TextButton(onPressed: () => noop(), child: const Text("Save")),
          TextButton(onPressed: () => noop(), child: const Text("Save as")),
          TextButton(onPressed: () => noop(), child: const Text("Open")),
        ],
      ),
    ));
  }

  Widget tabs(context) {
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      Widget tabContent = Center(child: Text('Content $i'));
      tabs.add(TabData(text: 'Tab $i', content: tabContent));
    }

    TabbedViewThemeData themeData = TabbedViewThemeData();
    themeData.tabsArea
      ..border = Border(bottom: BorderSide(color: Colors.teal[500]!, width: 3))
      ..middleGap = 6;

    Radius radius = Radius.circular(10.0);
    BorderRadiusGeometry? borderRadius =
        BorderRadius.only(topLeft: radius, topRight: radius);

    themeData.tab
      ..padding = EdgeInsets.fromLTRB(10, 4, 10, 4)
      ..buttonsOffset = 8
      ..decoration = BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.teal[200],
          borderRadius: borderRadius)
      ..selectedStatus.decoration =
          BoxDecoration(color: Colors.teal[500], borderRadius: borderRadius)
      ..highlightedStatus.decoration =
          BoxDecoration(color: Colors.teal[200], borderRadius: borderRadius);

    return (ConstrainedBox(
      child: TabbedViewTheme(
        data: themeData,
        child: TabbedView(
            controller: TabbedViewController(tabs),
            contentBuilder: (BuildContext context, int tabIndex) {
              int i = tabIndex + 1;
              return Container(child: Text('Content $i'));
            }),
      ),
      constraints: BoxConstraints(maxHeight: 60),
    ));
  }

  Widget rowOfThree(context, str1, str2, str3) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 40, maxWidth: 350, minWidth: 100),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          str1,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Expanded(
          flex: 1,
          child: TextField(),
        ),
        Text(
          str2,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Expanded(
          flex: 1,
          child: TextField(),
        ),
        Text(
          str3,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Expanded(
          flex: 1,
          child: TextField(),
        ),
      ]),
    );
  }

  Widget firstColumn(BuildContext context) {
    // String col1Prim;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        rowOfThree(context, "Size", "Scale", "Rotation"),
        ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 200, height: 100),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: 20,
                          height: 20,
                          color: Colors.blueGrey.shade600),
                      Container(
                          width: 20, height: 20, color: Colors.green.shade300),
                      Container(
                          width: 20,
                          height: 20,
                          color: Colors.purpleAccent.shade400),
                      Container(width: 20, height: 20, color: Colors.black87),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Color 1 Primary",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                      Text("Color 1 Secondary",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                      Text("Color 2 Primary",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                      Text("Color 2 Secondary",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                    ],
                  )
                ],
              ),
            )),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: 70),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Texture 1 Name",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                Text("Texture 2 Name",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                Text("Texture 3 Name",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
              ]),
        ),
        rowOfThree(context, "mTex1", "mTex2", "mTex3"),
        rowOfThree(context, "texScale1", "texScale2", "texScale3"),
        rowOfThree(context, "texTranslate1", "texTranslate2", "texTranslate3"),
        rowOfThree(context, "texRotate1", "texRotate2", "texRotate3"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(onPressed: () => noop(), child: Text("texWarp?")),
            TextButton(onPressed: () => noop(), child: Text("texReverse?"))
          ],
        ),
      ],
    );
  }

  Widget alphaRefs(context) {
    return ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("AlphaComparison 0",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
                Container(width: 10),
                Expanded(
                  child: TextField(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("AlphaComparison 1",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
                Container(width: 10),
                Expanded(
                  child: TextField(
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                    // strutStyle: StrutStyle.fromTextStyle(
                    //     Theme.of(context).textTheme.bodyMedium!),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget randOffs(context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () => noop(), child: Text("Rot Offset Rand 1")),
              Container(width: 10),
              TextButton(
                  onPressed: () => noop(), child: Text("Input Text here"))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () => noop(), child: Text("Rot Offset Rand 2")),
              Container(width: 10),
              TextButton(
                  onPressed: () => noop(), child: Text("Input Text here"))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () => noop(), child: Text("Rot Offset Rand 3")),
              Container(width: 10),
              TextButton(
                  onPressed: () => noop(), child: Text("Input Text here"))
            ],
          ),
        ],
      ),
    );
  }

  Widget secondColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        alphaRefs(context),
        randOffs(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Rotate Offset",
                style: Theme.of(context).textTheme.bodyMedium),
            Expanded(
              flex: 1,
              child: TextField(),
            ),
            SizedBox(
              width: 10,
              height: 10,
            ),
            Expanded(
              flex: 1,
              child: TextField(),
            ),
            SizedBox(
              width: 10,
              height: 10,
            ),
            Expanded(
              flex: 1,
              child: TextField(),
            ),
          ],
        ),
        Text("Emitter Details", style: Theme.of(context).textTheme.bodyLarge),
        Column(
          children: [
            TextButton(onPressed: () => noop(), child: Text("Shape")),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () => noop(), child: Text("Point")),
                    TextButton(onPressed: () => noop(), child: Text("Disc")),
                    TextButton(onPressed: () => noop(), child: Text("Line")),
                    TextButton(onPressed: () => noop(), child: Text("Cube")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () => noop(), child: Text("Cylinder")),
                    TextButton(onPressed: () => noop(), child: Text("Sphere")),
                    TextButton(onPressed: () => noop(), child: Text("Torus")),
                  ],
                ),
              ],
            )
          ],
        ),
        TextButton(onPressed: () => noop(), child: Text("Dims")),
      ],
    );
  }

  Widget thirdColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: () => noop(), child: Text("Particle Details")),
        TextButton(
            onPressed: () => noop(), child: Text("Particle type, life, etc")),
        TextButton(onPressed: () => noop(), child: Text("TEV here")),
      ],
    );
  }

  Widget subFile(context) {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: firstColumn(context),
            )),
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: secondColumn(context),
            )),
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: thirdColumn(context),
            )),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue.shade100),
      child: Column(
        children: <Widget>[
          topMenu(context),
          tabs(context),
          subFile(context),
        ],
      ),
    );
  }
}
