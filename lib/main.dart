import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_/food/checkoutpage.dart';
import 'package:food_/food/hotelfoodsection.dart';
import 'package:food_/orginal/food_home.dart';
import 'package:food_/orginal/hotels_foodveiw.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // home: MyHomePage(),
      home: FoodHome(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectionReference<Map<String, dynamic>> _firestore =
      FirebaseFirestore.instance.collection('Hotel');
  Stream<QuerySnapshot<Map<String, dynamic>>> hotels =
      FirebaseFirestore.instance.collection("Hotel").snapshots();
  List _products = [];
  List _hotels = [];
  String pro1 = "";
  bool _loadingProducts = false;

  _getHotels() async {
    print("clicked");
    List itemList = [];

    try {
      print("getined0");
      _firestore.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemList.add(element.data());

          if (itemList != null) {
            print("correct");
          }
        });

        _hotels = itemList;
        _setlist();
      });
    } catch (e) {
      print("get error");
      print("errrorrrrrrrrrrrr");
      print(e.toString());
      return null;
    }

    /* CollectionReference<Map<String, dynamic>> hotelcoll =
        _firestore.collection('hotels');

    Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot = hotelcoll.get();
    _products = hotelcoll.get().*/
  }

  @override
  void initState() {
    _getHotels();
    super.initState();
  }

  List<Map<String, dynamic>> hello = [
    {
      'id': 'udski',
      'Name': 'gsxjks',
      'Image':
          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg'
    },
  ];

  void _setlist() {
    int len = _hotels.length;
    print(len.toString());
    for (int i = 0; i <= len - 1; i++) {
      setState(() {
        hello.add(_hotels[i]);
      });
      int l = hello.length;
      print(l.toString());
      // print("${hello[l]['Name']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    String name;
    String imgurl;
    int count = _hotels.length;

    return Scaffold(
        appBar: AppBar(
          title: Text("food App"),
          backgroundColor: Colors.red,
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: hello.length,
            itemBuilder: (BuildContext context, index) {
              return (hello != null)
                  ? (index != 0)
                      ? new GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FoodSection(
                                          hotelid: ' ${hello[index]['id']}',
                                        )));
                          },
                          child: ListTile(
                            trailing: Image.network('${hello[index]['Image']}'),
                            title: Text(' ${hello[index]['Name']}'),
                          ),
                        )
                      : Container()
                  : Text("Some ERorrr");
            }));
  }
}

class HotelView extends StatelessWidget {
  String image;
  String name;
  HotelView({Key? key, required this.image, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imglink = image.toString();
    String _name = name.toString();
    return Container(
      color: Colors.blue,
      child: Row(
        children: [
          Text("helloo"),
          Image.network(
            imglink,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          ),
          Text("Hotel  : $name")
        ],
      ),
    );
  }
}
