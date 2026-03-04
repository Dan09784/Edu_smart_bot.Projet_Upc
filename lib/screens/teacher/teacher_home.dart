import 'package:flutter/material.dart';

class TeacherHome extends StatelessWidget {
  const TeacherHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Espace proffesseur"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, '/login' as Route<Object?>);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bonjour Professeur",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _item(icon: Icons.menu_book, title: "Gerer les cours"),
                  _item(icon: Icons.assignment, title: "Gerer les cours"),
                  _item(icon: Icons.bar_chart, title: "Gerer les cours"),
                  _item(icon: Icons.smart_toy, title: "Gerer les cours"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item({required IconData icon, required String title}) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {},
      ),
    );
  }
}
