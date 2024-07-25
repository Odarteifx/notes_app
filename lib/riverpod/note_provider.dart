import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/data/notes.dart';
import 'package:notes_app/models/models.dart';

class NoteNotifier extends ChangeNotifier {
  List<NoteEntry> get noeEntry => noteList;

  List<NoteEntry> get deletedNote => deletedNotes;

  void addNote(String title, String content) {
    noeEntry.add(NoteEntry(title: title, content: content));
    notifyListeners();
  }

  void updateNote(int index, String title, String content) {
    noeEntry[index] = NoteEntry(title: title, content: content);
    notifyListeners();
  }

  void removeNote(int index) {
    noeEntry.removeAt(index);
    notifyListeners();
  }

  void deleteList({
    required String title,
    required String content,
  }) {
    deletedNote.add(NoteEntry(title: title, content: content));
    notifyListeners();
  }
}

final noteProvider = ChangeNotifierProvider((ref) {
  return NoteNotifier();
});
