//import 'package:flutter/material.dart';

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
    out.write("000152454646");
    out.write(lenSectionBytesExcHeader);
    String str = out.toString();
    return str;
  }

  void parseThis(bytes) {
    String thisBytes = splitAtExcl(bytes, 24 * 2)[0];
    thisBytes = splitAtExcl(thisBytes, 8 * 2)[1]; // ignore first 8 chars
    setTotalBytes(splitAtExcl(thisBytes, 8)[0]);
    thisBytes = splitAtExcl(thisBytes, 8)[1];
    setSizeHeader(splitAtExcl(thisBytes, 4)[0]);
    thisBytes = splitAtExcl(thisBytes, 4)[1];
    thisBytes = splitAtExcl(thisBytes, 12)[1];
    setLenSectionBytesExclHeader(splitAtExcl(thisBytes, 8)[0]);
    thisBytes = splitAtExcl(thisBytes, 8)[1];
    if (thisBytes.length != 0) {
      print("thisBytes not zero (block header)");
      print(thisBytes);
    }
  }

  String getThisBytes() {
    return splitAtExcl(bytes, 32)[0];
  }

  String getOtherBytes(bytes) {
    return splitAtExcl(bytes, 24 * 2)[1];
  }

  void setTotalBytes(String val) {
    totalBytes = val;
    //notifyListeners();
  }

  void setSizeHeader(String val) {
    sizeHeader = val;
    //notifyListeners();
  }

  void setLenSectionBytesExclHeader(String val) {
    lenSectionBytesExcHeader = val;
    //notifyListeners();
  }
}
