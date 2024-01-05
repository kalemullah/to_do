// ignore_for_file: public_member_api_docs, sort_constructors_first

class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat,
    };
  }

   Task.fromJson(Map<String, dynamic> json) {
      id= json['id'] ;
      title= json['title'];
      note = json['note'] ;
      isCompleted=  json['isCompleted'] ;
      date= json['date'] ;
      startTime= json['startTime'] ;
      endTime= json['endTime'] ;
      color= json['color'] ;
      remind= json['remind'] ;
      repeat= json['repeat'];
  }


}
