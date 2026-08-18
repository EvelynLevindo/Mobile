import 'package:biblioteca_app_json/controller/book_controller.dart';
import 'package:biblioteca_app_json/model/book_model.dart';

import 'package:flutter/material.dart';

class BookFormPage extends StatefulWidget {
  final LivroModel? book;
  const BookFormPage({super.key, this.book});

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  bool _avaliable = true;
  final LivroController _controller = LivroController();

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.titulo;
      _authorController.text = widget.book!.autor;
      _avaliable = widget.book!.status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final book = LivroModel(
      id: widget.book?.id,
      titulo: _titleController.text.trim(),
      autor: _authorController.text.trim(),
      status: _avaliable,
    );
    if (widget.book == null) {
      await _controller.create(book);
    } else {
      await _controller.update(book);
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Livro' : 'Novo Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Disponível'),
                value: _avaliable,
                onChanged: (v) => setState(() => _avaliable = v),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? 'Atualizar' : 'Criar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}