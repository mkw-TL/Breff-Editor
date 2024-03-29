import 'package:flutter/material.dart';
import 'subfile_data.dart';

class SubFileHeader extends ChangeNotifier {
  List<String> splitAtExcl(String str, int index) {
    List<String> list = [];
    try {
      list = [str.substring(0, index), str.substring(index, str.length)];
    } catch (e) {
      print(e);
    }
    return list;
  }

  String data;
  late String subFileOffset;
  late String sizeDataBytes;
  late String asciiLen;
  late String asciiName;
  late String otherData;
  late SubFileData dat;

  SubFileHeader({required this.data}) {
    asciiLen = splitAtExcl(data, 4)[0];
    String thisData = splitAtExcl(data, 4)[1];

    int len = int.parse(asciiLen, radix: 16);
    print("our length of the ascii str is $len");

    asciiName = splitAtExcl(thisData, len * 2 - 2)[0]; // bytes and Uint16
    print("our ascii name in subfile_header is, $asciiName");
    thisData = splitAtExcl(thisData, len * 2)[1]; // ignores null terminator
    subFileOffset = splitAtExcl(thisData, 8)[0];
    print("our subFileOffset is $subFileOffset");
    thisData = splitAtExcl(thisData, 8)[1];
    sizeDataBytes = splitAtExcl(thisData, 8)[0];
    print("our sizeDataBytes is $sizeDataBytes");
    otherData = splitAtExcl(thisData, 8)[1];
    print("ending parsing subfile_header");
  }

  String getStr() {
    StringBuffer out = StringBuffer();
    out.write(asciiLen);
    out.write(asciiName);
    out.write("00"); // null terminator
    out.write(subFileOffset);
    out.write(sizeDataBytes);
    return out.toString();
  }

  String getDatSize() {
    return sizeDataBytes;
  }

  String getAsciiName() {
    return asciiName;
  }

  void setAsciiName(val) {
    if (val != null) {
      asciiName = val;
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
