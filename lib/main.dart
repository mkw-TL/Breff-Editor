// import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:breff_editor/block_header.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:file_picker/file_picker.dart'; // other
import 'package:file_selector/file_selector.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:multi_split_view/multi_split_view.dart';
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
      home: Material(
          child: Container(
        decoration: BoxDecoration(color: Colors.blue.shade100),
        child: Column(
          children: <Widget>[
            topMenu(context),
            const Tab(),
            const SubFilePage(),
          ],
        ),
      )),
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
  int subFileIdx = 1;

  XTypeGroup typeGroup = const XTypeGroup(
    label: 'images',
    extensions: <String>['breff'],
  );

  void pickFile() async {
    debugPrint(phyl.toString());
    if (phyl == null) {
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
        debugPrint(phyl.toString());
        // debugPrint(buff.toString());
        readFile(buff.toString());
        notifyListeners();
      }
    } else {
      print("There is an open file in the editor. Unimplemented functionality");
      // popup();
    }
  }

  void readFile(String bits) {
    bits = splitAtExcl(bits, 8 * 2)[1]; // remove first 8 bytes as padding
    block = BlockHeader(bytes: bits);
    bits = block.getOtherBytes(bits);
    debugPrint("block is getStr = ${block.getStr()}");
    sectionHeader = SectionHeader(bytes: bits);
    debugPrint("section header is getStr = ${sectionHeader.getStr()}");
    bits = sectionHeader.getOtherBytes(bits);
    subFileTable = SubFileTable(data: bits);
    debugPrint("in main, subFileTable is ${subFileTable.getStr()}");
  }

  Future<File?> saveFile() async {
    StringBuffer out = StringBuffer();
    out.write("52454646FEFF0009");
    out.write(block.getStr());
    out.write(sectionHeader.getStr());
    out.write(subFileTable.getStr());
    String res = out.toString();
    print(res.length);
    print(res);
    if (phyl == null) {
      noop(); // TODO
    }
    File file = File(phyl!.path);
    return file.writeAsString(res);
    // assert(res.length == int.parse(block.getThisBytes(), radix: 16));
  }

  void setIdx(int val) {
    subFileIdx = val;
  }

  void saveAs(context) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('This is a typical dialog.'),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      )
                    ]))));
    saveFile();
  }
}

void noop() {
  1 + 1;
}

Widget topMenu(context) {
  return SizedBox(
      child: Container(
    color: Colors.blue.shade200,
    child: Row(
      children: <Widget>[
        TextButton(
            onPressed: () => AppState().saveAs(context),
            child: const Text("Save")),
        TextButton(
            onPressed: () => AppState().saveFile(),
            child: const Text("Save as")),
        TextButton(
            onPressed: () => AppState().pickFile(), child: const Text("Open")),
      ],
    ),
  ));
}

class Tab extends StatelessWidget {
  const Tab({super.key});

  @override
  Widget build(BuildContext context) {
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
      constraints: BoxConstraints(maxHeight: 50),
      child: TabbedViewTheme(
        data: themeData,
        child: TabbedView(
            controller: TabbedViewController(tabs),
            contentBuilder: (BuildContext context, int tabIndex) {
              int i = tabIndex + 1;
              AppState().setIdx(i);
              return Animate(
                  effects: [FadeEffect()],
                  child: Container(child: Text('Content $i'))); // TODO
            }),
      ),
    ));
  }
}

class SubFilePage extends StatelessWidget {
  const SubFilePage({super.key});

  @override
  Widget build(context) {
    return subFile(context);
  }

  Widget textTabs(context) {
    int numActiveTexs = 3; // TODO
    List<TabData> tabs = [];
    for (var i = 1; i < numActiveTexs + 1; i++) {
      Widget tabContent = Center(child: Text('Tex $i'));
      tabs.add(TabData(text: 'Tex $i', content: tabContent));
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
      ..buttonsOffset = 4
      ..decoration = BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.teal[200],
          borderRadius: borderRadius)
      ..selectedStatus.decoration =
          BoxDecoration(color: Colors.teal[500], borderRadius: borderRadius)
      ..highlightedStatus.decoration =
          BoxDecoration(color: Colors.teal[200], borderRadius: borderRadius);

    return (ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 200),
      child: TabbedViewTheme(
        data: themeData,
        child: TabbedView(
            controller: TabbedViewController(tabs),
            contentBuilder: (BuildContext context, int tabIndex) {
              int i = tabIndex + 1;
              return Animate(
                effects: [FadeEffect()],
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Texture$i Name"),
                          ConstrainedBox(
                              constraints:
                                  BoxConstraints(minWidth: 10, maxWidth: 10)),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: 30, maxWidth: 100),
                            child: TextField(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                          ),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("mTex$i"),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 20),
                              child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            Text("mScale$i"),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 20),
                              child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 20),
                              child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 20),
                              child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("mTranslate$i"),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 20),
                              child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 20),
                              child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 20),
                              child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            Text("mRotate$i"),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 20),
                              child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 20),
                              child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 20),
                              child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ),
                          ]),
                    ]),
              );
            }),
      ),
    ));
  }

  Widget firstColumn(BuildContext context) {
    bool _texReverse = false;
    bool _texWrap = false;
    // String col1Prim;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Size"),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10)),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 50, minWidth: 20),
              child: TextField(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
            ),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10)),
            Text("Scale"),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10)),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 50, minWidth: 20),
              child: TextField(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
            ),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10)),
            Text("Rotation"),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10)),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 50, minWidth: 20),
              child: TextField(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
            ),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10)),
          ],
        ),
        ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 200, height: 130),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Color 1 Primary",
                          style: Theme.of(context).textTheme.bodySmall!),
                      Container(
                          width: 40,
                          height: 40,
                          color: Colors.blueGrey.shade600),
                      Container(
                        height: 10,
                      ),
                      Text("Color 2 Primary",
                          style: Theme.of(context).textTheme.bodySmall!),
                      Container(
                          width: 40, height: 40, color: Colors.green.shade300),
                    ],
                  ),
                  Container(
                    width: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Color 1 Secondary",
                          style: Theme.of(context).textTheme.bodySmall!),
                      Container(
                          width: 40,
                          height: 40,
                          color: Color.fromARGB(255, 20, 24, 101)),
                      Container(
                        height: 10,
                      ),
                      Text("Color 2 Secondary",
                          style: Theme.of(context).textTheme.bodySmall!),
                      Container(
                          width: 40,
                          height: 40,
                          color: const Color.fromARGB(255, 7, 49, 9)),
                    ],
                  ),
                ],
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("texWrap?"),
            Checkbox(
              value: _texWrap,
              onChanged: (bool? newValue) {
                //AppState().setTexWrap(newValue);
              },
            ),
            Text("texReverse?"),
            Checkbox(
                value: _texReverse,
                onChanged: (bool? newValue) {
                  //AppState().setTexReverse(newValue);
                }),
          ],
        ),
        textTabs(context),
      ],
    );
  }

  Widget alphaRefs(context) {
    bool _alphaRef0 = false;
    bool _alphaRef1 = false;
    return ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("AlphaComparison 0",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary)),
                    Container(width: 10),
                    Checkbox(
                        value: _alphaRef0,
                        onChanged: (bool? newValue) {
                          //AppState().setAlphaRef0(newValue);
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("AlphaComparison 1",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary)),
                    Container(width: 10),
                    Checkbox(
                        value: _alphaRef1,
                        onChanged: (bool? newValue) {
                          //AppState().setAlphaRef1(newValue);
                        }),
                  ],
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
        child: MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
          dividerPainter:
              DividerPainters.grooved1(highlightedColor: Colors.indigo[900]!)),
      child: MultiSplitView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: firstColumn(context),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: secondColumn(context),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: thirdColumn(context),
        ),
      ]),
    ));
  }
}
