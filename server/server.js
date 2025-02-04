require('dotenv').config();
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const connectDB = require('./config/db');


const app = express();


connectDB();


app.use(express.json());         
app.use(cors());                  
app.use(morgan('dev'));           


app.use('/api/auth', require('./routes/auth'));
app.use('/api/todos', require('./routes/todo'));


const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
