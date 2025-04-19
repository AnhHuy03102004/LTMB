import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/Note.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    final Color noteColor = _parseColor(note.color ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết ghi chú'),
        backgroundColor: noteColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: noteColor.withOpacity(0.05),
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Ưu tiên: ${note.priority}'),
                Text('Tạo lúc: ${formatter.format(note.createdAt)}'),
                Text('Cập nhật: ${formatter.format(note.modifiedAt)}'),
                const SizedBox(height: 16),
                Text(note.content),
                const SizedBox(height: 16),

                // Tags
                if (note.tags != null && note.tags!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: note.tags!
                        .map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: noteColor,
                      labelStyle: const TextStyle(color: Colors.white),
                    ))
                        .toList(),
                  ),

                // Color Preview
                if (note.color != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: noteColor,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('Màu: ${note.color}'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _parseColor(String input) {
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
        return namedColors[input.toLowerCase()] ?? Colors.grey.shade300;
      }
    } catch (_) {
      return Colors.grey.shade300;
    }
  }
}
