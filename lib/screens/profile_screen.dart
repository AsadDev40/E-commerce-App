import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Pages/login.dart';
import 'package:myshop/models/user_model.dart';
import 'package:myshop/provider/auth_provider.dart' as authpro;
import 'package:myshop/screens/edit_profile_screen.dart';
import 'package:myshop/utils/utils.dart';
import 'package:myshop/widgets/constants.dart';
import 'package:provider/provider.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<authpro.AuthProvider>(context);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder<UserModel>(
          future: authProvider.getUserFromFirestore(currentUserId),
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading indicator while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Handle error
            } else {
              final user = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 29,
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        user.profileImage ?? 'https://via.placeholder.com/300'),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.userName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          'Email:',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.email,
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          'Address:',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.address.toString(),
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          minimumSize:
                              WidgetStateProperty.all(const Size(140, 40)),
                          alignment: Alignment.center),
                      onPressed: () {
                        Utils.navigateTo(
                            context,
                            EditProfilePage(
                              imagepath: user.profileImage.toString(),
                              username: user.userName,
                              email: user.email,
                              userid: currentUserId,
                              address: user.address.toString(),
                            ));
                      },
                      child: const Text('Edit Profile',
                          style: TextStyle(color: PrimaryColor))),
                  ElevatedButton(
                    style: ButtonStyle(
                        minimumSize:
                            WidgetStateProperty.all(const Size(140, 40)),
                        alignment: Alignment.center),
                    onPressed: () {
                      authProvider.logout();
                      Utils.pushAndRemovePrevious(context, const LoginPage());
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: PrimaryColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        minimumSize:
                            WidgetStateProperty.all(const Size(140, 40)),
                        alignment: Alignment.center),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Account'),
                            content: const Text(
                                'Are you sure you want to delete your account?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  authProvider.deleteUserDatatoFirestore();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(color: PrimaryColor),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
