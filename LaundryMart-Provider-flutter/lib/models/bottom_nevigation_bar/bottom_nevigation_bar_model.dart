// import 'package:flutter/material.dart';

// enum BottomNevigationBarModelStatus {
//   Ended,
//   Loading,
//   Error,
// }

// class BottomNevigationBarModel extends ChangeNotifier {
//   BottomNevigationBarModelStatus _status;
//   String _errorCode;
//   String _errorMessage;

//   String get errorCode => _errorCode;
//   String get errorMessage => _errorMessage;
//   BottomNevigationBarModelStatus get status => _status;

//   BottomNevigationBarModel();

//   BottomNevigationBarModel.instance() {
//     //TODO Add code here
//   }
  
//   void getter() {
//     _status = BottomNevigationBarModelStatus.Loading;
//     notifyListeners();

//     //TODO Add code here

//     _status = BottomNevigationBarModelStatus.Ended;
//     notifyListeners();
//   }

//   void setter() {
//     _status = BottomNevigationBarModelStatus.Loading;
//     notifyListeners();

//     //TODO Add code here
    
//     _status = BottomNevigationBarModelStatus.Ended;
//     notifyListeners();
//   }

//   void update() {
//     _status = BottomNevigationBarModelStatus.Loading;
//     notifyListeners();

//     //TODO Add code here
    
//     _status = BottomNevigationBarModelStatus.Ended;
//     notifyListeners();
//   }

//   void remove() {
//     _status = BottomNevigationBarModelStatus.Loading;
//     notifyListeners();

//     //TODO Add code here
    
//     _status = BottomNevigationBarModelStatus.Ended;
//     notifyListeners();
//   }
// }