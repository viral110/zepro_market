import 'package:flutter/material.dart';

class FavouriteListProvider extends ChangeNotifier{
  List productCartoon = [];
  List productName = [];
  List productCategory = [];
  List productStock = [];
  List productImage = [];


  void fetchDataFromList(List pName,List category,List cartoon,List stock,List image){
    productName = pName;
    productImage = image;
    productCategory = category;
    productStock = stock;
    productCartoon = cartoon;
    print(productName);
  }



}