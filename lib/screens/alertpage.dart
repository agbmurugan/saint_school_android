import 'package:flutter/material.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({Key? key}) : super(key: key);

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/logo.png'),
                    ),
                    title: const Text('Breakfast'),
                    subtitle: const Text('Taken'),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Aug 15 2022'),
                        Text('9:30 AM'),
                      ],
                    )),
              );
            }));
  }
}
