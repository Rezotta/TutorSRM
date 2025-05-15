import 'package:flutter/material.dart';

class Material {
  String subject;
  String topic;
  String content;

  Material({
    required this.subject,
    required this.topic,
    required this.content,
  });
}

class MaterialsPage extends StatefulWidget {
  @override
  _MaterialsPageState createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage>
    with SingleTickerProviderStateMixin {
  final List<Material> _materials = [];
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _sizeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();

    // Добавление примера материала
    _materials.add(Material(
      subject: 'Математика',
      topic: 'Алгебра',
      content: 'Основные операции с числами и переменными.',
    ));
    _materials.add(Material(
      subject: 'Физика',
      topic: 'Законы движения',
      content: 'Изучение законов Ньютона и их применение.',
    ));
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _topicController.dispose();
    _contentController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _addMaterial() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Добавить материал'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Предмет',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade700),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _topicController,
                decoration: InputDecoration(
                  labelText: 'Тема материала',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade700),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Текст материала',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade700),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_subjectController.text.trim().isNotEmpty &&
                    _topicController.text.trim().isNotEmpty &&
                    _contentController.text.trim().isNotEmpty) {
                  setState(() {
                    _materials.add(Material(
                      subject: _subjectController.text.trim(),
                      topic: _topicController.text.trim(),
                      content: _contentController.text.trim(),
                    ));
                    _clearControllers();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Материал добавлен'),
                      duration: Duration(seconds: 1)));
                  Navigator.of(ctx).pop();
                }
              },
              child: Text('Добавить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  void _editMaterial(int index) {
    final material = _materials[index];
    _subjectController.text = material.subject;
    _topicController.text = material.topic;
    _contentController.text = material.content;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Редактировать материал'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Предмет',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade700),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _topicController,
                decoration: InputDecoration(
                  labelText: 'Тема материала',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade700),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Текст материала',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade700),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_subjectController.text.trim().isNotEmpty) {
                  setState(() {
                    _materials[index] = Material(
                      subject: _subjectController.text.trim(),
                      topic: _topicController.text.trim(),
                      content: _contentController.text.trim(),
                    );
                  });
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Материал обновлён'),  duration: Duration(seconds: 1),));
                }
              },
              child: Text('Сохранить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx ).pop();
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMaterial(int index) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Удалить материал'),
          content: Text('Вы уверены, что хотите удалить этот материал?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _materials.removeAt(index);
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Материал удалён'),  duration: Duration(seconds: 1),));
              },
              child: Text('Да'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Нет'),
            ),
          ],
        );
      },
    );
  }

  void _clearControllers() {
    _subjectController.clear();
    _topicController.clear();
    _contentController.clear();
  }

  void _showMaterialDetails(Material material) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(material.topic),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Предмет: ${material.subject}'),
              SizedBox(height: 10),
              Text('Содержание: ${material.content}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _sizeAnimation,
      axisAlignment: -1,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Материалы', style: Theme.of(context).textTheme.titleLarge),
            Expanded(
              child: _materials.isEmpty
                  ? Center(child: Text('Пока нет материалов', style: TextStyle(color: Colors.blue.shade700)))
                  : ListView.builder(
                itemCount: _materials .length,
                itemBuilder: (ctx, i) => Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: ListTile(
                    leading: Icon(Icons.book, color: Colors.blue.shade700),
                    title: Text(_materials[i].topic),
                    subtitle: Text(_materials[i].subject),
                    onTap: () => _showMaterialDetails(_materials[i]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editMaterial(i),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMaterial(i),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Отступ перед кнопкой
            ElevatedButton.icon(
              onPressed: _addMaterial,
              icon: Icon(Icons.add, color: Colors.white),
              label: Text('Добавить материал', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}