const express = require('express');
const router = express.Router();

module.exports = (db) => {
  // Voir tous les enseignants
  router.get('/teachers', (req, res) => {
    db.query('SELECT * FROM teachers', (err, results) => {
      if (err) return res.status(500).json(err);
      res.json(results);
    });
  });

  // Voir un enseignant specifique
  router.get('/teachers/:id', (req, res) => {
    const teacherId = req.params.id;

    db.query(
      'SELECT * FROM teachers WHERE id = ?',
      [teacherId],
      (err, results) => {
        if (err) return res.status(500).json(err);
        if (results.length === 0) {
          return res.status(404).json({ message: 'Enseignant introuvable' });
        }
        res.json(results[0]);
      }
    );
  });

  // Ajouter un enseignant
  router.post('/teachers', (req, res) => {
    const { name, email, matricule, password } = req.body;

    if (!name || !email || !matricule || !password) {
      return res
        .status(400)
        .json({ message: 'name, email, matricule et password sont requis' });
    }

    db.query(
      'INSERT INTO teachers (name, email, matricule, password) VALUES (?, ?, ?, ?)',
      [name, email, matricule, password],
      (err, result) => {
        if (err) return res.status(500).json(err);
        res.status(201).json({ message: 'Enseignant ajoute', id: result.insertId });
      }
    );
  });

  return router;
};
