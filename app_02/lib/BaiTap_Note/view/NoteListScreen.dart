import 'package:flutter/material.dart';
import '../db/NoteDatabaseHelper.dart';
import '../model/Note.dart';
import 'package:app_02/BaiTap_Note/view/NoteForm.dart';
import 'NoteListItem.dart';
import 'NoteDetailScreen.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() {
    setState(() {
      _notesFuture = NoteDatabaseHelper.instance.getAllNotes();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách Ghi chú'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshNotes,
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có ghi chú'));
          }
          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteListItem(
                note: note,
                onEdit: () async {
                  final updatedNote = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteForm(note: note, onSave: (note) async {
                        await NoteDatabaseHelper.instance.updateNote(note);
                        Navigator.pop(context, note);
                      }),
                    ),
                  );
                  if (updatedNote != null) _refreshNotes();
                },
                onDelete: () async {
                  await NoteDatabaseHelper.instance.deleteNote(note.id!);
                  _refreshNotes();
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NoteDetailScreen(note: note),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteForm(
                onSave: (note) async {
                  await NoteDatabaseHelper.instance.insertNote(note);
                  Navigator.pop(context, note);
                },
              ),
            ),
          );
          if (newNote != null) _refreshNotes();
        },
      ),
    );
  }
}