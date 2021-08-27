import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sqlite_flutter_app/database/db_helper.dart';

import 'model/dish.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  DBHelper.initDB();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String name, description;
  late double price;

  // var futureBuilderKey = GlobalKey();

  createData(){
    setState(() {
      DBHelper dbHelper = DBHelper();
      Dish dish = Dish(name: name,description: description,price:price);
      dbHelper.createDish(dish);
      print('${dish.name}  ${dish.description} ${dish.price}');
    });
  }

  updateData(){
    setState(() {
      DBHelper dbHelper = DBHelper();
      Dish dish = Dish(name: name,description: description,price:price);
      dbHelper.updateDish(dish);
    });
  }

  readData(){
      DBHelper dbHelper = DBHelper();
      Future<Dish> dish = dbHelper.readDish(name);
      dish.then((dishData) => null);
  }

  Future<List<Dish>> getAllData()async{
    DBHelper dbHelper = DBHelper();
    return await dbHelper.readAllDish();
  }

  deleteData() {
    setState(() {
      DBHelper dbHelper = DBHelper();
      dbHelper.deleteDish(name);
    });
  }

  void setName(String name) {
    this.name = name;
  }

  void setDescription(String description) {
    this.description = description;
  }

  void setPrice(double price) {
    this.price = price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite CRUD'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Name',
              ),
              onChanged: (String name) {
                setName(name);
              },
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Description',
              ),
              onChanged: (String description) {
                setDescription(description);
              },
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Price',
              ),
              onChanged: (String price) {
                setPrice(num.parse(price).toDouble());
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextButton(
                        onPressed: (){createData();},
                        child: Container(
                          width: 104.0,
                          height: 40.0,
                          alignment: Alignment.center,
                          color:Colors.green,
                          child: Text('Create',style: TextStyle(fontSize: 18.0,color: Colors.white,),),
                        ),
                      ),
                  ),
                  Expanded(
                      child: TextButton(
                        onPressed: (){readData();},
                        child: Container(
                          width: 104.0,
                          height: 40.0,
                          alignment: Alignment.center,
                          color:Colors.blue,
                          child: Text('Read',style: TextStyle(fontSize: 18.0,color: Colors.white,),),
                        ),
                      ),
                  ),
                  Expanded(
                      child: TextButton(
                        onPressed: (){updateData();},
                        child: Container(
                          width: 104.0,
                          height: 40.0,
                          alignment: Alignment.center,
                          color:Colors.orange,
                          child: Text('Update',style: TextStyle(fontSize: 18.0,color: Colors.white,),),
                        ),
                      ),
                  ),
                  Expanded(
                      child: TextButton(
                        onPressed: (){deleteData();},
                        child: Container(
                          width: 104.0,
                          height: 40.0,
                          alignment: Alignment.center,
                          color:Colors.red,
                          child: Text('Delete',style: TextStyle(fontSize: 18.0,color: Colors.white,),),
                        ),
                      ),
                  ),
                ],
              ),
            ),
            Row(
              textDirection: TextDirection.ltr,
              children: [
                Expanded(child: Text('Name:'),),
                Expanded(child: Text('Description:'),),
                Expanded(child: Text('Price:'),),
              ],
            ),
            FutureBuilder<List<Dish>>(
              future:getAllData() ,
              builder: (context,snapShot){
                if(snapShot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Row(
                          textDirection: TextDirection.ltr,
                          children: [
                            Expanded(
                              child: Text('${snapShot.data![index].name}'),),
                            Expanded(child: Text(
                                '${snapShot.data![index].description}'),),
                            Expanded(child: Text(
                                '${snapShot.data![index].price.toString()}'),),
                          ],
                        );
                      },
                      itemCount: snapShot.data!.length,),
                  );
                }else{

                  return Center(
                    child: Container(
                      child: Text('Add Data'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
