import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:accesible_route/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserManagementScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String globalAdminUid = dotenv.env['GLOBAL_ADMIN_UID'] ?? '';

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).admin_user_management_title),
        backgroundColor: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.transparent,
        elevation: 0,
      ),
      backgroundColor:
          isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: StreamBuilder(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];

              if (user.id == globalAdminUid) {
                return SizedBox.shrink();
              }

              return Card(
                elevation: 4,
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/template.png'),
                  ),
                  title: Text(
                    user['displayName'] ?? 'İsimsiz Kullanıcı',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    user['email'] ?? 'Email bulunamadı',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.black54,
                    ),
                  ),
                  trailing: Icon(
                    Icons.edit,
                    color: isDarkMode ? Colors.white : Colors.deepPurple,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserEditScreen(
                          userId: user.id,
                          displayName: user['displayName'],
                          email: user['email'],
                          isAdmin: user['isAdmin'] ?? false,
                          isAccountFrozen: user['isAccountFrozen'] ?? false,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserEditScreen extends StatefulWidget {
  final String userId;
  final String displayName;
  final String email;
  final bool isAdmin;
  final bool isAccountFrozen;

  UserEditScreen({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.isAdmin,
    required this.isAccountFrozen,
  });

  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isAdmin = false;
  bool _isAccountFrozen = false;

  @override
  void initState() {
    super.initState();
    _isAdmin = widget.isAdmin;
    _isAccountFrozen = widget.isAccountFrozen;
  }

  Future<void> _toggleAdminStatus() async {
    try {
      await _firestore.collection('users').doc(widget.userId).update({
        'isAdmin': !_isAdmin,
      });
      setState(() {
        _isAdmin = !_isAdmin;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _toggleAccountStatus() async {
    try {
      await _firestore.collection('users').doc(widget.userId).update({
        'isAccountFrozen': !_isAccountFrozen,
      });
      setState(() {
        _isAccountFrozen = !_isAccountFrozen;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).admin_user_edit_title),
        backgroundColor: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
      ),
      backgroundColor:
          isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${S.of(context).admin_user_management_user}: ${widget.displayName}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              'Email: ${widget.email}',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text(
                S.of(context).admin_user_management_admin_yetki,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                S.of(context).admin_user_management_admin_yetki_content,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey,
                ),
              ),
              value: _isAdmin,
              onChanged: (bool value) {
                _toggleAdminStatus();
              },
              activeColor: Colors.deepPurple,
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: Text(
                S.of(context).admin_user_management_dondurma_yetki,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                S.of(context).admin_user_management_dondurma_yetki_content,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey,
                ),
              ),
              value: _isAccountFrozen,
              onChanged: (bool value) {
                _toggleAccountStatus();
              },
              activeColor: Colors.redAccent,
            ),
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? Colors.grey[800] : Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  S.of(context).admin_user_editAndSave_title,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
