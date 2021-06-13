import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:food_/food/hotelfoodsection.dart';
import 'package:food_/orginal/hotels_foodveiw.dart';

class FoodHome extends StatefulWidget {
  const FoodHome({Key? key}) : super(key: key);

  @override
  _FoodHomeState createState() => _FoodHomeState();
}

class _FoodHomeState extends State<FoodHome> {
  List _products = [];
  List _hotels = [];
  List _imagerounder = [];
  List<Map<String, dynamic>> hotels = [];
  //==========Firebase datatabse collection key==============================
  CollectionReference<Map<String, dynamic>> _firestore =
      FirebaseFirestore.instance.collection('Hotel');

  CollectionReference<Map<String, dynamic>> _coursel =
      FirebaseFirestore.instance.collection('coursel');
  CollectionReference<Map<String, dynamic>> imagerounder =
      FirebaseFirestore.instance.collection('imagerounder');

  List courselimage = [];

  CarouselSliderController _sliderController = CarouselSliderController();

  ///=============get Coursel ==================
  getCoursels() async {
    List itemList = [];

    try {
      await _coursel.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemList.add(element.data());
        });

        courselimage = itemList;
      });
    } catch (e) {
      print("get error");

      return null;
    }
  }

  ///=============get image rounder ==================
  getimagerounder() async {
    List itemList = [];

    try {
      await imagerounder.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemList.add(element.data());
        });

        _imagerounder = itemList;
      });
    } catch (e) {
      print("get error");

      return null;
    }
  }

  //==================Hotels Data collected form database===============
  _getHotels() async {
    List itemList = [];

    try {
      print("getined0");
      _firestore.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemList.add(element.data());
        });

        _hotels = itemList;
        _setlist();
      });
    } catch (e) {
      print("get error");

      return null;
    }
  }

//=================set data from firestore to this hotels List=======================
  void _setlist() {
    int len = _hotels.length;

    for (int i = 0; i <= len - 1; i++) {
      setState(() {
        hotels.add(_hotels[i]);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _sliderController = CarouselSliderController();
    _getHotels();
    getCoursels();
    getimagerounder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: hotels.length + 4,
            itemBuilder: (BuildContext context, index) {
              return (hotels != null)
                  ? (index >= 4)
                      ? new GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Hotel_FoodView(
                                          dilverytime: hotels[index - 4]
                                              ['description2'],
                                          id: '${hotels[index - 4]['id']}',
                                          hotelname: hotels[index - 4]['Name'],
                                          hotelPlace: hotels[index - 4]
                                              ['Place'],
                                          status: hotels[index - 4]['status'],
                                        )));
                          },
                          /*child: ListTile(
                    trailing: Image.network('${hotels[index]['Image']}'),
                    title: Text(' ${hotels[index]['Name']}'),
                  ),*/
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  height: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 0.0,
                                        offset: Offset(2.0, 2.0), //(x,y)
                                        blurRadius: 5.0,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 200,
                                          child: Image.network(
                                            hotels[index - 4]['Image'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            Text(
                                              hotels[index - 4]['Name'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  hotels[index - 4]['Place'],
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (hotels[index - 4]['status'] ==
                                                        true)
                                                    ? Text(
                                                        ' Status : Open',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      )
                                                    : Text(
                                                        ' Status : Closed',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  hotels[index - 4]
                                                      ['description1'],
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            /*Text(
                                              hotels[index - 4]['description2'],
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),*/
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ]))))
                      : (index == 0)
                          ? headerSection()
                          : (index == 1)
                              ? imageCoursel()
                              : (index == 2)
                                  ? Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Top Features",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                        ],
                                      ),
                                    )
                                  : (index == 3)
                                      ? rounder()
                                      : Container()
                  : Text("Some ERorrr");
            }),
        /*child: ListView(
          children: [
            //================ 1st Heading===============
            headerSection(),
            //===========================image coursel======================
            imageCoursel(),
            //==============Side Scrolling List View==================
            Text(
              "Top Features",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            rounder(),
            hotelList(),
          ],
        ),*/
      ),
    );
  }

  ///=============REDDBUY HEader Section================
  Widget headerSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Reddbuy",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.red,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Food",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //===============Image coursel==============

  Widget imageCoursel() {
    return Container(
      height: 200,
      child: CarouselSlider.builder(
        unlimitedMode: true,
        controller: _sliderController,
        slideBuilder: (index) {
          return Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(courselimage[index]['url']),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        slideTransform: CubeTransform(),
        itemCount: courselimage.length,
        initialPage: 0,
        enableAutoSlider: true,
        autoSliderTransitionTime: Duration(seconds: 1),
        autoSliderDelay: Duration(seconds: 3),
      ),
    );
  }

  Widget rounder() {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _imagerounder.length,
          itemBuilder: (BuildContext context, index) {
            return (_imagerounder != null)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(_imagerounder[index]['url']),
                            fit: BoxFit.fill),
                      ),
                    ),
                  )
                : Text("Some ERorrr");
          }),
    );
  }

  Widget hotelList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: hotels.length,
        itemBuilder: (BuildContext context, index) {
          return (hotels != null)
              ? new GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FoodSection(
                                  hotelid: ' ${hotels[index]['id']}',
                                )));
                  },
                  /*child: ListTile(
                    trailing: Image.network('${hotels[index]['Image']}'),
                    title: Text(' ${hotels[index]['Name']}'),
                  ),*/
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          height: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 0.0,
                                offset: Offset(2.0, 2.0), //(x,y)
                                blurRadius: 5.0,
                              )
                            ],
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(hotels[index]['Image']),
                                ),
                                SizedBox(
                                    //width: 20,
                                    ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      hotels[index]['Name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      hotels[index]['description1'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      hotels[index]['description2'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ])))
                  /* Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                            image: NetworkImage(hotels[index]['Image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            " ${hotels[index]['Name']}",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )),
                  ),*/
                  )
              : Text("Some ERorrr");
        });
  }
}
