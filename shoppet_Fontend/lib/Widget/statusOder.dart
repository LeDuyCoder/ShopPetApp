import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class statusOrder{

  static Widget statusPayed(){
    return Container(
      width: 60,
      height: 20,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(190, 249, 221, 1.0),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: const Center(
        child: Text("PAID", style: TextStyle(color: Color.fromRGBO(53, 195, 124, 1.0), fontWeight: FontWeight.bold, fontSize: 12, fontFamily: "Itim")),
      ),
    );
  }

  static Widget statusFail(){
    return Container(
      width: 60,
      height: 20,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 152, 154, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: const Center(
        child: Text("FAIL", style: TextStyle(color: Color.fromRGBO(171, 43, 45, 1.0), fontWeight: FontWeight.bold, fontSize: 12, fontFamily: "Itim")),
      ),
    );
  }

  static Widget statusCashed(){
    return Container(
      width: 60,
      height: 20,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 222, 152, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: const Center(
        child: Text("CASHED", style: TextStyle(color: Color.fromRGBO(171, 118, 43, 1.0), fontWeight: FontWeight.bold, fontSize: 12, fontFamily: "Itim")),
      ),
    );
  }

}