import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/src/routes/app_router.gr.dart';

@RoutePage()
class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      instaLock();
    });

    Future.delayed(Duration(seconds: 3), () {
      instaLock();
      context.router.replaceAll([const HomeRoute()]);
    });
  }

  Future<void> instaLock() async {
    setState(() {
      isCompleted = !isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
          width: isCompleted ? 100 : 50,
          height: isCompleted ? 100 : 50,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.task,
            color: Colors.white,
            size: isCompleted ? 50 : 30,
          ),
        ),
      ),
    );
  }
}
