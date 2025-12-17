class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String? publishedDate;
  final String? description;
  final String? thumbnail;
  final String? previewLink;

  Book({
    required this.id, 
    required this.title,
    required this.authors, 
    this.publishedDate, 
    this.description, 
    this.thumbnail,
    this.previewLink
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json["volumeInfo"] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};

    return Book(
      id: json["id"] ?? "", 
      title: volumeInfo["title"], 
      authors: List<String>.from(volumeInfo["authors"] ?? ["Unknown Author"]),
      publishedDate: volumeInfo["publishedDate"],
      description: volumeInfo["description"],
      thumbnail: imageLinks["thumbnail"]?.replaceAll("http:", "https:"),
      previewLink: volumeInfo['previewLink']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'title': title,
      'authors': authors.join(', '),
      'publishedDate': publishedDate,
      'description': description,
      'thumbnail': thumbnail,
      'previewLink': previewLink
    };
  }

  factory Book.fromMap(Map<String, dynamic> map){
    return Book(
      id: map["id"] ?? "",
      title: map["title"] ?? "Unknown Title",
      authors: (map["authors"] as String).split(', '),
      publishedDate: map["publishedDate"],
      description: map["description"],
      thumbnail: map["thumbnail"],
      previewLink: map["previewLink"]
    );
  }

  Map<String, dynamic> toMap(){
    return {
        'id': id,
      'title': title,
      'authors': authors.join(', '),
      'publishedDate': publishedDate,
      'description': description,
      'thumbnail': thumbnail,
      'previewLink': previewLink,
    }
  }
}