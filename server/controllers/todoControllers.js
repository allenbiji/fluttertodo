const Todo = require('../models/Todo');

exports.getTodos = async (req, res) => {
  try {
    const userId = req.userId;
    const todos = await Todo.find({ userId }).sort({ createdAt: -1 });
    res.json(todos);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

exports.createTodo = async (req, res) => {
  try {
    const userId = req.userId;
    const { title } = req.body;

    if (!title) {
      return res.status(400).json({ message: 'Title is required' });
    }

    const newTodo = await Todo.create({ userId, title });
    res.status(201).json(newTodo);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

exports.updateTodo = async (req, res) => {
  try {
    const userId = req.userId;
    const { todoId } = req.params;
    const { isCompleted } = req.body;

    const todo = await Todo.findOneAndUpdate(
      { _id: todoId, userId },
      { isCompleted },
      { new: true }
    );

    if (!todo) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    res.json(todo);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

exports.deleteTodo = async (req, res) => {
  try {
    const userId = req.userId;
    const { todoId } = req.params;

    const todo = await Todo.findOneAndDelete({ _id: todoId, userId });
    if (!todo) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    res.json({ message: 'Todo deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};
