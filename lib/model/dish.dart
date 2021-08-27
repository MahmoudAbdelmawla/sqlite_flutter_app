class Dish{
  late String name;
  late String description;
  late double price;

  Dish({required this.name,required this.description,required this.price});

  Dish.fromMap(Map map){
    this.name = map['name'];
    this.description = map['description'];
    this.price = map['price'];
  }
}