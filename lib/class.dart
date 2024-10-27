class User {
  String firstName;
  String lastName;
  String _username;
  String? _password;
  User(this.firstName, this.lastName, this._username, {String? password}) {
    _password = password;
  }
  get username => _username;
  get password => _password;
}

void main() {
  User user = User("firstName", "lastName", "Ausernamed", password: "password");
  print(user.password);
}
