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

app.get('/', (req, res) => {
  res.send('Backend EduSmartBot en marche 🚀');
});

app.listen(3000, () => {
  console.log('Serveur lancé sur http://localhost:3000');
});