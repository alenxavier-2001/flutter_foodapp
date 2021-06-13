import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_/orginal/food_home.dart';

class HotelCheckOutPage extends StatefulWidget {
  String hotelid;
  int totalprice;
  int dilveryprice;
  String diliveryplace;
  List totalproducts;

  HotelCheckOutPage(
      {Key? key,
      required this.diliveryplace,
      required this.dilveryprice,
      required this.hotelid,
      required this.totalprice,
      required this.totalproducts})
      : super(key: key);

  @override
  _HotelCheckOutPageState createState() => _HotelCheckOutPageState();
}

class _HotelCheckOutPageState extends State<HotelCheckOutPage> {
  bool upload = false;
  TextEditingController name = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController adress = TextEditingController();
  TextEditingController adress2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              //child: Text("CheckOut"),
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(50, 20),
                  bottomRight: Radius.elliptical(50, 20),
                ),
              )),
          Align(
            alignment: Alignment(-0.85, -0.85),
            child: Text(
              "  Checkout",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w900),
            ),
          ),
          Center(
            child: Container(
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height / 1.4,
                width: MediaQuery.of(context).size.width / 1.3,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,

                      spreadRadius: 0.0,
                      offset: Offset(2.0, 2.0), //(x,y)
                      blurRadius: 5.0,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                          child: Text(
                        "Enter Yours Details",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      )),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Enter your fullname',
                            hintText: "Alex John"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      child: TextFormField(
                        controller: phonenumber,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Enter your phone number',
                            hintText: "8301980313"),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      child: TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Enter your email adress',
                            hintText: "alexjohn@gmail.com"),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      child: TextFormField(
                        controller: adress,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Enter your dilivery address',
                            hintText: "123 Main Street, New York, NY 10030"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          child: Text(
                            "Place Your order",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          onPressed: () {
                            if (name.toString() != null ||
                                adress.toString() != null ||
                                phonenumber.toString() != null ||
                                email.toString() != null) {
                              Map<String, dynamic> data = {
                                "username": name.text,
                                "email": email.text,
                                "address": adress.text,
                                "phonenumber": phonenumber.text,
                                "diliveryplace": widget.diliveryplace,
                                "diliveryprice": widget.dilveryprice,
                                "hotelid": widget.hotelid,
                                "total": widget.totalprice,
                              };
                              uploadingproducts();
                              FirebaseFirestore.instance
                                  .collection("Orders")
                                  .doc(name.text)
                                  .collection(email.text)
                                  .add(data)
                                  .whenComplete(() => uploadingproducts());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Enter all the feild')));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  void uploadingproducts() {
    int len = widget.totalproducts.length;
    for (int i = 0; i <= len - 1; i++) {
      FirebaseFirestore.instance
          .collection("Orders")
          .doc(name.text)
          .collection("foods")
          .add(widget.totalproducts[i]);
    }
    print(" uploadeded");
    Map<String, dynamic> data = {
      "username": name.text,
      "email": email.text,
      "address": adress.text,
      "phonenumber": phonenumber.text,
      "diliveryplace": widget.diliveryplace,
      "diliveryprice": widget.dilveryprice,
      "hotelid": widget.hotelid,
      "total": widget.totalprice,
    };

    FirebaseFirestore.instance
        .collection("Orders")
        .doc(name.text)
        .collection(email.text)
        .add(data)
        .whenComplete(() => Navigator.push(
            context, MaterialPageRoute(builder: (context) => FoodHome())));
  }
}
