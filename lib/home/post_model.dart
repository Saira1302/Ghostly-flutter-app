class PostModel {
  final String title;
  final String description;
  final String? imageUrl;

  PostModel({
    required this.title,
    required this.description,
    this.imageUrl,
  });
}
