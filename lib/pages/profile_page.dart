import 'package:CredexEcom/components/text_box.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _email;
  String? _profileImageUrl;
  Map<String, dynamic>? userData;

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email');
      _profileImageUrl = prefs.getString('image');
      print('Loaded email: $_email');
      print('Loaded profile image URL: $_profileImageUrl');
    });
  }

  Future<void> editField(String field) async {
    final TextEditingController controller = TextEditingController();
    String currentValue = "";

    if (field == "fullname") {
      currentValue = userData?['fullname'] ?? "";
    } else if (field == "address") {
      currentValue = userData?['address'] ?? "";
    }

    controller.text = currentValue;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $field"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter new $field"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String newValue = controller.text;
              if (newValue.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(_email)
                    .update({field: newValue});
                setState(() {});
              }
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: _email != null
            ? FirebaseFirestore.instance.collection("Users").doc(_email).snapshots()
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            userData = snapshot.data?.data() as Map<String, dynamic>?;

            return ListView(
              children: [
                const SizedBox(height: 25),
                _profileImageUrl != null
                    ? CircleAvatar(
                        radius: 72,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: _profileImageUrl!,
                            fit: BoxFit.cover,
                            width: 144,
                            height: 144,
                            placeholder: (context, url) => const CircularProgressIndicator(color: Color(0xFF5B0000),),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                      )
                    : const Icon(Icons.person, size: 72),
                if (_email != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _email!,
                      style: TextStyle(color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    AppLocalizations.of(context)!.myDetails,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Column(
                  children: [
                    TextBox(
                      text: userData?['fullname'] ?? "Dummy Data",
                      sectionName: AppLocalizations.of(context)!.fullName,
                      onPressed: () => editField("fullname"),
                    ),
                    TextBox(
                      text: userData?['address'] ?? "Empty Address",
                      sectionName: AppLocalizations.of(context)!.address,
                      onPressed: () => editField("address"),
                    ),
                    TextBox(
                      text: userData?['phoneNo'] ?? "+666633223",
                      sectionName: AppLocalizations.of(context)!.phoneNumber,
                      onPressed: () => editField("phoneNo"),
                    ),
                  ],
                ),
              ],
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
