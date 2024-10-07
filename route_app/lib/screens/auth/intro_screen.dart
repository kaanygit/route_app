import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:route_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Uygulamayı kapatmak için gerekli

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
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const AuthWrapper()));
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
          title: const Text('Konum İzni Gerekli'),
          content: const Text(
              'Uygulama doğru çalışması için sürekli konum erişimine ihtiyaç duyar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _exitApp();
              },
              child: const Text('Uygulamayı Kapat'),
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
          title: const Text('Konum Servisi Kapalı'),
          content: const Text(
              'Uygulama doğru çalışması için konum servisinizin açık olması gerekmektedir.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _exitApp();
              },
              child: const Text('Uygulamayı Kapat'),
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
    return Scaffold(
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
                  image: 'assets/images/template.png',
                  title: 'Tanıtım 1',
                  description: 'Bu ekran uygulamayı tanıtan ilk sayfadır.',
                ),
                _buildPage(
                  image: 'assets/images/template.png',
                  title: 'Tanıtım 2',
                  description: 'Bu ekran uygulamayı tanıtan ikinci sayfadır.',
                ),
                _buildPage(
                  image: 'assets/images/template.png',
                  title: 'Tanıtım 3',
                  description: 'Bu ekran uygulamayı tanıtan üçüncü sayfadır.',
                ),
              ],
            ),
          ),
          _buildPageIndicator(),
          if (_currentIndex < 2)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Sonraki'),
                ),
              ),
            ),
          if (_currentIndex == 2)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToSelectionPage,
                  child: const Text('Konumunuza İzin Ver'),
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String image,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 250),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            description,
            style: const TextStyle(fontSize: 16),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seçim Ekranı'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Konum izni vermek istiyor musunuz?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await _requestLocationPermission(context);
                await prefs.setBool('intro_value', true);
              },
              child: const Text('İzin Ver'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _exitApp(context);
              },
              child: const Text('İzin Verme'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Konum servisi kontrol ediliyor
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog(context);
      return;
    }

    // Konum izni kontrol ediliyor
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
      // Başarılı izin alındı, ana ekrana yönlendirme yapılabilir
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const AuthWrapper()));
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konum İzni Gerekli'),
          content: const Text(
              'Uygulama doğru çalışması için sürekli konum erişimine ihtiyaç duyar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _exitApp(context);
              },
              child: const Text('Uygulamayı Kapat'),
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
          title: const Text('Konum Servisi Kapalı'),
          content: const Text(
              'Uygulama doğru çalışması için konum servisinizin açık olması gerekmektedir.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _exitApp(context);
              },
              child: const Text('Uygulamayı Kapat'),
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
