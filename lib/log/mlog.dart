import 'package:flutter_muyi/applicaltion.dart';

class MLog{

  static final String TAG = "MLog";

  static void d(Object object){
    if(Applicaltion.isLog){
      if(object is String){
        print("$TAG : $object");
      }else{
        print(object);
      }
    }
  }
}