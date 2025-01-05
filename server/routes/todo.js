const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const {
  getTodos,
  createTodo,
  updateTodo,
  deleteTodo
} = require('../controllers/todoController');

router.get('/', auth, getTodos);

router.post('/', auth, createTodo);

router.patch('/:todoId', auth, updateTodo);

router.delete('/:todoId', auth, deleteTodo);

module.exports = router;
