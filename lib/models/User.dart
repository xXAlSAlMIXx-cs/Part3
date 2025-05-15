class User{
  String Email;
  String Password;
  String UserName;
  User(this.Email,this.Password,this.UserName);

  factory User.fromDoc(dynamic d)=>
      User(d["Email"], d["Password"], d["UserName"]);
  Map<String , dynamic> toMap(){
    return {"Email":Email,"Password":Password,"UserName":UserName};
  }
}