import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/data/notes.dart';
import 'package:notes_app/models/models.dart';


class NoteNotifier extends ChangeNotifier{

  List<NoteEntry> get noeEntry => noteEntry;

  void addNote(NoteEntry note){
    noeEntry.add(note);
  }
  }
  
final noteProvider = ChangeNotifierProvider((ref){
  return NoteNotifier();
});


