// import 'package:flutter/material.dart';
// import 'package:flutter_app_3/main.dart';

// class SectionHeader extends ChangeNotifier {
class SectionHeader {
  List<String> splitAtExcl(String str, int index) {
    return [str.substring(0, index), str.substring(index, str.length)];
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
    String thisBytes = splitAtExcl(
        bytes, size * 2)[0]; // size in Uint16, rather than Uint8 (byte)
    otherBytes = splitAtExcl(bytes, size * 2)[1];
    parseThis(thisBytes);
    // ascii + null pointer + fixed space for this and others
  }

  String getStr() {
    StringBuffer out = StringBuffer();
    out.write(sectionHeaderSize);
    out.write("00000000"); // previous pointer
    out.write("00000000");
    out.write(asciiLen);
    out.write("0000");
    out.write(asciiName);
    out.write("00"); // null terminator
    int total_size =
        int.parse(sectionHeaderSize, radix: 16) * 2; // convert to bytes
    int zeros_to_add = total_size - out.toString().length;

    return out.toString().padRight(out.toString().length + zeros_to_add, "0");
  }

  String getOtherBytes(bytes) {
    return otherBytes;
  }

  void parseThis(bytes) {
    setSectionHeaderSize(splitAtExcl(bytes, 8)[0]);
    String thisBytes = (splitAtExcl(bytes, 24)[1]);
    setAsciiLen(splitAtExcl(thisBytes, 4)[0]);
    thisBytes = splitAtExcl(thisBytes, 4)[1];
    thisBytes = splitAtExcl(thisBytes, 4)[1]; // padding
    int asciiLenInt =
        (int.parse(asciiLen, radix: 16) - 1) * 2; // minus one bc null
    asciiName = splitAtExcl(thisBytes, asciiLenInt)[0];
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
    // not really sure if I should have this
    if (val != null) {
      sectionHeaderSize = val;
      //notifyListeners();
    } else {
      throw Exception(val);
    }
  }

  void setAsciiLen(val) {
    if (val != null) {
      asciiLen = val;
      //notifyListeners();
    } else {
      throw Exception(val);
    }
  }

  String getAsciiLen() {
    return asciiName;
  }
}
