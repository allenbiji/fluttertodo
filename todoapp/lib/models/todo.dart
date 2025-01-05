class Todo {
  final String id;
  final String name;
  final bool isCompleted;

  Todo({required this.id, required this.name, this.isCompleted = false});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      name: json['name'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Todo toggleCompletion() {
    return Todo(
      id: id,
      name: name,
      isCompleted: !isCompleted,
    );
  }
}
