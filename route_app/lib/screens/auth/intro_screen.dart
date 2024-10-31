import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/main.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:accesible_route/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  Future<void> _completeIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_value', true);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => AuthWrapper()));
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDeniedDialog();
      return;
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await _completeIntro();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).location_screen_alert_diaglog_title),
          content: Text(S.of(context).location_screen_alert_diaglog_content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _exitApp();
              },
              child: Text(S.of(context).location_screen_unsubmit_button),
            ),
          ],
        );
      },
    );
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).location_screen_alert_diaglog_title2),
          content: Text(S.of(context).location_screen_alert_diaglog_content2),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _exitApp();
              },
              child: Text(S.of(context).location_screen_alert_diaglog_unsubmit),
            ),
          ],
        );
      },
    );
  }

  void _exitApp() {
    SystemNavigator.pop();
  }

  void _navigateToSelectionPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      backgroundColor: !isDarkMode
          ? Colors.white
          : Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                _buildPage(
                    image: 'assets/images/intro_1.png',
                    title: S.of(context).introTitle1,
                    description: S.of(context).introContent1,
                    isDarkMode: isDarkMode),
                _buildPage(
                    image: 'assets/images/template.png',
                    title: S.of(context).introTitle2,
                    description: S.of(context).introContent2,
                    isDarkMode: isDarkMode),
                _buildPage(
                    image: 'assets/images/3.png',
                    title: S.of(context).introTitle3,
                    description: S.of(context).introContent3,
                    isDarkMode: isDarkMode),
              ],
            ),
          ),
          _buildPageIndicator(),
          if (_currentIndex < 2)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: MyButton(
                    text: S.of(context).intro_screen_next_button,
                    buttonColor: Colors.blue,
                    buttonTextColor: Colors.white,
                    buttonTextSize: 17,
                    buttonTextWeight: FontWeight.normal,
                    borderRadius: BorderRadius.circular(16),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    buttonWidth: ButtonWidth.large),
                // ElevatedButton(
                //   onPressed: () {
                //     _pageController.nextPage(
                //       duration: const Duration(milliseconds: 300),
                //       curve: Curves.easeInOut,
                //     );
                //   },
                //   child: const Text('Sonraki'),
                // ),
              ),
            ),
          if (_currentIndex == 2)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: MyButton(
                    text: S.of(context).intro_screen_submit_button,
                    buttonColor: Colors.blue,
                    buttonTextColor: Colors.white,
                    buttonTextSize: 17,
                    buttonTextWeight: FontWeight.normal,
                    borderRadius: BorderRadius.circular(16),
                    onPressed: _navigateToSelectionPage,
                    buttonWidth: ButtonWidth.large),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPage(
      {required String image,
      required String title,
      required String description,
      required bool isDarkMode}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 250),
        const SizedBox(height: 24),
        Text(
          title,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: !isDarkMode ? Colors.black : Colors.white),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            description,
            style: TextStyle(
                fontSize: 16, color: !isDarkMode ? Colors.black : Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
          height: 12.0,
          width: _currentIndex == index ? 24.0 : 12.0,
          decoration: BoxDecoration(
            color: _currentIndex == index ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).location_screen_title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: !isDarkMode
            ? Colors.white
            : Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).location_screen_titles_body,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await _requestLocationPermission(context);
                  await prefs.setBool('intro_value', true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Mavi arka plan
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5, // Hafif bir gölge etkisi
                ),
                child: Text(S.of(context).intro_screen_submit_button,
                    style: TextStyle(
                      color: Colors.white, // Beyaz yazı
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _exitApp(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(S.of(context).location_screen_unsubmit_button,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog(context);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog(context);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDeniedDialog(context);
      return;
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => AuthWrapper()));
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).location_screen_alert_diaglog_title),
          content: Text(S.of(context).location_screen_alert_diaglog_content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _exitApp(context);
              },
              child: Text(S.of(context).location_screen_alert_diaglog_unsubmit),
            ),
          ],
        );
      },
    );
  }

  void _showLocationServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).location_screen_alert_diaglog_title2),
          content: Text(S.of(context).location_screen_alert_diaglog_content2),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _exitApp(context);
              },
              child: Text(S.of(context).location_screen_alert_diaglog_unsubmit),
            ),
          ],
        );
      },
    );
  }

  void _exitApp(BuildContext context) {
    SystemNavigator.pop();
  }
}
