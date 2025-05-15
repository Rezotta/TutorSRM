import 'package:flutter/material.dart';

class Reminder {
  String text;
  TimeOfDay time;
  List<bool> days; // Список для хранения выбранных дней недели

  Reminder(this.text, this.time, this.days);
}

class RemindersPage extends StatefulWidget {
  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage>
    with SingleTickerProviderStateMixin {
  List<Reminder> _reminders = [
    Reminder('Напоминание: занятие с Иваном', TimeOfDay(hour: 18, minute: 0), [true, false, false, false, false, false, false]), // Пн
    Reminder('Подготовить материал по геометрии', TimeOfDay(hour: 9, minute: 0), [false, true, false, false, false, false, false]), // Вт
  ];
  final TextEditingController _reminderController = TextEditingController();
  TimeOfDay? _selectedTime;
  List<bool> _selectedDays = List.filled(7, false); // Список для хранения выбранных дней

  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _reminderController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _addReminder() {
    if (_reminderController.text.trim().isEmpty || _selectedTime == null) return;
    setState(() {
      _reminders.insert(0, Reminder(_reminderController.text.trim(), _selectedTime!, List.from(_selectedDays)));
      _reminderController.clear();
      _selectedTime = null;
      _selectedDays = List.filled(7, false); // Сброс выбранных дней
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Напоминание добавлено'), duration: Duration(seconds: 1)));
  }

  void _removeReminder(int index) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Подтверждение удаления'),
          content: Text('Вы уверены, что хотите удалить это напоминание?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _reminders.removeAt(index);
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Напоминание удалено'), duration: Duration(seconds: 1)));
              },
              child: Text('Да'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Нет'),
            ),
          ],
        );
      },
    );
  }

  void _editReminder(int index) {
    _reminderController.text = _reminders[index].text;
    _selectedTime = _reminders[index].time;
    _selectedDays = List.from(_reminders[index].days); // Копируем выбранные дни
    _showEditDialog(index);
  }

  void _showEditDialog(int index) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Редактировать напоминание'),
          content: _buildDialogContent(),
          actions: [
            TextButton(
              onPressed: () {
                if (_reminderController.text.trim().isNotEmpty && _selectedTime != null) {
                  setState(() {
                    _reminders[index] = Reminder(_reminderController.text.trim(), _selectedTime!, List.from(_selectedDays));
                  });
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Напоминание обновлено'), duration: Duration(seconds: 1)));
                }
              },
              child: Text('Сохранить'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _reminderController,
            decoration: InputDecoration(labelText: 'Напоминание'),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: _selectedTime ?? TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  _selectedTime = time;
                });
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue.shade100,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Выбрать время: ${_selectedTime?.format(context) ?? 'Не выбрано'}', style: TextStyle(color: Colors.black)),
          ),
          SizedBox(height: 10),
          Text('Выберите дни недели:', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8.0,
            children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'].map((day) {
              return ChoiceChip(
                label: Text(
                  day,
                  style: TextStyle(
                    color: _selectedDays[dayIndex(day)] ? Colors.white : Colors.black,
                  ),
                ),
                selected: _selectedDays[dayIndex(day)],
                selectedColor: Colors.blue.shade700,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays[dayIndex(day)] = true;
                    } else {
                      _selectedDays[dayIndex(day)] = false;
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  int dayIndex(String day) {
    return ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'].indexOf(day);
  }

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Добавить напоминание'),
          content: _buildDialogContent(),
          actions: [
            TextButton(
              onPressed: () {
                _addReminder();
                Navigator.of(ctx).pop();
              },
              child: Text('Добавить'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
            children: [
            Text('Напоминания', style: Theme.of(context).textTheme.titleLarge),
        Expanded(
          child: _reminders.isEmpty
              ? Center(child: Text('Нет напоминаний', style: TextStyle(color: Colors.blue.shade700)))
              : ListView.builder(
            itemCount: _reminders.length,
            itemBuilder: (ctx, i) => Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(_reminders[i].text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 4),
                Text('Дни недели: ${_reminders[i].days.asMap().entries.where((entry) => entry.value).map((entry) => ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'][entry.key]).join(', ')}', style: TextStyle(color: Colors.black)),
                SizedBox(height: 4),
                Text('Время: ${_reminders[i].time.format(context)}', style: TextStyle(color: Colors.black)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                IconButton(
                icon: Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () => _editReminder(i),
              ),
              IconButton(
                  icon: Icon(Icons.delete, color: Colors.red.shade400),
                  onPressed: () => _removeReminder(i),
            ),
            ],
          ),
          ],
        ),
      ),
    ),
    ),
    ),
    Container(
    padding: EdgeInsets.all(12),
    child: ElevatedButton.icon(
    onPressed: _showAddReminderDialog,
    icon: Icon(Icons.add, color: Colors.white),
    label: Text('Добавить напоминание', style: TextStyle(color: Colors.white)),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue.shade700,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    ),
    ),
    ],
    ),
    ),
    );
  }
}