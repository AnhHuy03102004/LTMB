import 'dart:ui';
import 'package:flutter/material.dart';
import '../model/Note.dart';
import 'NoteDetailScreen.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback? onTap;

  const NoteListItem({
    Key? key,
    required this.note,
    required this.onDelete,
    required this.onEdit,
    this.onTap,
  }) : super(key: key);

  Color _priorityColor(int priority) {
    switch (priority) {
      case 3:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 1:
      default:
        return Colors.green;
    }
  }

  Color _parseColor(String? input) {
    if (input == null) return Colors.grey.shade100;
    try {
      if (input.startsWith('#')) {
        return Color(int.parse(input.substring(1), radix: 16) + 0xFF000000);
      } else {
        final namedColors = {
          'red': Colors.red,
          'blue': Colors.blue,
          'green': Colors.green,
          'black': Colors.black,
          'white': Colors.white,
          'yellow': Colors.yellow,
          'pink': Colors.pink,
          'orange': Colors.orange,
          'purple': Colors.purple,
          'grey': Colors.grey,
          'brown': Colors.brown,
        };
        return namedColors[input.toLowerCase()] ?? Colors.grey.shade200;
      }
    } catch (_) {
      return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteColor = _parseColor(note.color);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: noteColor, width: 1.5),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _priorityColor(note.priority),
          child: Text(
            note.title.isNotEmpty ? note.title[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(note.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              note.content.length > 50
                  ? '${note.content.substring(0, 50)}...'
                  : note.content,
            ),
            const SizedBox(height: 4),
            if (note.tags != null && note.tags!.isNotEmpty)
              Wrap(
                spacing: 6,
                children: note.tags!
                    .map((tag) => Text(
                  '#$tag',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ))
                    .toList(),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Xác nhận xoá'),
                    content: const Text('Bạn có chắc muốn xoá ghi chú này không?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Huỷ'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                        child: const Text('Xoá'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        onTap: onTap ??
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoteDetailScreen(note: note),
                ),
              );
            },
      ),
    );
  }
}
