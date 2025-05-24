class UserData {
  static final UserData _instance = UserData._internal();
  factory UserData() => _instance;
  UserData._internal();
  String? name;
  String? email;
  String? password;
  String? sport;

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
  void clearUserData() {

    name = null;
    email = null;
    password = null;
    sport = null;


  }
}
///later on will add  video  recording  function