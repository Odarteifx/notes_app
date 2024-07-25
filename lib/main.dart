import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/data/notes.dart';
import 'package:notes_app/riverpod/note_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteNotifier = ref.watch(noteProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            // stretch: true,
            //backgroundColor: Colors.white,
            expandedHeight: 80,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const DeletedNotes();
                      },
                    ));
                  },
                  icon: const Icon(Icons.more_horiz))
            ],
            flexibleSpace: const FlexibleSpaceBar(
              title: Text(
                'Notes',
                textAlign: TextAlign.left,
              ),
              // background: Image.network(
              //   image,
              //   fit: BoxFit.fill,
              // ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Dismissible(
                    key: Key(noteNotifier.noeEntry[index].title),
                    movementDuration: const Duration(milliseconds: 800),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.redAccent,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      final note = noteNotifier.noeEntry[index];
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Center(
                              child: Text(
                                  '${noteNotifier.noeEntry[index].title} has been deleted'))));
                      ref.read(noteProvider).removeNote(index);
                      ref.read(noteProvider).deleteList(
                            title: note.title,
                            content: note.content,
                          );
                    },
                    child: ListTile(
                      tileColor: Colors.grey[100],
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      title: Text(
                        noteNotifier.noeEntry[index].title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        noteNotifier.noeEntry[index].content,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteEdit(index: index),
                                ));
                          },
                          icon: const Icon(Icons.edit)),
                    ),
                  ),
                );
              },
              childCount: noteNotifier.noeEntry.length,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteInput(),
                ));
          },
          label: const Text('New Note')),
    );
  }
}

//New Note Page

class NoteInput extends ConsumerWidget {
  const NoteInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteNotifier = ref.read(noteProvider);
    TextEditingController titleController = TextEditingController();
    TextEditingController contextController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: titleController,
              decoration: const InputDecoration(
                  hintText: 'Title', border: InputBorder.none),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: contextController,
              maxLines: 25,
              //expands: true,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Content'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          String title = titleController.text.trim();
          String content = contextController.text.trim();
          if (title.isEmpty && content.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Title and Content cannot be empty')),
            ));
          } else {
            noteNotifier.addNote(title, content);
            Navigator.pop(context);
          }
        },
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}

//Edit Note Page
class NoteEdit extends ConsumerWidget {
  final int index;
  const NoteEdit({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteNotifier = ref.read(noteProvider);
    final note = noteNotifier.noeEntry[index];
    final TextEditingController contentController =
        TextEditingController(text: note.content);
    final TextEditingController titleController =
        TextEditingController(text: note.title);
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        //backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              style: const TextStyle(fontWeight: FontWeight.bold),
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  hintText: 'Title', border: InputBorder.none),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: contentController,
              maxLines: 25,
              //expands: true,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Content'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            String title = titleController.text.trim();
            String content = contentController.text.trim();
            ref.read(noteProvider).updateNote(index, title, content);
            Navigator.pop(context);
          },
          icon: const Icon(Icons.save),
          label: const Text('Save')),
    );
  }
}

class DeletedNotes extends ConsumerStatefulWidget {
  const DeletedNotes({super.key});

  @override
  ConsumerState<DeletedNotes> createState() => _DeletedNotesState();
}

class _DeletedNotesState extends ConsumerState<DeletedNotes> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final notesNotifer = ref.watch(noteProvider).deletedNote;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recently Deleted'),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              child: (deletedNotes.isNotEmpty && _isEditing)
                  ? const Text('Done')
                  : const Text('Edit'))
        ],
      ),
      body: deletedNotes.isEmpty
          ? const Center(
              child: Text(
              'No recently deleted notes',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ))
          : ListView.builder(
              itemCount: notesNotifer.length,
              itemBuilder: (context, index) {
                final note = notesNotifer[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: ListTile(
                    tileColor: Colors.grey[200],
                    title: Text(
                      note.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      note.content,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: _isEditing
                        ? IconButton(
                            onPressed: () {
                              ref
                                  .read(noteProvider)
                                  .addNote(note.title, note.content);
                              ref.read(noteProvider).restoreDelete(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Center(
                                          child:
                                              Text('${note.title} restored'))));
                            },
                            icon: const Icon(Icons.restore))
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
