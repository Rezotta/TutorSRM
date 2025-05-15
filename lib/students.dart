import 'package:flutter/material.dart';

class Student {
  String name;
  String subject;
  List<String> days;
  String time;

  Student({
    required this.name,
    required this.subject,
    required this.days,
    required this.time,
  });
}

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage>
    with SingleTickerProviderStateMixin {
  final List<Student> _students = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<String> _selectedDays = [];

  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();

    // Добавляем начальные ученики
    _students.add(Student(
      name: 'Иван Иванов',
      subject: 'Математика',
      days: ['Пн', 'Ср', 'Пт'],
      time: '10:00 - 11:00',
    ));
    _students.add(Student(
      name: 'Мария Петрова',
      subject: 'Физика',
      days: ['Вт', 'Чт'],
      time: '12:00 - 13:00',
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _timeController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _addStudent() {
    if (_nameController.text.trim().isEmpty ||
        _subjectController.text.trim().isEmpty ||
        _timeController.text.trim().isEmpty ||
        _selectedDays.isEmpty) {
      return;
    }
    setState(() {
      _students.add(Student(
        name: _nameController.text.trim(),
        subject: _subjectController.text.trim(),
        days: _selectedDays,
        time: _timeController.text.trim(),
      ));
      _nameController.clear();
      _subjectController.clear();
      _timeController.clear();
      _selectedDays.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Добавлен ученик'), duration: Duration(seconds: 1),));
  }

  void _editStudent(int index) {
    final student = _students[index];
    _nameController.text = student.name;
    _subjectController.text = student.subject;
    _timeController.text = student.time;
    _selectedDays = List.from(student.days); // Создаем копию списка

    _showStudentDialog(isEdit: true, index: index);
  }

  void _showStudentDialog({bool isEdit = false, int? index}) {
    if (!isEdit) {
      _nameController.clear();
      _subjectController.clear();
      _timeController.clear();
      _selectedDays.clear();
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isEdit ? 'Редактировать ученика' : 'Добавить ученика'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'ФИО ученика'),
                ),
                TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: 'Учебный предмет'),
                ),
                TextField(
                  controller: _timeController,
                  decoration: InputDecoration(labelText: 'Время занятий'),
                ),
                SizedBox(height: 10),
                Text('Дни недели:'),
                Wrap(
                  spacing: 8.0,
                  children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'].map((day) {
                    return ChoiceChip(
                      label: Text(
                        day,
                        style: TextStyle(
                          color: _selectedDays.contains(day) ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: _selectedDays.contains(day),
                      selectedColor: Colors.blue.shade700,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedDays.add(day);
                          } else {
                            _selectedDays.remove(day);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (isEdit) {
                  setState(() {
                    _students[index!] = Student(
                      name: _nameController.text.trim(),
                      subject: _subjectController.text.trim(),
                      days: _selectedDays,
                      time: _timeController.text.trim(),
                    );
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ученик обновлён'), duration: Duration(seconds: 1),));
                } else {
                  _addStudent();
                }
                Navigator.of(ctx).pop();
              },
              child: Text(isEdit ? 'Сохранить' : 'Добавить'),
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

  void _confirmDeleteStudent(int index) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Подтверждение удаления'),
          content: Text('Вы уверены, что хотите удалить ученика?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _students.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ученик удалён'), duration: Duration(seconds: 1),));
                Navigator.of(ctx).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Text('Ученики', style: Theme.of(context).textTheme.titleLarge),
              Expanded(
                child: _students.isEmpty
                    ? Center(child: Text('Список учеников пуст', style: TextStyle(color: Colors.blue.shade700)))
                    : ListView.builder(
                  itemCount: _students.length,
                  itemBuilder: (ctx, i) => Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(_students[i].name[0])),
                      title: Text(_students[i].name),
                      subtitle: Text('${_students[i].subject}, ${_students[i].days.join(', ')}, ${_students[i].time}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editStudent(i),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red.shade400),
                            onPressed: () => _confirmDeleteStudent(i),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container( // Фиксированная кнопка внизу
        padding: EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: () => _showStudentDialog(),
          icon: Icon(Icons.add, color: Colors.white),
          label: Text('Добавить ученика', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}