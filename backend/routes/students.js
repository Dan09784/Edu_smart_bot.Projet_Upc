const express = require('express');
const router = express.Router();

module.exports = (db) => {

  // Voir tous les étudiants
  router.get('/students', (req, res) => {
    db.query('SELECT * FROM students', (err, results) => {
      if (err) return res.status(500).json(err);
      res.json(results);
    });
  });

  // Voir un étudiant spécifique
  router.get('/students/:id', (req, res) => {
    const studentId = req.params.id;

    db.query(
      'SELECT * FROM students WHERE id = ?',
      [studentId],
      (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
      }
    );
  });

  // Ajouter un étudiant
  router.post('/students', (req, res) => {
    const { name, email, password } = req.body;

    db.query(
      'INSERT INTO students (name, email, password) VALUES (?, ?, ?)',
      [name, email, password],
      (err, result) => {
        if (err) return res.status(500).json(err);
        res.json({ message: 'Étudiant ajouté' });
      }
    );
  });

  return router;
};