import 'package:flutter/material.dart';
import 'package:route_app/constants/style.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  // Profil bilgileri
  String address = "123 Main St, Springfield";
  String createdAt = "2023-01-01";
  String displayName = "John Doe";
  String educationLevel = "Bachelor's Degree";
  String email = "johndoe@example.com";
  bool emailVerified = true;
  String fcmToken = "fcm_token_123";
  String phoneNumber = "+1 123 456 7890";
  String profilePhoto = ""; // Profile photo URL or placeholder
  String uid = "uid_123";
  String updatedUser = "2023-10-01";
  String username = "john_doe";

  // Düzenleme modları
  bool isEditing = false;
  String? fieldBeingEdited;

  // TextEditingController'lar
  TextEditingController addressController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController educationLevelController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController.text = address;
    displayNameController.text = displayName;
    educationLevelController.text = educationLevel;
    emailController.text = email;
    phoneNumberController.text = phoneNumber;
    usernameController.text = username;
  }

  // Bilgiyi kaydet
  void saveEditing() {
    setState(() {
      isEditing = false;
      address = addressController.text;
      displayName = displayNameController.text;
      educationLevel = educationLevelController.text;
      email = emailController.text;
      phoneNumber = phoneNumberController.text;
      username = usernameController.text;
      fieldBeingEdited = null;
    });
  }

  // Düzenleme alanı göster
  Widget buildEditableField(String label, TextEditingController controller) {
    if (isEditing && fieldBeingEdited == label) {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: "Edit $label"),
            ),
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: saveEditing,
          )
        ],
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          isEditing = true;
          fieldBeingEdited = label;
        });
      },
      child: ListTile(
        title: Text(label),
        subtitle: Text(controller.text),
        trailing: Icon(Icons.edit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Information"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profil fotoğrafı göster
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profilePhoto.isNotEmpty
                    ? NetworkImage(profilePhoto)
                    : AssetImage("assets/images/template.png") as ImageProvider,
              ),
            ),
            SizedBox(height: 20),

            // Bilgileri göster ve düzenleme moduna geç
            buildEditableField("DisplayName", displayNameController),
            buildEditableField("Username", usernameController),
            buildEditableField("Email", emailController),
            buildEditableField("PhoneNumber", phoneNumberController),
            buildEditableField("Address", addressController),
            buildEditableField("EducationLevel", educationLevelController),
            SizedBox(height: 20),

            // Sabit bilgiler
            ListTile(
              title: Text("UID"),
              subtitle: Text(uid),
            ),
            ListTile(
              title: Text("Created At"),
              subtitle: Text(createdAt),
            ),
            ListTile(
              title: Text("Last Updated User"),
              subtitle: Text(updatedUser),
            ),
            ListTile(
              title: Text("FCM Token"),
              subtitle: Text(fcmToken),
            ),
          ],
        ),
      ),
    );
  }
}
