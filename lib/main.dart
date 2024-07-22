import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    const String image =
        'https://images.unsplash.com/photo-1615092607420-e545863a67c4?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            // stretch: true,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Notes'),
              background: Image.network(
                image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  tileColor: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                      onPressed: () {}, icon: const Icon(Icons.edit)),
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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                  hintText: 'Title', border: OutlineInputBorder()),
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
