import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_system/shared/components/components.dart';

class MyCustomTransition extends StatelessWidget {
  const MyCustomTransition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () =>
                    Navigator.push(context, FadeRoute(const SecondPage())),
                child: const Text('TAP TO VIEW FADE ANIMATION 1')),
            ElevatedButton(
              onPressed: () =>
                  Navigator.push(context, FadeRoute2(const SecondPage())),
              child: const Text('TAP TO VIEW FADE ANIMATION 2'),
            ),
          ],
        ),
      ),
    );
  }
}

class FadeRoute2 extends PageRouteBuilder {
  final Widget page;

  FadeRoute2(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                parent: animation,
                reverseCurve: Curves.fastOutSlowIn);
            return FadeTransition(
              opacity: animation,
              child: page,
            );
          },
        );
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Fade Transition'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}
