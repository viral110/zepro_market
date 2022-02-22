class Tokens {
  String accessToken;
  bool newUser;
  String refreshToken;
  bool status;

  Tokens({this.accessToken, this.newUser, this.refreshToken, this.status});

  Tokens.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    newUser = json['new_user'];
    refreshToken = json['refresh_token'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['new_user'] = this.newUser;
    data['refresh_token'] = this.refreshToken;
    data['status'] = this.status;
    return data;
  }
}
