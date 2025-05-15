import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Earning {
  DateTime date;
  int amount;
  String note;
  String educational;
  String studentName;

  Earning({
    required this.date,
    required this.amount,
    required this.note,
    required this.educational,
    required this.studentName,
  });
}

class EarningsPage extends StatefulWidget {
  @override
  _EarningsPageState createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage>
    with SingleTickerProviderStateMixin {
  final List<Earning> _earnings = [
    Earning(
      date: DateTime.now().subtract(Duration(days: 280)),
      amount: 1500,
      note: 'Урок по Синусам.',
      educational: 'Математика',
      studentName: 'Иван Иванов',
    ),
    Earning(
      date: DateTime.now().subtract(Duration(days: 14)),
      amount: 2000,
      note: 'Урок по Малярным величинам.',
      educational: 'Физика',
      studentName: 'Мария Петрова',
    ),
    Earning(
      date: DateTime.now().subtract(Duration(days: 4)),
      amount: 2400,
      note: 'Урок по Циклам.',
      educational: 'Физика',
      studentName: 'Андрей Петрович',
    ),
  ];

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _educationalOptions = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _educationalOptions.dispose();
    _noteController.dispose();
    _studentNameController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _addEarning() {
    final amountText = _amountController.text.trim();
    final educationalText = _educationalOptions.text.trim();
    final noteText = _noteController.text.trim();
    final studentNameText = _studentNameController.text.trim();
    final amount = int.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Введите корректную сумму')));
      return;
    }

    if (educationalText.isEmpty || noteText.isEmpty || studentNameText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Заполните все поля')));
      return;
    }

    setState(() {
      _earnings.insert(0, Earning(
        date: DateTime.now(),
        amount: amount,
        note: noteText,
        educational: educationalText,
        studentName: studentNameText,
      ));
    });

    _amountController.clear();
    _educationalOptions.clear();
    _noteController.clear();
    _studentNameController.clear();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Заработок добавлен')));
  }

  void _showAddEarningDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Добавить заработок'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Сумма (₽)'),
              ),
              TextField(
                controller: _educationalOptions,
                decoration : InputDecoration(labelText: 'Учебный предмет'),
              ),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'Тема урока'),
              ),
              TextField(
                controller: _studentNameController,
                decoration: InputDecoration(labelText: 'ФИО ученика'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addEarning();
                Navigator.of(ctx).pop();
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

  void _editEarning(int index) {
    final earning = _earnings[index];
    _amountController.text = earning.amount.toString();
    _educationalOptions.text = earning.educational;
    _noteController.text = earning.note;
    _studentNameController.text = earning.studentName;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Редактировать запись'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Сумма (₽)'),
              ),
              TextField(
                controller: _educationalOptions,
                decoration: InputDecoration(labelText: 'Учебный предмет'),
              ),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'Тема урока'),
              ),
              TextField(
                controller: _studentNameController,
                decoration: InputDecoration(labelText: 'ФИО ученика'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final amount = int.tryParse(_amountController.text.trim());
                if (amount != null && amount > 0) {
                  setState(() {
                    _earnings[index] = Earning(
                      date: earning.date,
                      amount: amount,
                      note: _noteController.text.trim(),
                      educational: _educationalOptions.text.trim(),
                      studentName: _studentNameController.text.trim(),
                    );
                  });
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Запись обновлена')));
                }
              },
              child: Text('Сохранить'),
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

  void _deleteEarning(int index) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Подтверждение удаления'),
          content: Text('Вы уверены, что хотите удалить эту запись?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _earnings.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Запись удалена'),
                    duration: Duration(seconds: 1), // Установите желаемую продолжительность
                  ),
                );
                Navigator.of(ctx).pop(); // Закрыть диалог
              },
              child: Text('Удалить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Закрыть диалог без удаления
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  int get totalEarnings {
    return _earnings.fold(0, (sum, e) => sum + e.amount);
  }

  int get weeklyEarnings {
    final now = DateTime.now();
    return _earnings.where((earning) => earning.date.isAfter(now.subtract(Duration(days: 7)))).fold(0, (sum, e) => sum + e.amount);
  }

  int get monthlyEarnings {
    final now = DateTime.now();
    return _earnings.where((earning) => earning.date.isAfter(now.subtract(Duration(days: 30)))).fold(0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _fadeAnimation,
        child: Scaffold( // Используем Scaffold для размещения фиксированной кнопки
        body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.all(12),
    child: Column(
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Center(
    child: Text('Ваш заработок', style: Theme.of(context).textTheme.titleLarge),
    ),
    SizedBox(height: 16),
    Card(
    color: Colors.white,
    elevation: 5,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
    padding: EdgeInsets.all(20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text('Всего:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    Text('$totalEarnings ₽', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
    ],
    ),
    Divider(color: Colors.grey.shade300, thickness: 1.5),
    SizedBox(height: 10),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text('месяц:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    Text('$monthlyEarnings ₽', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
    ],
    ),
    Divider(color: Colors.grey.shade300, thickness: 1.5),
    SizedBox(height: 10),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text('неделю:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    Text('$weeklyEarnings ₽', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
    ],
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    SizedBox(height: 12),
    _earnings.isEmpty
    ? Center(child: Text('Нет записей о заработке'))
        : ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: _earnings.length,
    itemBuilder: (ctx, i) {
    final item = _earnings[i];
    return Card(
    elevation: 3,
    margin: EdgeInsets.symmetric(vertical: 6),
    child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text('${item.amount} ₽', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
    SizedBox(height: 8),
    Text(item.note.isEmpty ? 'Без комментариев' : item.note, style: TextStyle(fontSize: 18, color: Colors.black)),
    SizedBox(height: 4),
    Text('Учебный предмет: ${item.educational}', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600)),
    SizedBox(height: 4),
    Text('ФИО ученика: ${item.studentName}', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600)),
    SizedBox(height: 4),
    Text('Дата: ${DateFormat('dd.MM.yyyy').format(item.date)}', style: TextStyle(color: Colors.grey.shade600)),
    SizedBox(height: 12),
    Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    IconButton(
    icon: Icon(Icons.edit, color: Colors.blue),
    onPressed: () => _editEarning(i),
    ),
    IconButton(
    icon: Icon(Icons.delete, color: Colors.red.shade400),
    onPressed: () => _deleteEarning(i),
    ),
    ],
    ),
    ],
    ),
    ),
    );
    },
    ),
    SizedBox(height: 12),
    ],
    ),
    ),
    ),
    bottomNavigationBar: Container( // Фиксированная кнопка внизу
    padding: EdgeInsets.all(12),
    child: ElevatedButton.icon(
    onPressed: _showAddEarningDialog,
    icon: Icon(Icons.add, color: Colors.white),
    label: Text('Добавить заработок', style: TextStyle(color: Colors.white)),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue.shade700,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    ),
    ),
        )
    );
  }
}

