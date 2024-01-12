import 'package:flutter/material.dart';

//class BlockHeader extends ChangeNotifier {
class BlockHeader {
  List<String> splitAtExcl(String str, int index) {
    return [str.substring(0, index), str.substring(index, str.length)];
  }

  String bytes;
  late String totalBytes;
  late String sizeHeader;
  late String lenSectionBytesExcHeader;

  BlockHeader({required this.bytes}) {
    parseThis(bytes);
  }

  String getStr() {
    StringBuffer out = StringBuffer();
    out.write(totalBytes);
    out.write(sizeHeader);
    out.write("0001524546460000");
    out.write(lenSectionBytesExcHeader);
    String str = out.toString();
    return str;
  }

  void parseThis(bytes) {
    debugPrint("parsing block");
    String thisBytes = splitAtExcl(bytes, 16 * 2)[0]; // fixed block length
    debugPrint("thisBytes is ${thisBytes}");
    setTotalBytes(splitAtExcl(thisBytes, 8)[0]);
    thisBytes = splitAtExcl(thisBytes, 8)[1];
    setSizeHeader(splitAtExcl(thisBytes, 4)[0]);
    thisBytes = splitAtExcl(thisBytes, 4)[1];
    thisBytes = splitAtExcl(thisBytes, 12)[1];
    setLenSectionBytesExclHeader(splitAtExcl(thisBytes, 8)[0]);
  }

  String getThisBytes() {
    return splitAtExcl(bytes, 16 * 2)[0];
  }

  String getOtherBytes(bytes) {
    return splitAtExcl(bytes, 16 * 2)[1];
  }

  void setTotalBytes(String val) {
    totalBytes = int.parse(val, radix: 16).toRadixString(16).padLeft(8, "0");
    //notifyListeners();
  }

  void setSizeHeader(String val) {
    sizeHeader = int.parse(val, radix: 16).toRadixString(16).padLeft(2, "0");
    //notifyListeners();
  }

  void setLenSectionBytesExclHeader(String val) {
    lenSectionBytesExcHeader =
        int.parse(val, radix: 16).toRadixString(16).padLeft(4, "0");
    //notifyListeners();
  }
}
