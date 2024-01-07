import 'package:breff_editor/section_header.dart';

import 'block_header.dart';

void main() {
  Testing test = Testing();
  test.testBlockHeader();
  test.testSectionHeader();
}

class Testing {
  Testing();

  void testBlockHeader() {
    String bits = "000009C00010000152454646000009A801234567";
    BlockHeader block = BlockHeader(bytes: bits);
    print("block here");
    if (block.getOtherBytes(bits) != "01234567") {
      print("other bytes is false");
      print(block.getOtherBytes(bits));
    }
    if (block.getStr() != "000009C00010000152454646000009A8") {
      print("block str is false");
      print(block.getStr());
    }
    if (block.totalBytes != "000009C0") {
      print("tot bytes is false");
      print(block.totalBytes);
    }
    if (block.lenSectionBytesExcHeader != "000009A8") {
      print("len is false");
      print(block.lenSectionBytesExcHeader);
    }
    if (block.sizeHeader != "0010") {
      print("size header is false");
      print(block.sizeHeader);
    }
    print("block here2");
  }

  void testSectionHeader() {
    String bits =
        "0000001C000000000000000000090000726B5F656E7472790000000000000044";
    print("section here");
    SectionHeader sectionHeader = SectionHeader(bytes: bits);
    if (sectionHeader.getOtherBytes(bits) != "00000044") {
      print("section other bytes is false");
      print(sectionHeader.getOtherBytes(bits));
    }
    if (sectionHeader.asciiName != "726B5F656E747279") {
      print("ascii name is false");
      print(sectionHeader.asciiName);
    }
    if (sectionHeader.sectionHeaderSize != "0000001C") {
      print("section header size is false");
      print(sectionHeader.sectionHeaderSize);
    }
    if (sectionHeader.asciiLen != "0009") {
      print("ascii len is false");
      print(sectionHeader.asciiLen);
    }
    if (sectionHeader.getStr().toUpperCase() !=
        "0000001C000000000000000000090000726B5F656E74727900000000") {
      print("section str is false");
      print(sectionHeader.getStr());
    }
    print("section here2");
  }
}
