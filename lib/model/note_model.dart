class NoteModel {
  final int id;
  final String title;
  final String description;
  final String date;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });
  // using for add & update data
  Map<String, dynamic> fromJson() {
    return ({
      'id': id,
      'title': title,
      'description': description,
      'date': date
    });
  }

  // using for get data
  NoteModel.toJson(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        description = res['description'],
        date = res['date'];
}
