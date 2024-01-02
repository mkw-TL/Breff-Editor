void main() {
  String test = "abc";
  var out = test.substring(0, 3);
  try {
    var out2 = test.substring(4, 5);
    print("here");
  } catch (e) {
    print(e.runtimeType == RangeError);
  }
}
