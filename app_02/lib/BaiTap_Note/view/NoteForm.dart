import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/Note.dart';

class NoteForm extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  const NoteForm({
    Key? key,
    this.note,
    required this.onSave,
  }) : super(key: key);

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _colorController = TextEditingController();
  int _priority = 2;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      final note = widget.note!;
      _titleController.text = note.title;
      _contentController.text = note.content;
      _priority = note.priority;
      _tagsController.text = note.tags?.join(', ') ?? '';
      _colorController.text = note.color ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _colorController.dispose();
    super.dispose();
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();

      final note = Note(
        id: widget.note?.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        priority: _priority,
        createdAt: widget.note?.createdAt ?? now,
        modifiedAt: now,
        tags: _tagsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        color: _colorController.text.trim().isEmpty
            ? null
            : _colorController.text.trim(),
      );

      widget.onSave(note); // Gửi dữ liệu về màn trước
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Cập nhật Ghi chú' : 'Thêm Ghi chú'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Nội dung',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập nội dung' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<int>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Mức độ ưu tiên',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Thấp')),
                  DropdownMenuItem(value: 2, child: Text('Trung bình')),
                  DropdownMenuItem(value: 3, child: Text('Cao')),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Màu sắc (hex hoặc tên)',
                  hintText: '#FF0000 hoặc blue',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  final hexColorRegExp = RegExp(r'^#(?:[0-9a-fA-F]{3}){1,2}$');
                  final namedColors = [
                    'red', 'blue', 'green', 'black', 'white',
                    'yellow', 'pink', 'orange', 'purple', 'grey', 'brown'
                  ];

                  if (value == null || value.isEmpty) return null; // Cho phép bỏ trống
                  if (!hexColorRegExp.hasMatch(value) &&
                      !namedColors.contains(value.toLowerCase())) {
                    return 'Màu không hợp lệ. Dùng #RRGGBB hoặc tên như "blue"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Bản xem trước màu
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: _parseColor(_colorController.text),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black12),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Nhãn (tags cách nhau bằng dấu phẩy)',
                  hintText: 'công việc, cá nhân, học tập',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(isEditing ? 'Cập nhật' : 'Thêm mới'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
