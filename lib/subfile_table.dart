import 'package:flutter/material.dart';
import 'subfile_data.dart';
import 'subfile_header.dart';

class SubFileTable extends ChangeNotifier {
  List<String> splitAtExcl(String str, int index) {
    return [str.substring(0, index), str.substring(index, str.length)];
  }

  String data;
  late String sizeTable;
  late String numEntries;
  late List<SubFileHeader> headers;
  late List<SubFileData> subFileDataList;

  SubFileTable({required this.data}) {
    parseThis(data);
  }

  String getStr() {
    StringBuffer out = StringBuffer();
    out.write(sizeTable);
    out.write(numEntries);
    out.write("0000");
    for (SubFileHeader header in headers) {
      out.write(header.getStr());
    }
    for (SubFileData dat in subFileDataList) {
      out.write(dat.getStr());
    }
    return out.toString();
  }

  void parseThis(data) {
    setSizeTable(splitAtExcl(data, 8)[0]); // Uint16 remember
    String thisData = splitAtExcl(data, 8)[1];
    setNumEntries(splitAtExcl(data, 4)[0]);
    thisData = splitAtExcl(thisData, 8)[1]; // padding as well
    for (int i = 0; i < int.parse(numEntries, radix: 16); i++) {
      SubFileHeader header = SubFileHeader(data: thisData);
      appendToHeaderList(header);
      int offset = int.parse(header.getSubFileOffset() * 2, radix: 16);
      int lenDataBytes = int.parse(header.sizeDataBytes, radix: 16);
      SubFileData dat = SubFileData(
          bytes: thisData, offset: offset, lenDataBytes: lenDataBytes);
      appendToDataList(dat);
      thisData = header.getOtherData(thisData); // chop off header part
    }
  }

  void setSizeTable(String val) {
    sizeTable = val;
    notifyListeners();
  }

  void setNumEntries(String val) {
    sizeTable = val;
    notifyListeners();
  }

  void appendToHeaderList(SubFileHeader val) {
    headers.add(val);
    notifyListeners();
  }

  void appendToDataList(SubFileData val) {
    subFileDataList.add(val);
    notifyListeners();
  }
}
