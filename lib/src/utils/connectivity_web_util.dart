enum QualityInternet { VeryPoor, Poor, Moderate, Good, VeryGood, Unknown }

class ConnectivityWebUtil {
  static QualityInternet getInternetQualityInfo(int value) {
    if (value == null || value <= 0) return QualityInternet.Unknown;
    if (value <= 200) {
      return QualityInternet.VeryGood;
    } else if (value <= 500) {
      return QualityInternet.Good;
    } else if (value <= 1000) {
      return QualityInternet.Moderate;
    } else if (value <= 2000) {
      return QualityInternet.Poor;
    } else {
      return QualityInternet.VeryPoor;
    }
  }
}
