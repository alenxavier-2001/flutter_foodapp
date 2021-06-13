import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_/food/cart.dart';
import 'package:food_/orginal/hotelcartPage.dart';

import 'package:food_/orginal/widgets/widgets.dart';

class Hotel_FoodView extends StatefulWidget {
  String dilverytime;
  String hotelPlace;
  String id;
  String hotelname;
  bool status;
  Hotel_FoodView(
      {Key? key,
      required this.dilverytime,
      required this.status,
      required this.id,
      required this.hotelname,
      required this.hotelPlace})
      : super(key: key);

  @override
  _Hotel_FoodViewState createState() => _Hotel_FoodViewState();
}

class _Hotel_FoodViewState extends State<Hotel_FoodView> {
  List _products = [];
  List cartProduct = [];
  int totalprice = 0;
  int total = 0;

  List<Map<String, dynamic>> products = [];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //================= To Check Which Hotel ==============
  _checkhotel() {
    // print(widget.id);
    String id = '${widget.id}';
    if (id == '100') {
      _getproducts('100');
    } else if (id == '101') {
      _getproducts('101');
    } else if (id == '102') {
      _getproducts('102');
    } else if (id == '103') {
      _getproducts('103');
    } else if (id == '104') {
      _getproducts('104');
    } else if (id == '105') {
      _getproducts('105');
    }
  }

  //=========Get Hotel Products=====================
  _getproducts(String temp) async {
    List itemList = [];

    try {
      CollectionReference reference = _firestore.collection(temp);

      await reference.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemList.add(element.data());
        });

        _products = itemList;
        _setlist();
      });
    } catch (e) {
      print("get error");

      return null;
    }
  }

  //============= To Set DupliCate List For Avoid ERror===================
  void _setlist() {
    int len = _products.length;

    for (int i = 0; i <= len - 1; i++) {
      setState(() {
        products.add(_products[i]);
      });
    }
  }

  //=========================Increment Food Count ======================

  _increment(String id) {
    List ko = products;
    int len = ko.length;

    for (int i = 0; i <= len - 1; i++) {
      if (products[i]['id'] == id) {
        setState(() {
          products[i]['count'] = products[i]['count'] + 1;
          products[i]['totalprice'] =
              products[i]['totalprice'] + products[i]['Price'];
        });
      }
    }
    _checktotalprice();
  }

  /* _increment(String id) {
    List ko = products;
    int len = ko.length;
    print(len.toString());
    for (int i = 0; i <= len - 1; i++) {
      if (products[i]['id'] == id) {
        setState(() {
          products[i]['count'] = products[i]['count'] + 1;
          products[i]['totalprice'] =
              products[i]['totalprice'] + products[i]['Price'];

          int cartlen = cartProduct.length;
          for (int k = 0; k <= cartlen - 1; k++) {
            if (cartProduct[k]['id'] == id) {
              cartProduct[k]['totalprice'] =
                  cartProduct[k]['totalprice'] + cartProduct[k]['Price'];
              int tempval = cartProduct[k]['Price'];
              totalprice = totalprice + tempval;
            }
          }

          print(id);
        });
      }
    }
  }*/

  //========================= Decrement Food Count ======================
  _decrement(String id) {
    List ko = products;
    int len = ko.length;

    for (int i = 0; i <= len - 1; i++) {
      if (products[i]['id'] == id) {
        setState(() {
          if (products[i]['count'] > 1) {
            products[i]['count'] = products[i]['count'] - 1;
            products[i]['totalprice'] =
                products[i]['totalprice'] - products[i]['Price'];

            int cartlen = cartProduct.length;
            for (int k = 0; k <= cartlen - 1; k++) {
              if (cartProduct[k]['id'] == id) {
                print(cartProduct[k]['count'].toString());
                cartProduct[k]['count'] = products[i]['count'];
                cartProduct[k]['totalprice'] = products[i]['totalprice'];
              }
            }
          } else {
            products[i]['count'] = 1;
            int cartlen = cartProduct.length;
            for (int k = 0; k <= cartlen - 1; k++) {
              if (cartProduct[k]['id'] == id) {
                cartProduct[k]['count'] = 1;
              }
            }
          }
        });
      }

      int l = products.length;
      print(l.toString());
      // print("${hello[l]['Name']}");
    }
    _checktotalprice();
  }
  /* _decrement(String id) {
    List ko = products;
    int len = ko.length;
    print(len.toString());
    for (int i = 0; i <= len - 1; i++) {
      if (products[i]['id'] == id) {
        setState(() {
          if (products[i]['count'] > 1) {
            products[i]['count'] = products[i]['count'] - 1;
            products[i]['totalprice'] =
                products[i]['totalprice'] - products[i]['Price'];

            int cartlen = cartProduct.length;
            for (int k = 0; k <= cartlen - 1; k++) {
              if (cartProduct[k]['id'] == id) {
                cartProduct[k]['totalprice'] =
                    cartProduct[k]['totalprice'] - cartProduct[k]['Price'];
                int tempval = cartProduct[k]['Price'];
                totalprice = totalprice - tempval;
              }
            }
          } else {
            int cartlen = cartProduct.length;
            products[i]['count'] = 1;
            for (int i = 0; i <= cartlen - 1; i++) {
              if (cartProduct[i]['id'] == id) {
                cartProduct[i]['totalprice'] =
                    cartProduct[i]['totalprice'] - cartProduct[i]['Price'];
                int tempval = cartProduct[i]['Price'];
                totalprice = totalprice - tempval;
              }
            }
          }
        });
      }
    }
  }*/

  //=============================Addto Cart Function ================

  _addtocart(String id) {
    List ko = products;
    int len = ko.length;

    for (int i = 0; i <= len - 1; i++) {
      if (products[i]['id'] == id) {
        if (products[i]['addto'] == false) {
          setState(() {
            products[i]['addto'] = true;

            cartProduct.add(products[i]);
          });
        } else if (products[i]['addto'] = true) {
          setState(() {
            products[i]['addto'] = false;

            try {
              if (cartProduct != null) {
                int lenn = cartProduct.length;
                for (int j = 0; j <= lenn - 1; j++) {
                  if (cartProduct[j]['id'] == id) {
                    cartProduct.removeAt(j);
                  }
                }
              }
            } catch (e) {}
          });
        }
        _checktotalprice();
      }

      // print("${hello[l]['Name']}");
    }
  }

  /*_addtocart(String id) {
    List ko = products;
    int len = ko.length;

    for (int i = 0; i <= len - 1; i++) {
      if (products[i]['id'] == id) {
        if (products[i]['addto'] == false) {
          setState(() {
            products[i]['addto'] = true;
            int temprice = products[i]['totalprice'];
            totalprice = totalprice + temprice;

            cartProduct.add(products[i]);
          });
        } else if (products[i]['addto'] = true) {
          setState(() {
            products[i]['addto'] = false;

            try {
              if (cartProduct != null) {
                int lenn = cartProduct.length;
                for (int j = 0; j <= lenn - 1; j++) {
                  if (cartProduct[j]['id'] == id) {
                    print(lenn.toString());
                    int temprice = products[i]['totalprice'];
                    print(temprice.toString());
                    totalprice = totalprice - temprice;
                    cartProduct.removeAt(j);
                  }
                }
              }
            } catch (e) {}
          });
        }
      }
    }
  }*/
  _checktotalprice() {
    if (cartProduct != null) {
      print("activiateddddddddddd");
      int leng = cartProduct.length;
      print(leng.toString());
      totalprice = 0;
      for (int i = 0; i <= leng - 1; i++) {
        print("hellooo");
        int price = cartProduct[i]['totalprice'];
        print(price.toString());
        print(cartProduct[i]['Name']);
        print(cartProduct[i]['count'].toString());
        total = price;

        setState(() {
          totalprice = totalprice + total;
          print(totalprice.toString());
        });
      }
    } else {
      setState(() {
        totalprice = 0;
      });
    }
    print("nextttttttt");
  }

  @override
  void initState() {
    _checkhotel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: products.length + 1,
          itemBuilder: (BuildContext context, index) {
            return (products != null)
                ? (index != 0)
                    ? (products[index - 1]['offer'] == false)
                        ? productView(
                            products[index - 1]['Image'],
                            products[index - 1]['Name'],
                            products[index - 1]['Price'],
                            index - 1,
                            products[index - 1]['id'])
                        : Container()
                    : headerSection()
                : Text("Some ERorrr");
          }),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.green,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    ' Total : $totalprice',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HotelCartPage(
                                      cartProducts: cartProduct,
                                      totalprice: totalprice,
                                      hotelid: widget.id,
                                    )));
                      },
                      child: Text(
                        "View Cart",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //=========================Header Section========================
  Widget headerSection() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 25,
              ),
              Text(
                widget.hotelname,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 25,
              ),
              Text(widget.hotelPlace,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400))
            ],
          ),
          Divider(
            height: 25,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Text('Status : ',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
              (widget.status == true)
                  ? Text("Open",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600))
                  : Text("Closed",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
            ],
          ),
          Divider(
            height: 25,
            thickness: 1,
          ),
          /* Divider(
            height: 25,
            thickness: 1,
          ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Text(widget.dilverytime,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400))
            ],
          ),
          Divider(
            height: 25,
            thickness: 1,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                "Combo Offers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          specailoffer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                "All Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

//==========================FireBase Product View=====================
  Widget productView(String url, String name, int price, int index, String id) {
    return Padding(
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
            roundImage(MediaQuery.of(context).size.width / 3.5, url),
            SizedBox(
                //width: 20,
                ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Price : $price',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              _decrement(id);
                            },
                            icon: Icon(Icons.minimize)),
                        SizedBox(
                          height: 12,
                        )
                      ],
                    ),
                    Text(
                      "${products[index]['count']}",
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                        onPressed: () {
                          print("pressed increment");
                          _increment(id);
                        },
                        icon: Icon(Icons.add))
                  ],
                )
              ],
            ),
            SizedBox(
              width: 5,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 20,
                  shadowColor: Colors.grey,
                  primary: (products[index]['addto'] == true)
                      ? Colors.green
                      : Colors.white,
                ),
                onPressed: () {
                  print(products[index]['addto'].toString());

                  _addtocart(id);
                },
                child: (products[index]['addto'] == true)
                    ? Text(
                        "Added",
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        "Add",
                        style: TextStyle(color: Colors.black),
                      )),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  //========================Specail offer Container=============
  Widget specailoffer() {
    return SizedBox(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (BuildContext context, index) {
            return (products != null)
                ? (products[index]['offer'] == true)
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 0.0,
                                offset: Offset(2.0, 2.0), //(x,y)
                                blurRadius: 5.0,
                              )
                            ],
                          ),
                          width: 320,
                          child: Column(
                            children: [
                              Container(
                                  height: 180,
                                  child: Image.network(
                                    '${products[index]['Image']}',
                                    fit: BoxFit.cover,
                                  )),
                              Text(
                                products[index]['Name'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                _decrement(
                                                    products[index]['id']);
                                              },
                                              icon: Icon(Icons.minimize)),
                                          SizedBox(
                                            height: 12,
                                          )
                                        ],
                                      ),
                                      Text(
                                        products[index]['count'].toString(),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            print("pressed increment");
                                            _increment(products[index]['id']);
                                          },
                                          icon: Icon(Icons.add))
                                    ],
                                  ),
                                  Text(
                                    ' Price :${products[2]['Price']}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 20,
                                        shadowColor: Colors.grey,
                                        primary:
                                            (products[index]['addto'] == true)
                                                ? Colors.green
                                                : Colors.white,
                                      ),
                                      onPressed: () {
                                        _addtocart(products[index]['id']);
                                      },
                                      child: (products[index]['addto'] == true)
                                          ? Text(
                                              "Added",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              "Add",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                  SizedBox(
                                    width: 5,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : Container()
                : Text("Some ERorrr");
          }),
    );
    /* Container(
      color: Colors.red,
      //height: 300,
      width: 300,
      child: Column(
        children: [
          Container(
              height: 200, child: Image.network('${products[2]['Image']}')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            //_decrement(id);
                          },
                          icon: Icon(Icons.minimize)),
                      SizedBox(
                        height: 12,
                      )
                    ],
                  ),
                  Text(
                    "${products[1]['count']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                      onPressed: () {
                        print("pressed increment");
                        //_increment(id);
                      },
                      icon: Icon(Icons.add))
                ],
              ),
              Text(products[2]['Price'].toString()),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 20,
                    shadowColor: Colors.grey,
                    primary: (products[2]['addto'] == true)
                        ? Colors.green
                        : Colors.white,
                  ),
                  onPressed: () {
                    print(products[2]['addto'].toString());
                  },
                  child: (products[2]['addto'] == true)
                      ? Text(
                          "Added",
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          "Add",
                          style: TextStyle(color: Colors.black),
                        ))
            ],
          )
        ],
      ),
    );*/
  }
}
