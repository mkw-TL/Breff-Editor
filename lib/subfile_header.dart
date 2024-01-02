import 'package:flutter/material.dart';
import 'subfile_data.dart';

class SubFileHeader extends ChangeNotifier {
  List<String> splitAtExcl(String str, int index) {
    return [str.substring(0, index), str.substring(index, str.length)];
  }

  String data;
  late String asciiSubFile;
  late String subFileOffset;
  late String sizeDataBytes;
  late String asciiLen;
  late String asciiName;
  late String otherData;
  late SubFileData dat;

  SubFileHeader({required this.data}) {
    asciiLen = splitAtExcl(data, 8)[0];
    int len = int.parse(asciiLen, radix: 16);
    String thisData = splitAtExcl(data, 8)[1];
    asciiName = splitAtExcl(thisData, len * 2 - 1)[0]; // bytes and Uint16
    thisData = splitAtExcl(thisData, len * 2 - 1)[1]; // bytes and Uint16
    subFileOffset = splitAtExcl(thisData, 8)[0];
    thisData = splitAtExcl(thisData, 8)[1];
    sizeDataBytes = splitAtExcl(thisData, 8)[0];
    otherData = splitAtExcl(thisData, 8)[1];

    int offset = int.parse(subFileOffset, radix: 16);
    int lenDataBytes = int.parse(sizeDataBytes, radix: 16);

    dat = SubFileData(bytes: data, offset: offset, lenDataBytes: lenDataBytes);
  }

  String getStr() {
    StringBuffer out = StringBuffer();
    out.write(asciiLen);
    out.write(asciiSubFile);
    out.write("00"); // null terminator
    out.write(subFileOffset);
    out.write(sizeDataBytes);
    return out.toString();
  }

  String getAsciiName() {
    return asciiSubFile;
  }

  void setAsciiName(val) {
    if (val != null) {
      asciiSubFile = val;
      notifyListeners();
    } else {
      throw Exception(val);
    }
  }

  String getSubFileOffset() {
    return subFileOffset;
  }

  String getOtherData(data) {
    return otherData;
  }

  void setSubFileOffset(val) {
    if (val != null) {
      subFileOffset = val;
      notifyListeners();
    } else {
      throw Exception(val);
    }
  }

  String getSizeDataBytes() {
    return sizeDataBytes;
  }

  void setSizeDataBytes(val) {
    if (val != null) {
      sizeDataBytes = val;
      notifyListeners();
    } else {
      throw Exception(val);
    }
  }

  String getAsciiLen() {
    return asciiLen;
  }

  SubFileData getDat() {
    return dat;
  }
}
