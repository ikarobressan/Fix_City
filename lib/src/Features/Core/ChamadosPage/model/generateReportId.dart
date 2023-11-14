import 'dart:math';

class GenerateReportId {
  static String generateRandomNumber() {
    Random random = Random();
    String result = '';

    for (int i = 0; i < 13; i++) {
      result += random.nextInt(10).toString();
    }

    return result;
  }
}
