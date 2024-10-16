class LibraryConstants {
  static List<String> cannotGoBackUrls = [
    "/banking/[^/]+/(saving|fixed|credit_card)\$"
  ];
  static bool deviceBindingEnabled = true;

  static List<String> openExternally = [""];
  static List<String> whitelistedUrls = [
    "razorpay.com",
  ];
  static String hostName = "https://partner.uat.spense.money";

  static void setWhitelistedUrls(List<String> urls) {
    whitelistedUrls = urls;
  }

  static void setHostName(String host) {
    hostName = host;
  }
}
