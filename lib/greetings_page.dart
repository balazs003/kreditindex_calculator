import 'package:flutter/material.dart';

class GreetingsPage extends StatefulWidget {
  const GreetingsPage({super.key});

  @override
  State<GreetingsPage> createState() => _GreetingsPageState();
}

class _GreetingsPageState extends State<GreetingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimationForTitle;
  late Animation<Offset> _offsetAnimationForButton;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _offsetAnimationForTitle = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _offsetAnimationForButton = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from the bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _offsetAnimationForTitle,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        return Opacity(
                          opacity: _opacityAnimation.value,
                          child: const Text(
                            'ÁtlagoSCH 2.0',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: const Text(
                          'Üdv az új ÁtlagoSCH alkalmazásban!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: const Text(
                          'Az új alkalmazásban még egyszerűbben kezelheted a tanárgyaidat és számos új statisztikát láthatsz róluk.\n\n Vágjunk is bele!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  SlideTransition(
                    position: _offsetAnimationForButton,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        return Opacity(
                          opacity: _opacityAnimation.value,
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the next screen
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.white, // Use a solid color for the button
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Indulás!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
