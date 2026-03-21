const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '', // mets ton mot de passe MySQL ici
  database: 'edusmartbot'
});

db.connect((err) => {
  if (err) {
    console.error('Erreur connexion MySQL:', err);
  } else {
    console.log('Connecté à MySQL');
  }
});
const authRoutes = require('./routes/auth');
app.use(authRoutes(db));

const complaintRoutes = require('./routes/complaints');
app.use(complaintRoutes(db));

const coursesRoutes = require('./routes/courses');
app.use(coursesRoutes(db));

const studentsRoutes = require('./routes/students');
app.use(studentsRoutes(db));

const teachersRoutes = require('./routes/teachers');
app.use(teachersRoutes(db));

const registerRoutes = require('./routes/register');
app.use(registerRoutes(db));

app.get('/', (req, res) => {
  res.send('Backend EduSmartBot en marche 🚀');
});

app.get('/api/test', (req, res) => {
  res.json({message : 'BAckend ok', timestamp:new Date(). toISOString()

  });
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Serveur lancé sur http://localhost:3000');
  console.log('Accessible sur http://127.0.0.1:3000' );
});