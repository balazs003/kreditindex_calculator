import 'package:flutter/material.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimationForTitle;
  late Animation<Offset> _offsetAnimationForCard;
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

    _offsetAnimationForCard = Tween<Offset>(
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
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: _offsetAnimationForTitle,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, Widget? child) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, top: 40),
                              child: Text(
                                'Pár szó a funkciókról',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SlideTransition(
                      position: _offsetAnimationForCard,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, Widget? child) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: Card(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text(
                                      'A program lehetőséget nyújt a teljes egyetemi pályafutásunk során elért eredményeink nyomon követésére.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: <Color>[
                                            Theme.of(context).primaryColor,
                                            Theme.of(context).primaryColorDark,
                                          ],
                                        ).createShader(bounds);
                                      },
                                      child: const Text(
                                        'Fő funkciók:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const FeatureItem(
                                      icon: Icons.view_list,
                                      text:
                                          'Add hozzá és módosítsd a tantárgyaidat minden félévhez',
                                    ),
                                    const FeatureItem(
                                      icon: Icons.add,
                                      text:
                                          'Adj hozzá további féléveket, ha nem lenne elegendő',
                                    ),
                                    const FeatureItem(
                                      icon: Icons.calculate,
                                      text:
                                          'Kövesd nyomon az adott félévhez tartozó átlagaidat',
                                    ),
                                    const FeatureItem(
                                      icon: Icons.analytics,
                                      text:
                                          'Elemezd a teljes egyetemi pályafutásodhoz tartozó statisztikákat',
                                    ),
                                    const FeatureItem(
                                      icon: Icons.grade,
                                      text:
                                          'Megkülönböztetheted a kötelező és szabadon választható tárgyaidat',
                                    ),
                                    const FeatureItem(
                                      icon: Icons.bookmark,
                                      text:
                                          'Jelöld meg a kérdéses és a biztos tárgyakat',
                                    ),
                                    const FeatureItem(
                                      icon: Icons.edit,
                                      text:
                                          'Szerkeszd és töröld a tárgyakat egyszerűen oldalra húzással',
                                    ),
                                    const FeatureItem(
                                      icon: Icons.swap_vert,
                                      text:
                                      'Rendezd át a tantárgyak sorrendjét könnyedén',
                                    ),
                                    const FeatureItem(
                                      icon: Icons.dark_mode,
                                      text:
                                          'Használd az alkalmazást nappali vagy éjszakai módban',
                                    ),
                                    const FeatureItem(
                                      icon: Icons.info,
                                      text:
                                          'Az információk oldalon minden funkcióról részletes tájékoztatást kapsz',
                                    ),
                                    const FeatureItem(
                                      icon: Icons.import_contacts,
                                      text:
                                          'Importáld a teljes tantervedet egyetlen gombnyomással (csak néhány szaknál elérhető)',
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                                context, '/settings');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: <Color>[
                                                  Theme.of(context)
                                                      .primaryColor,
                                                  Theme.of(context)
                                                      .primaryColorDark,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              'Importálom',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacementNamed(
                                                  context, '/');
                                            },
                                            child: const Text(
                                              'Most nem',
                                              style: TextStyle(
                                                fontSize: 16
                                              ),
                                            ))
                                      ],
                                    )
                                  ],
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
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark,
                ],
              ).createShader(bounds);
            },
            child: Icon(
              icon,
              size: 28,
              color: Colors.white, // Apply gradient to icon color
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54, // Apply gradient to text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
