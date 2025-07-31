import 'package:flutter/material.dart';
import 'package:app_drive_v1_0/presentation/screens/deblock/deblock_user_controller.dart';

class DeblockUserScreen extends StatefulWidget {

  const DeblockUserScreen({super.key});
  @override
  _DeblockUserScreenState createState() => _DeblockUserScreenState();
}

class _DeblockUserScreenState extends State<DeblockUserScreen> {
  final validate = DeblockUserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Débloquer utilisateurs')),
      body: FutureBuilder<List<dynamic>>(
        future: validate.fetchPendingUsers(),
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun utilisateur trouvé'));
          } else {
            final users = snapshot.data!;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () async {
                      final userId = user['id'].toString();
                      await validate.acceptUser(userId);

                      // Optionnel : rafraîchir l'écran après validation
                      setState(() {});
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: Text(
                        '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim().isEmpty
                            ? 'Pas de nom'
                            : '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['email'] ?? 'Pas d\'email'),
                          const SizedBox(height: 4),
                          Text('ID: ${user['id'] ?? 'Inconnu'}'),
                        ],
                      ),
                      trailing: const Icon(Icons.check, color: Colors.green),
                    ),
                  ),
                );


              },
            );
          }
        },
      ),
    );
  }
}
