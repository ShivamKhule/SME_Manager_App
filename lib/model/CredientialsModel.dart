class CredientialsModel{
  final String email;
  final String password;

  CredientialsModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> credientialsMap(){
    return {
      'email': email,
      'password': password,
    };
  }
}