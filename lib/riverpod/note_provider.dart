import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class NoteNotifier extends ChangeNotifier{
  List noteentry = [];
  }
  
final noteProvider = ChangeNotifierProvider((ref){
  return NoteNotifier();
});


final counterProvider = StateProvider((ref){
  return 0;
});