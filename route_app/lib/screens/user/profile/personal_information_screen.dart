import 'package:accesible_route/bloc/user/user_bloc.dart';
import 'package:accesible_route/bloc/user/user_event.dart';
import 'package:accesible_route/bloc/user/user_state.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/models/user_model.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:accesible_route/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  bool isEditing = false;
  String? fieldBeingEdited;
  File? selectedProfilePhoto;

  TextEditingController addressController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController educationLevelController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  late UserModel initialUser;

  final ImagePicker _picker = ImagePicker();

  void saveEditing(UserModel user) async {
    bool hasChanges = false;

    String newAddress = addressController.text;
    String newDisplayName = displayNameController.text;
    String newEducationLevel = educationLevelController.text;
    String newPhoneNumber = phoneNumberController.text;

    if (newAddress != user.address ||
        newDisplayName != user.displayName ||
        newEducationLevel != user.educationLevel ||
        newPhoneNumber != user.phoneNumber ||
        selectedProfilePhoto != null) {
      hasChanges = true;
    }

    if (hasChanges) {
      context.read<UserBloc>().add(UserInformationChange(
            address: newAddress,
            displayName: newDisplayName,
            educationLevel: newEducationLevel,
            phoneNumber: newPhoneNumber,
            profilePhoto: selectedProfilePhoto ?? File(user.profilePhoto),
          ));
      // context.read<UserBloc>().add(UserInformationGets());
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedProfilePhoto = File(pickedFile.path);
        isEditing = true;
      });
    }
  }

  Future<void> takePhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedProfilePhoto = File(pickedFile.path);
        isEditing = true;
      });
    }
  }

  void populateFields(UserModel user) {
    addressController.text = user.address;
    displayNameController.text = user.displayName;
    educationLevelController.text = user.educationLevel;
    phoneNumberController.text = user.phoneNumber;
    initialUser = user;
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
    bool isDarkMode = ThemeUtils.isDarkMode(context);
    setState(() {
      isDarkMode = !isDarkMode;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).user_profile_personal_information_title),
        backgroundColor: isDarkMode
            ? Colors.white
            : Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor:
          isDarkMode ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        if (state is UserLoading) {
          return LoadingScreen();
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
                buildProfilePhotoSection(user),
                SizedBox(height: 20),
                ListTile(
                  title: Text("E-Mail"),
                  subtitle: Text(user.email),
                ),
                buildEditableField(
                    S.of(context).user_profile_screen_displayname_title,
                    displayNameController),
                buildEditableField(
                    S.of(context).user_profile_screen_phoneNumber_title,
                    phoneNumberController),
                buildEditableField(
                    S.of(context).user_profile_screen_address_title,
                    addressController),
                buildEditableField(
                    S.of(context).user_profile_screen_educationLevel_title,
                    educationLevelController),
                SizedBox(height: 20),
              ],
            ),
          );
        } else if (state is UserSuccess) {
          final UserModel user = state.user;
          if (addressController.text.isEmpty) {
            populateFields(user);
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                buildProfilePhotoSection(user),
                SizedBox(height: 20),
                ListTile(
                  title: Text("E-Mail"),
                  subtitle: Text(user.email),
                ),
                buildEditableField(
                    S.of(context).user_profile_screen_displayname_title,
                    displayNameController),
                buildEditableField(
                    S.of(context).user_profile_screen_phoneNumber_title,
                    phoneNumberController),
                buildEditableField(
                    S.of(context).user_profile_screen_address_title,
                    addressController),
                buildEditableField(
                    S.of(context).user_profile_screen_educationLevel_title,
                    educationLevelController),
                SizedBox(height: 20),
              ],
            ),
          );
        } else if (state is UserFailure) {
          return Container(child: Text("HATA MEYDANA GELDİ FAİLUERA"));
        }
        return Container(child: Text("HATA MEYDANA GELDİ FAİLUERA"));
      }),
      floatingActionButton: isEditing
          ? FloatingActionButton(
              onPressed: () => saveEditing(initialUser),
              child: Icon(Icons.save),
              backgroundColor: Colors.green,
            )
          : null,
    );
  }
}
