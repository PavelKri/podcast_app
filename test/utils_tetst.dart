// Import the test package and Counter class
import 'package:test/test.dart';
import 'package:flutter_podcast/utils/utils.dart';

void main() {
  test('Counter value should be incremented', () {
    var strResp = Utils.getTimesAgo(1620051354);
    expect(strResp, "9 days.ago");
    var str48642856 = Utils.getMinutsFromLength("48642856");
    expect(str48642856, "50:44");
    var str222437238 = Utils.getMinutsFromLength("222437238");
    expect(str222437238, "2:34:28");
    var str130329323 = Utils.getMinutsFromLength("130329323");
    expect(str130329323, "1:07:52");
  });
}
