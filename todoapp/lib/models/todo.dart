class Todo {
  final String id;
  final String name;
  final bool isCompleted;

  Todo({required this.id, required this.name, this.isCompleted = false});

  Todo toggleCompletion() {
    return Todo(
      id: id,
      name: name,
      isCompleted: !isCompleted,
    );
  }
}
