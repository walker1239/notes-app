class Notes {
  int idNote;
  String title;
  String description;

  Notes({
    this.idNote,
    this.title,
    this.description,
  });

  factory Notes.fromMap(Map<String, dynamic> json) => new Notes(
    idNote: json["id"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "idNote": idNote,
    "title": title,
    "description": description,
  };

  int get _idNote => idNote;
  String get _title => title;
  String get _description => description;
}