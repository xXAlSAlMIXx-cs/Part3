class Order{
  int ID;
  DateTime date;
  String SelectedCountry;
  bool Aquarium;
  bool MallShopping;
  bool Teleferik;

  Order(this.ID,this.SelectedCountry,
      this.date,this.Aquarium,
      this.MallShopping,this.Teleferik);

  factory Order.fromDoc(dynamic r)=>
      Order(r['ID'], r['SelectedCountry'], r['date'], r['Aquarium'], r['MallShopping'],
          r['Teleferik']);

  Map<String , dynamic> toMap(){
    return{
      'ID' : ID,
      "SelectedCountry":SelectedCountry,
      'date':date,
      'Aquarium':Aquarium,
      'MallShopping':MallShopping,
      'Teleferik':Teleferik,
    };
  }
}