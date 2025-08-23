import 'package:flutter/material.dart';
import '../home/post_model.dart';
import '../route.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl != null)
              Image.network(post.imageUrl!, height: 150, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(post.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(post.description),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.editPost);
                  },
                  icon: Icon(Icons.edit, color: Colors.blue),
                  label: Text("Edit"),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.deleteConfirmation);
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text("Delete"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
