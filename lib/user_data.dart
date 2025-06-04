class UserData {
  // Singleton instance
  static final UserData _instance = UserData._internal();
  factory UserData() => _instance;
  UserData._internal();

  // Static backend IP address
  static const String backendIp = '172.16.122.51';


  // User data fields
  String? name;
  String? email;
  String? password;
  String? sport;

  // Optional: Future video recording data (placeholder)
  String? lastRecordedVideoPath;
  Map<String, dynamic>? videoAnalysisResults;

  // Save user data
  void saveUserData({
    required String name,
    required String email,
    required String password,
    required String sport,
  }) {
    this.name = name;
    this.email = email;
    this.password = password;
    this.sport = sport;
  }

  // Clear user data
  void clearUserData() {
    name = null;
    email = null;
    password = null;
    sport = null;
    lastRecordedVideoPath = null;
    videoAnalysisResults = null;
  }

  // Optional: Method to save video recording data (for future use)
  void saveVideoData({String? videoPath, Map<String, dynamic>? analysisResults}) {
    lastRecordedVideoPath = videoPath;
    videoAnalysisResults = analysisResults;
  }
}