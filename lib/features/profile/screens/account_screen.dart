import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:ecozyne_mobile/features/profile/widgets/profile_menu_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  @override
  Widget build(BuildContext context) {
    NavigationProvider navProvider = context.read<NavigationProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Akun',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Profile Section
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),

                  CustomText(
                    'Domi Imoet',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        '2000 Poin',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF55C173),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          navProvider.setIndex(2);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF55C173),
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Tukar poin'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Divider(height: 1, color: Colors.grey[300]),
            
            const Expanded(
              child: ProfileMenuList()
            ),
          ],
        ),
      ),
    );
  }
}