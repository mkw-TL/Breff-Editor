import 'package:flutter/material.dart';
// import 'package:breff_editor/main.dart';

// class SectionHeader extends ChangeNotifier {

class SectionHeader {
  List<String> splitAtExcl(String str, int index) {
    try {
      return [str.substring(0, index), str.substring(index, str.length)];
    } catch (e) {
      print(e);
      debugPrint(str);
      print(index);
      return [str.substring(0, index), str.substring(index, str.length)];
    }
  }

  String bytes;
  late String asciiName;
  late String sectionHeaderSize;
  late int size;
  late String asciiLen;
  late String otherBytes;

  SectionHeader({required this.bytes}) {
    sectionHeaderSize = splitAtExcl(bytes, 8)[0];
    size = int.parse(sectionHeaderSize, radix: 16);
    String thisBytes =
        splitAtExcl(bytes, size * 2)[0]; // chars rather than shorts
    // is suspect
    print(
        "initializing SectionHeader, end of section_header is ${bytes.substring(size * 2 - 8, size * 2)}");
    print(
        "initializing SectionHeader, start of subFileTable is ${bytes.substring(size * 2, size * 2 + 8)}");
    otherBytes = splitAtExcl(bytes, size * 2)[1]; // possible off by one error
    parseThis(thisBytes);
    // ascii + null pointer + fixed space for this and others
  }

  String getStr() {
    StringBuffer out = StringBuffer();
    debugPrint("writting from section header");
    out.write(sectionHeaderSize);
    out.write("00000000"); // previous pointer
    out.write("00000000"); // next pointer
    out.write(asciiLen);
    out.write("0000");
    out.write(asciiName);
    out.write("00"); // null terminator
    debugPrint("our sectionHeader gives (without extra zeros)");
    debugPrint(out.toString());
    int total_size =
        int.parse(sectionHeaderSize, radix: 16) * 2; // convert to chars
    int zeros_to_add = total_size - out.toString().length;
    debugPrint("with extra zeros we get");
    debugPrint(
        out.toString().padRight(out.toString().length + zeros_to_add, "0"));
    return out.toString().padRight(out.toString().length + zeros_to_add, "0");
  }

  String getOtherBytes(bytes) {
    return otherBytes;
  }

  void parseThis(bytes) {
    print("section_header deals with this data, $bytes");
    setSectionHeaderSize(splitAtExcl(bytes, 8)[0]);
    debugPrint(
        "in section_header. our section header size is $sectionHeaderSize");
    String thisBytes = bytes;
    thisBytes = splitAtExcl(thisBytes, 8)[1]; // jumps sec Head size
    thisBytes = splitAtExcl(thisBytes, 8)[1]; // jumps pointer to prev
    thisBytes = splitAtExcl(thisBytes, 8)[1]; // jumps pointer to next
    setAsciiLen(splitAtExcl(thisBytes, 4)[0]);
    thisBytes = splitAtExcl(thisBytes, 4)[1]; // jump over ascii length
    thisBytes = splitAtExcl(thisBytes, 4)[1]; // jumps over padding
    int asciiLenInt =
        (int.parse(asciiLen, radix: 16) - 1) * 2; // minus one bc null
    asciiName = splitAtExcl(thisBytes, asciiLenInt)[0];
    debugPrint("parsed section_header");
  }

  String getAsciiName() {
    return asciiName;
  }

  void setAsciiName(val) {
    if (val != null) {
      asciiName = val;
      asciiLen = (asciiName.length + 1).toRadixString(16).padLeft(4, "0");
      //notifyListeners();
    } else {
      throw Exception(val);
    }
  }

  String getSectionHeaderSize() {
    return sectionHeaderSize;
  }

  void setSectionHeaderSize(val) {
    sectionHeaderSize =
        int.parse(val, radix: 16).toRadixString(16).padLeft(8, "0");
  }

  void setAsciiLen(val) {
    asciiLen = int.parse(val, radix: 16).toRadixString(16).padLeft(4, "0");
  }

  String getAsciiLen() {
    return asciiName;
  }
}
