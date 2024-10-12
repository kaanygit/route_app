class Place {
  final int key;
  final String title;
  final String content;
  final String imageUrl;

  Place({
    required this.key,
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      key: json['key'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'content': content,
      'image_url': imageUrl,
    };
  }
}
