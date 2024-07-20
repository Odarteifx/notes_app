import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/models.dart';

class NoteNotifier extends Notifier<List<NoteEntry>>{
  @override
  List <NoteEntry> build() {
    return [
      NoteEntry(title: 'title', content: 'content'),
      NoteEntry(title: '2', content: 'content')
    ];
  }
  
} 

final noteProvider = Provider((ref){
  return NoteNotifier();
});