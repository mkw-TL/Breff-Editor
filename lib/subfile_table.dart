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
  late List<SubFileHeader> headers = [];
  late List<SubFileData> subFileDataList = [];

  SubFileTable({required this.data}) {
    parseThis(data);
  }

  String getStr() {
    debugPrint("subFileTable is being getStr-ified");
    StringBuffer out = StringBuffer();
    out.write(sizeTable);
    out.write(numEntries);
    debugPrint("subFileTable has $numEntries number of entries");
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
    print("parsing subfile_table, ${data.substring(0, 12)}...");
    setSizeTable(splitAtExcl(data, 4 * 2)[0]);
    print("size of table is $sizeTable");
    String thisData = splitAtExcl(data, 8)[1];

    setNumEntries(splitAtExcl(thisData, 4)[0]);
    thisData = splitAtExcl(thisData, 4)[1];
    print("number of entries is, $numEntries");

    thisData = splitAtExcl(thisData, 4)[1]; // padding as well
    print("subfile table gives contains, $thisData");

    for (int i = 0; i < int.parse(numEntries, radix: 16); i++) {
      SubFileHeader header = SubFileHeader(data: thisData);
      print("subfile header parsed");
      appendToHeaderList(header);
      String offsetFromProjHeader = header.getSubFileOffset();
      debugPrint("our offsetFromProjHeader is ${offsetFromProjHeader}");
      String lenDataBytes = header.sizeDataBytes;
      SubFileData dat = SubFileData(
          bytes: data,
          offset: offsetFromProjHeader,
          lenDataBytes:
              lenDataBytes); // uses data, which is from the start of the Table
      appendToDataList(dat);
      print("subfile data parsed");
      thisData = header.getOtherData(thisData); // chop off header part
      debugPrint("our new header chopped is $thisData");
    }
  }

  void setSizeTable(String val) {
    sizeTable = int.parse(val, radix: 16).toRadixString(16).padLeft(8, "0");
    notifyListeners();
  }

  void setNumEntries(String val) {
    numEntries = int.parse(val, radix: 16).toRadixString(16).padLeft(4, "0");
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
