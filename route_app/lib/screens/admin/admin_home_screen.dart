import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Paneli'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Çıkış yapma fonksiyonu burada olacak
              // Örneğin: context.read<AuthBloc>().add(LogoutEvent());
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // İki sütunlu bir grid düzeni
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildAdminCard(
              context,
              title: 'Kullanıcı Yönetimi',
              icon: Icons.people,
              onTap: () {
                // Kullanıcı yönetim sayfasına yönlendirme
                // Navigator.pushNamed(context, '/userManagement');
              },
            ),
            _buildAdminCard(
              context,
              title: 'Raporlar',
              icon: Icons.bar_chart,
              onTap: () {
                // Raporlar sayfasına yönlendirme
                // Navigator.pushNamed(context, '/reports');
              },
            ),
            _buildAdminCard(
              context,
              title: 'Ayarlar',
              icon: Icons.settings,
              onTap: () {
                // Ayarlar sayfasına yönlendirme
                // Navigator.pushNamed(context, '/settings');
              },
            ),
            _buildAdminCard(
              context,
              title: 'Geri Bildirim',
              icon: Icons.feedback,
              onTap: () {
                // Geri bildirim sayfasına yönlendirme
                // Navigator.pushNamed(context, '/feedback');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
