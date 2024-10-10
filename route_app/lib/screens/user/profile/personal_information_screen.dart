import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:route_app/bloc/user/user_bloc.dart';
import 'package:route_app/bloc/user/user_event.dart';
import 'package:route_app/bloc/user/user_state.dart';
import 'package:route_app/models/user_model.dart';
import 'package:route_app/widgets/loading.dart';
import 'dart:io'; // For File and image handling

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  bool isEditing = false;
  String? fieldBeingEdited;
  File? selectedProfilePhoto; // For storing the selected photo

  TextEditingController addressController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController educationLevelController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  late UserModel initialUser; // To track initial user data

  final ImagePicker _picker = ImagePicker();

  void saveEditing(UserModel user) async {
    bool hasChanges = false;

    String newAddress = addressController.text;
    String newDisplayName = displayNameController.text;
    String newEducationLevel = educationLevelController.text;
    String newPhoneNumber = phoneNumberController.text;

    // Verilerdeki değişiklikleri kontrol et
    if (newAddress != user.address ||
        newDisplayName != user.displayName ||
        newEducationLevel != user.educationLevel ||
        newPhoneNumber != user.phoneNumber ||
        selectedProfilePhoto != null) {
      hasChanges = true;
    }

    if (hasChanges) {
      // Verileri güncellemek için BLoC event'ini tetikle
      context.read<UserBloc>().add(UserInformationChange(
            address: newAddress,
            displayName: newDisplayName,
            educationLevel: newEducationLevel,
            phoneNumber: newPhoneNumber,
            profilePhoto: selectedProfilePhoto ?? File(user.profilePhoto),
          ));
    }

    // Verilerin güncellenmesinin ardından güncel verileri al
  }

  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedProfilePhoto = File(pickedFile.path);
        isEditing = true; // Enable editing mode when a new photo is selected
      });
    }
  }

  Future<void> takePhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedProfilePhoto = File(pickedFile.path);
        isEditing = true; // Enable editing mode when a new photo is selected
      });
    }
  }

  void populateFields(UserModel user) {
    addressController.text = user.address;
    displayNameController.text = user.displayName;
    educationLevelController.text = user.educationLevel;
    phoneNumberController.text = user.phoneNumber;
    initialUser = user; // Save initial user data for comparison
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    if (isEditing && fieldBeingEdited == label) {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Edit $label",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => saveEditing(initialUser),
          ),
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

  Widget buildProfilePhotoSection(UserModel user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: selectedProfilePhoto != null
              ? FileImage(selectedProfilePhoto!)
              : user.profilePhoto.isNotEmpty
                  ? NetworkImage(user.profilePhoto)
                  : AssetImage("assets/images/template.png") as ImageProvider,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: pickImageFromGallery,
              tooltip: "Pick from gallery",
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: takePhoto,
              tooltip: "Take photo",
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Information"),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        if (state is UserLoading) {
          return LoadingScreen(); // Show loading indicator during updates
        }
        if (state is UserSuccess) {
          final UserModel user = state.user;
          if (addressController.text.isEmpty) {
            populateFields(user);
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                buildProfilePhotoSection(user), // Profile photo section

                SizedBox(height: 20),
                ListTile(
                  title: Text("E-Mail"),
                  subtitle: Text(user.email),
                ),

                // Editable fields
                buildEditableField("Display Name", displayNameController),
                buildEditableField("Phone Number", phoneNumberController),
                buildEditableField("Address", addressController),
                buildEditableField("Education Level", educationLevelController),

                SizedBox(height: 20),

                // Static fields
                ListTile(
                  title: Text("Created At"),
                  subtitle: Text(user.createdAt),
                ),
                ListTile(
                  title: Text("Last Updated User"),
                  subtitle: Text(user.updatedUser),
                ),
              ],
            ),
          );
        } else if (state is UserProfileUpdateSuccess) {
          final UserModel user = state.user;
          if (addressController.text.isEmpty) {
            populateFields(user);
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                buildProfilePhotoSection(user), // Profile photo section

                SizedBox(height: 20),
                ListTile(
                  title: Text("E-Mail"),
                  subtitle: Text(user.email),
                ),

                // Editable fields
                buildEditableField("Display Name", displayNameController),
                buildEditableField("Phone Number", phoneNumberController),
                buildEditableField("Address", addressController),
                buildEditableField("Education Level", educationLevelController),

                SizedBox(height: 20),

                // Static fields
                ListTile(
                  title: Text("Created At"),
                  subtitle: Text(user.createdAt),
                ),
                ListTile(
                  title: Text("Last Updated User"),
                  subtitle: Text(user.updatedUser),
                ),
              ],
            ),
          );
        } else if (state is UserFailure) {
          return Container(
              child:
                  Text("HATA MEYDANA GELDİ FAİLUERA")); // Handle other states
        }
        return Container(
            child: Text("HATA MEYDANA GELDİ FAİLUERA")); // Handle other states
      }),
      floatingActionButton: isEditing
          ? FloatingActionButton(
              onPressed: () => saveEditing(initialUser),
              child: Icon(Icons.save),
              backgroundColor: Colors.green,
            )
          : null, // Show the save button only when editing
    );
  }
}
