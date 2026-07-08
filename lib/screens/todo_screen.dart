import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodoItem> _items = [];
  final _textCtrl = TextEditingController();

  @override
  void initState() { super.initState(); _load(); }

  @override
  void dispose() { _textCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('todos') ?? '[]';
    final list = (jsonDecode(raw) as List).map((e) => TodoItem.fromJson(e)).toList();
    setState(() => _items = list);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('todos', jsonEncode(_items.map((e) => e.toJson()).toList()));
  }

  void _add() {
    if (_textCtrl.text.trim().isEmpty) return;
    setState(() => _items.add(TodoItem(text: _textCtrl.text.trim(), done: false)));
    _textCtrl.clear();
    _save();
  }

  void _toggle(int i) {
    setState(() => _items[i].done = !_items[i].done);
    _save();
  }

  void _delete(int i) {
    setState(() => _items.removeAt(i));
    _save();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF3E8FF), Color(0xFFFFF0F5)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('📝 Edit / Kòd')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textCtrl,
                      decoration: InputDecoration(
                        hintText: 'Ekri yon travay...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (_) => _add(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: AppTheme.lavender,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _add,
                      child: const Padding(padding: EdgeInsets.all(14), child: Icon(Icons.add, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('📋', style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 12),
                          Text('Pa gen anyen pou kounye a', style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
                          Text('Ajoute yon travay ou dwe fè', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _items.length,
                      itemBuilder: (_, i) {
                        final item = _items[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () => _toggle(i),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: item.done ? AppTheme.lavender : Colors.transparent,
                                  border: Border.all(color: AppTheme.lavender, width: 2),
                                ),
                                child: item.done ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                              ),
                            ),
                            title: Text(item.text, style: TextStyle(decoration: item.done ? TextDecoration.lineThrough : null, color: item.done ? Colors.grey : Colors.black87, fontWeight: FontWeight.w500)),
                            trailing: GestureDetector(
                              onTap: () => _delete(i),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (_items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_items.where((e) => e.done).length}/${_items.length} fèt', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    if (_items.any((e) => e.done))
                      TextButton(
                        onPressed: () {
                          setState(() => _items.removeWhere((e) => e.done));
                          _save();
                        },
                        child: const Text('Netwaye fèt yo', style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TodoItem {
  String text;
  bool done;
  TodoItem({required this.text, required this.done});
  Map<String, dynamic> toJson() => {'text': text, 'done': done};
  factory TodoItem.fromJson(Map<String, dynamic> j) => TodoItem(text: j['text'] ?? '', done: j['done'] ?? false);
}
