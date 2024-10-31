class Place {
  final int key;
  final String titleTr;
  final String titleEng;
  final String contentTr;
  final String contentEng;
  final String imageUrl;
  final double latitude;
  final double longitude;

  Place({
    required this.key,
    required this.titleTr,
    required this.titleEng,
    required this.contentTr,
    required this.contentEng,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      key: json['key'] ?? 0,
      titleTr: json['title_tr'] ?? '',
      titleEng: json['title_eng'] ?? '',
      contentTr: json['content_tr'] ?? '',
      contentEng: json['content_eng'] ?? '',
      imageUrl: json['image_url'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title_tr': titleTr,
      'title_eng': titleEng,
      'content_tr': contentTr,
      'content_eng': contentEng,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
