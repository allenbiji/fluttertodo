const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const {
  getTodos,
  createTodo,
  updateTodo,
  deleteTodo
} = require('../controllers/todoController');

// GET /api/todos
router.get('/', auth, getTodos);

// POST /api/todos
router.post('/', auth, createTodo);

// PATCH /api/todos/:todoId
router.patch('/:todoId', auth, updateTodo);

// DELETE /api/todos/:todoId
router.delete('/:todoId', auth, deleteTodo);

module.exports = router;
