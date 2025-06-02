import 'package:flutter/material.dart';
import 'students.dart';
import 'earnings.dart';
import 'materials.dart';
import 'reminders.dart';

void main() {
  runApp(TutorSRMApp());
}

class TutorCRMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tutorCRM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue.shade700,
        hintColor: Colors.lightBlueAccent.shade400,
        scaffoldBackgroundColor: Colors.blue.shade50,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Colors.blue.shade900,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(color: Colors.blue.shade800),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.blue.shade700,
          elevation: 8,
          shadowColor: Colors.blue.shade200,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blue.shade700,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedIconTheme: IconThemeData(size: 30),
          unselectedIconTheme: IconThemeData(size: 24),
          showUnselectedLabels: true,
          elevation: 12,
        ),
      ),
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    StudentsPage(),
    EarningsPage(),
    MaterialsPage(),
    RemindersPage(),
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  void onTabTapped(int index) {
    if (_currentIndex == index) return;
    _animationController.reverse().then((_) {
      setState(() {
        _currentIndex = index;
      });
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_chart, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "tutorSRM",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Ученики'),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Заработок',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Материалы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Напоминания',
          ),
        ],
      ),
    );
  }
}
