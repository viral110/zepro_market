import 'package:flutter/material.dart';
import 'package:jalaram/Model/favourite_with_id.dart';
import 'package:jalaram/Model/micro_product.dart';

class StoreListBoolProvider extends ChangeNotifier{

  List<IncrementNumber> allList = [];
  List<IncrementNumber> swapList = [];

  MicroProduct microProduct;

  void getData (MicroProduct mp){
    microProduct = mp;
    allList = List.generate(microProduct.response.length, (index) {
      // storePrice.add(mp.response[index].price * mp.response[index].inCart);

      return IncrementNumber(
        productName: microProduct.response[index].title,
        counter: microProduct.response[index].inCart,
        isVisible: microProduct.response[index].cartStatus,
        priceTotal: microProduct.response[index].price.toInt() *
            microProduct.response[index].inCart.toDouble(),
      );
    });
    swapList = allList;
    notifyListeners();

  }

  List<IncrementNumber> get movies => swapList;



}