import 'package:flutter/material.dart';
import 'package:saint_schoolparent_pro/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Color(0xFFF1F4F8),
                    offset: Offset(0, 0),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/logo.png',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                            child: Text('Rajesh.S', style: getText(context).titleLarge),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                            child: Text('User.name@domainname.com', style: getText(context).titleMedium),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  child: SwitchListTile(
                onChanged: (bool value) {
                  isDark = !value;
                },
                value: isDark,
              )),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text('Switch Dark Mode'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
