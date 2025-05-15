class Country{
  int ID;
  String Name;
  String Discription;
  Country(this.ID,this.Name,this.Discription);

  factory Country.fromDoc(dynamic d)=>
      Country(d['ID'], d['Name'], d['Discription']);
  Map<String , dynamic> toMap(){
    return {
      'ID':ID,
      'Name':Name,
      'Discription':Discription,
    };
  }
}
