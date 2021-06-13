import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:food_/orginal/checkout.dart';

import 'package:food_/orginal/widgets/widgets.dart';

class HotelCartPage extends StatefulWidget {
  String hotelid;
  List cartProducts;
  int totalprice;
  HotelCartPage(
      {Key? key,
      required this.cartProducts,
      required this.totalprice,
      required this.hotelid})
      : super(key: key);

  @override
  _HotelCartPageState createState() => _HotelCartPageState();
}

class _HotelCartPageState extends State<HotelCartPage> {
  int totalCharge = 0;
  int diliverycharge = 0;
  String selectedplace = "";
  List _hotellocation = [];
  List hotellocation = [];
  List<String> hotellocationname = [];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //================Hotel Location List =====================
  _checkhotel() {
    // print(widget.id);
    String id = '${widget.hotelid}';
    if (id == '100') {
      print(id);
      _getproducts('100location');
    } else if (id == '101') {
      _getproducts('101location');
    } else if (id == '102') {
      _getproducts('102location');
    } else if (id == '103') {
      _getproducts('103location');
    } else if (id == '104') {
      _getproducts('104location');
    } else if (id == '105') {
      _getproducts('105location');
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

        setState(() {
          _hotellocation = itemList;
        });

        _setlist();
      });
    } catch (e) {
      print("get error");

      return null;
    }
  }

  void _setlist() {
    int len = _hotellocation.length;
    print(len.toString());

    for (int i = 0; i <= len - 1; i++) {
      print("gert innned");
      setState(() {
        hotellocation.add(_hotellocation[i]);
        print(hotellocation.length.toString());
        // hotellocationname.add(_hotellocation[i]['Name']);
        // print(_hotellocation[i]['Name'].toString());
      });
    }
    _namedList();
  }

  _namedList() {
    int len = hotellocation.length;
    for (int i = 0; i <= len - 1; i++) {
      print("gert innnsaqased");
      setState(() {
        hotellocationname.add(hotellocation[i]['name']);
        print(_hotellocation[i]['name']);
      });
    }
    print(hotellocationname.length.toString());
  }

  _removecart(String id) {
    List ko = widget.cartProducts;
    int len = ko.length;
    try {
      for (int i = 0; i <= len - 1; i++) {
        if (widget.cartProducts[i]['id'] == id) {
          widget.cartProducts.removeAt(i);
        }
      }
    } catch (e) {}
    _checktotalprice();
  }

  _checktotalprice() {
    int total;
    if (widget.cartProducts != null) {
      print("activiateddddddddddd");
      int leng = widget.cartProducts.length;
      print(leng.toString());
      widget.totalprice = 0;
      for (int i = 0; i <= leng - 1; i++) {
        print("hellooo");
        int price = widget.cartProducts[i]['totalprice'];
        print(price.toString());
        print(widget.cartProducts[i]['Name']);
        print(widget.cartProducts[i]['count'].toString());
        total = price;

        setState(() {
          widget.totalprice = widget.totalprice + total;
          print(widget.totalprice.toString());
        });
      }
    } else {
      setState(() {
        widget.totalprice = 0;
      });
    }
    _totalCharge();
  }

  ///=============== change place and dilivery charge=====
  _changeplace(place) {
    int len = hotellocation.length;
    for (int i = 0; i <= len - 1; i++) {
      if (hotellocation[i]['name'] == place) {
        setState(() {
          diliverycharge = hotellocation[i]['price'];
        });
      }
    }
    _totalCharge();
  }

  _totalCharge() {
    setState(() {
      totalCharge = widget.totalprice + diliverycharge;
    });
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
          itemCount: widget.cartProducts.length + 1,
          itemBuilder: (BuildContext context, index) {
            return (widget.cartProducts != null)
                ? (index != 0)
                    ? productView(
                        widget.cartProducts[index - 1]['Image'],
                        widget.cartProducts[index - 1]['Name'],
                        widget.cartProducts[index - 1]['Price'],
                        index - 1,
                        widget.cartProducts[index - 1]['id'])
                    : headerSection()
                : Text("Some ERorrr");
          }),
      bottomNavigationBar: Container(
        color: Colors.green[300],
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              ' Total : ${widget.totalprice} + $diliverycharge = $totalCharge',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.green[300],
                ),
                onPressed: () {
                  (selectedplace != "")
                      ? Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HotelCheckOutPage(
                                hotelid: widget.hotelid,
                                totalproducts: widget.cartProducts,
                                totalprice: totalCharge,
                                diliveryplace: selectedplace,
                                dilveryprice: diliverycharge,
                              )))
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Enter the  Location')));
                },
                child: Text(
                  "CheckOut",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                )),
          ],
        ),
      ),
    );
  }

  //====================Header seaction=====
  Widget headerSection() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Select your near Location",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownSearch<String>(
              mode: Mode.BOTTOM_SHEET,
              showSelectedItem: true,
              items: hotellocationname,
              label: "Menu mode",
              hint: "country in menu mode",
              clearButton: Icon(Icons.cancel),
              //popupItemDisabled: (String s) => s.startsWith('I'),
              onChanged: (value) {
                _changeplace(value.toString());
                setState(() {
                  print(value);
                  selectedplace = value.toString();
                });
              },
              selectedItem: selectedplace,
              showSearchBox: true,
            ),
          ),
        ],
      ),
    );
  }

  //==========================Cart Product View=====================
  Widget productView(String url, String name, int price, int index, String id) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
          color: Colors.white70,
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
                  height: 40,
                ),
              ],
            ),
            SizedBox(
              width: 5,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 20,
                primary: Colors.grey[200],
              ),
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                _removecart(id);
              },
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}
