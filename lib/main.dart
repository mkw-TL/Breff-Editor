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
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';
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
  Color dialogSelectColor = Colors.blue.shade600;

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

Widget customText(String str, BuildContext context) {
  return Container(
    constraints: BoxConstraints(maxWidth: 100),
    child: TextField(
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: str,
            filled: true,
            isDense: true,
            fillColor: Colors.grey[400])),
  );
}

Widget topMenu(context) {
  return SizedBox(
      child: Container(
    color: Colors.blue.shade200,
    child: Row(
      children: [
        SizedBox(
          width: 200,
          child: Row(
            children: <Widget>[
              TextButton(
                  onPressed: () => AppState().saveAs(context),
                  child: const Text("Save")),
              TextButton(
                  onPressed: () => AppState().saveFile(),
                  child: const Text("Save as")),
              TextButton(
                  onPressed: () => AppState().pickFile(),
                  child: const Text("Open")),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("TL's BREFF Editor")],
          ),
        ),
        Row(children: [
          TextButton(onPressed: noop, child: Text("                ")),
          TextButton(onPressed: noop, child: Text("                ")),
          TextButton(onPressed: noop, child: Text("                ")),
        ])
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

    return (Container(
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

class SubFilePage extends StatefulWidget {
  const SubFilePage({super.key});

  @override
  State<SubFilePage> createState() => _SubFilePage();
}

class _SubFilePage extends State<SubFilePage> {
  Color col1 = Colors.black;
  Color col2 = Colors.black;
  Color col1_sec = Colors.black;
  Color col2_sec = Colors.black;
  Color dialogPickerColor1 = Colors.blue;
  Color dialogPickerColor1_sec = Colors.orange;
  Color dialogPickerColor2 = Colors.red;
  Color dialogPickerColor2_sec = Colors.black;
  bool texReverse = false;
  bool texWrap = false;
  bool alphaRef0 = false;
  bool alphaRef1 = false;
  bool partTransl = false;
  bool childPartTransl = false;
  bool childEmTransl = false;
  @override
  Widget build(context) {
    return subFile(context);
  }

  void updateDialogPickerColor2(Color color) {
    setState(() {
      dialogPickerColor2 = color;
    });
  }

  void updateDialogPickerColor1(Color color) {
    setState(() {
      dialogPickerColor1 = color;
    });
  }

  void updateDialogPickerColor2_sec(Color color) {
    setState(() {
      dialogPickerColor2_sec = color;
    });
  }

  void updateDialogPickerColor1_sec(Color color) {
    setState(() {
      dialogPickerColor1_sec = color;
    });
  }

  Future<bool> colorPickerDialog(
      Color whichColor, Function(Color) onColorChanged) async {
    return ColorPicker(
        // Use the dialogPickerColor as start color.
        color: whichColor,
        // Update the dialogPickerColor using the callback.
        onColorChanged: (Color color) async {
          print("color changed from $whichColor to $color");
          onColorChanged(color);
        },
        enableOpacity: true,
        enableShadesSelection: false,
        actionButtons: ColorPickerActionButtons(dialogCancelButtonLabel: "OK"),
        pickersEnabled: {
          ColorPickerType.wheel: true,
          ColorPickerType.primary: false,
          ColorPickerType.accent: false,
        }).showPickerDialog(context);
  }

  void updateCol2(Color newCol) async {
    final Color colorBeforeDialog = dialogPickerColor2;
    if (!(await colorPickerDialog(
        dialogPickerColor2, updateDialogPickerColor2))) {
      setState(() {
        dialogPickerColor2 = colorBeforeDialog;
      });
    }
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

    return (Container(
      constraints: BoxConstraints(maxHeight: 250),
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
                          Container(
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
                            Expanded(child: customText("?", context)),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            Text("mScale$i"),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            Expanded(child: customText("X", context)),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            Expanded(child: customText("Y", context)),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            Expanded(child: customText("Z", context)),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("mTranslate$i"),
                          ConstrainedBox(
                              constraints:
                                  BoxConstraints(minWidth: 10, maxWidth: 10)),
                          Expanded(child: customText("X", context)),
                          ConstrainedBox(
                              constraints:
                                  BoxConstraints(minWidth: 10, maxWidth: 10)),
                          Expanded(child: customText("Y", context)),
                          ConstrainedBox(
                              constraints:
                                  BoxConstraints(minWidth: 10, maxWidth: 10)),
                          Expanded(child: customText("Z", context))
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            Text("mRotate$i"),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            Expanded(child: customText("X deg", context)),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            Expanded(child: customText("Y deg", context)),
                            ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 10, maxWidth: 10)),
                            Expanded(child: customText("Z deg", context)),
                          ]),
                    ]),
              );
            }),
      ),
    ));
  }

  Widget firstColumn(BuildContext context) {
    void noop_col(Color color) {
      1 + 1;
    }

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
            Expanded(child: customText("Float", context)),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10)),
            Text("Scale"),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10)),
            Expanded(child: customText("Float", context)),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10)),
            Text("Rotation"),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10)),
            Expanded(child: customText("Degrees?", context)),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10)),
          ],
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 200, maxHeight: 130),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Color 1 Primary",
                      style: Theme.of(context).textTheme.bodySmall!),
                  ColorIndicator(
                    width: 44,
                    height: 44,
                    borderRadius: 4,
                    color: dialogPickerColor1,
                    onSelectFocus: false,
                    onSelect: () async {
                      // Store current color before we open the dialog.
                      final Color colorBeforeDialog = dialogPickerColor1;
                      // Wait for the picker to close, if dialog was dismissed,
                      // then restore the color we had before it was opened.
                      if (!(await colorPickerDialog(
                          dialogPickerColor1, updateDialogPickerColor1))) {
                        setState(() {
                          dialogPickerColor1 = colorBeforeDialog;
                        });
                      }
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  Text("Color 2 Primary",
                      style: Theme.of(context).textTheme.bodySmall!),
                  ColorIndicator(
                      width: 44,
                      height: 44,
                      borderRadius: 4,
                      color: dialogPickerColor2,
                      onSelectFocus: false,
                      onSelect: () async {
                        // Store current color before we open the dialog.
                        final Color colorBeforeDialog = dialogPickerColor2;
                        // Wait for the picker to close, if dialog was dismissed,
                        // then restore the color we had before it was opened.
                        if (!(await colorPickerDialog(
                            dialogPickerColor2, updateDialogPickerColor2))) {
                          setState(() {
                            dialogPickerColor2 = colorBeforeDialog;
                          });
                        }
                      }),
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
                  ColorIndicator(
                    width: 44,
                    height: 44,
                    borderRadius: 4,
                    color: dialogPickerColor1_sec,
                    onSelectFocus: false,
                    onSelect: () async {
                      // Store current color before we open the dialog.
                      final Color colorBeforeDialog = dialogPickerColor1_sec;
                      // Wait for the picker to close, if dialog was dismissed,
                      // then restore the color we had before it was opened.
                      if (!(await colorPickerDialog(dialogPickerColor1_sec,
                          updateDialogPickerColor1_sec))) {
                        setState(() {
                          dialogPickerColor1_sec = colorBeforeDialog;
                        });
                      }
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  Text("Color 2 Secondary",
                      style: Theme.of(context).textTheme.bodySmall!),
                  ColorIndicator(
                    width: 44,
                    height: 44,
                    borderRadius: 4,
                    color: dialogPickerColor2_sec,
                    onSelectFocus: false,
                    onSelect: () async {
                      // Store current color before we open the dialog.
                      final Color colorBeforeDialog = dialogPickerColor2_sec;
                      // Wait for the picker to close, if dialog was dismissed,
                      // then restore the color we had before it was opened.
                      if (!(await colorPickerDialog(dialogPickerColor2_sec,
                          updateDialogPickerColor2_sec))) {
                        setState(() {
                          dialogPickerColor2_sec = colorBeforeDialog;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("texWrap?"),
            Checkbox(
              value: texWrap,
              onChanged: (bool? newValue) {
                setState(() {
                  texWrap = newValue!;
                });
              },
            ),
            Text("texReverse?"),
            Checkbox(
                value: texReverse,
                onChanged: (bool? newValue) {
                  setState(() {
                    texReverse = newValue!;
                  });
                }),
          ],
        ),
        textTabs(context),
      ],
    );
  }

  Widget alphaRefs(context) {
    return Container(
        constraints: BoxConstraints.tightFor(height: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("AlphaComparison 0"),
                Container(width: 10),
                Checkbox(
                    value: alphaRef0,
                    onChanged: (bool? newValue) {
                      setState(
                        () {
                          alphaRef0 = newValue!;
                        },
                      );
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("AlphaComparison 1"),
                Container(width: 10),
                Checkbox(
                    value: alphaRef1,
                    onChanged: (bool? newValue) {
                      setState(
                        () {
                          alphaRef1 = newValue!;
                        },
                      );
                    }),
              ],
            ),
          ],
        ));
  }

  Widget randOffs(context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Rot Offset Rand"),
              Container(width: 10),
              Expanded(child: customText("X?", context)),
              Container(width: 10),
              Expanded(child: customText("Y?", context)),
              Container(width: 10),
              Expanded(child: customText("Z?", context)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Rotate Offset",
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("X deg", context)),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("Y deg", context)),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("Z deg", context)),
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
        Padding(
          padding: const EdgeInsets.all(1),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.teal[200],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Emitter Details",
                    style: Theme.of(context).textTheme.bodyLarge),
                ToggleSwitch(
                  minWidth: 60.0,
                  minHeight: 60.0,
                  fontSize: 14.0,
                  initialLabelIndex: 1,
                  activeBgColor: [Color.fromARGB(255, 28, 148, 157)],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: 7,
                  labels: [
                    'Disc',
                    'Line',
                    'Cube',
                    'Cylinder',
                    'Sphere',
                    'Point',
                    'Torus'
                  ],
                  onToggle: (index) {
                    print('switched to: $index');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      children: [Text("Dims"), Expanded(child: TextField())]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(7)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Inherit Translation",
                                style: Theme.of(context).textTheme.bodyLarge!),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Child Particle"),
                              Checkbox(
                                  value: childPartTransl,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      childPartTransl = newValue!;
                                    });
                                  }),
                              Text("Particle"),
                              Checkbox(
                                  value: partTransl,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      partTransl = newValue!;
                                    });
                                  }),
                              Text("Child Emitter"),
                              Checkbox(
                                  value: childEmTransl,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      childEmTransl = newValue!;
                                    });
                                  })
                            ]),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Life"),
                      Container(
                        width: 10,
                        height: 10,
                      ),
                      Expanded(child: customText("Int", context)),
                      Container(
                        width: 10,
                        height: 10,
                      ),
                      Text("Start"),
                      Container(
                        width: 10,
                        height: 10,
                      ),
                      Expanded(child: customText("Int", context)),
                      Container(
                        width: 10,
                        height: 10,
                      ),
                      Text("End"),
                      Container(
                        width: 10,
                        height: 10,
                      ),
                      Expanded(child: customText("Int", context)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Emitter Interval"),
                      Container(
                        width: 10,
                        height: 10,
                      ),
                      Expanded(child: customText("?", context)),
                      Container(
                        width: 10,
                        height: 10,
                      ),
                      Text("Interval Random"),
                      Container(
                        width: 10,
                        height: 10,
                      ),
                      Expanded(child: customText("?", context)),
                      Container(
                        width: 10,
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Emit Random"),
                      Container(
                        width: 10,
                        height: 10,
                      ),
                      Container(
                          constraints:
                              BoxConstraints(maxWidth: 70, minWidth: 40),
                          child: customText("?", context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        alphaRefs(context),
        randOffs(context),
      ],
    );
  }

  Widget thirdColumn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Emit Diversion"),
              Container(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("?", context)),
              Container(
                width: 10,
                height: 10,
              ),
              Text("Velocity random"),
              Container(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("?", context)),
              Container(
                width: 10,
                height: 10,
              ),
              Text("Momentum Random"),
              Container(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("?", context)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Emit Angle"),
              Container(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("Deg?", context)),
              Container(
                width: 10,
                height: 10,
              ),
              Text("Random Seed"),
              Container(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("Int", context)),
              Container(
                width: 10,
                height: 10,
              ),
              Text("Emit flags"),
              Container(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("???", context)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.teal[200],
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Power Radiation"),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                        Expanded(child: customText("?", context)),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                        Text("Power Y-axis value"),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                        Expanded(child: customText("?", context)),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                        Text("Power Random"),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                        Expanded(child: customText("?", context)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Power normal"),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                        Expanded(child: customText("?", context)),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                        Text("Diffison emitter normal"),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                        Expanded(child: customText("?", context)),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                        Text("Power Spec"),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                        Expanded(child: customText("?", context)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Diffusion normal"),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                        customText("?", context),
                        Container(
                          width: 10,
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("LOD nearest dist"),
              Container(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("?", context)),
              Container(
                width: 10,
                height: 10,
              ),
              Text("LOD farthest dist"),
              Container(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("?", context)),
              Container(
                width: 10,
                height: 10,
              ),
              Text("LOD min emission"),
              Container(
                width: 10,
                height: 10,
              ),
              Expanded(child: customText("?", context)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("LOD alpha"),
              Container(
                width: 10,
                height: 10,
              ),
              customText("?", context),
            ],
          ),
        ],
      ),
    );
  }

  Widget thirdColumnTabs(BuildContext context) {
    List<TabData> tabs = [];
    tabs.add(TabData(text: "Details", content: thirdColumn(context)));
    tabs.add(TabData(text: "TEV", content: Text("TEV HERE")));

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

    return Container(
      constraints: BoxConstraints(maxHeight: 250),
      child: TabbedViewTheme(
        data: themeData,
        child: TabbedView(
          controller: TabbedViewController(tabs),
          contentBuilder: (BuildContext context, int tabIndex) {
            int i = tabIndex + 1;
            return Animate(
                effects: [FadeEffect()], child: tabs[tabIndex].content!);
          },
        ),
      ),
    );
  }

  Widget subFile(context) {
    return Expanded(
        child: MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
          dividerPainter:
              DividerPainters.grooved1(highlightedColor: Colors.indigo[900]!)),
      child: MultiSplitView(initialAreas: [
        Area(weight: .25),
        Area(weight: .4),
        Area(weight: .35)
      ], children: [
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
