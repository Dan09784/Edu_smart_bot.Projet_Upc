const express = require('express');
const router = express.Router();

module.exports = (db) => {

  // Voir tous les cours
  router.get('/courses', (req, res) => {
    db.query('SELECT * FROM courses', (err, results) => {
      if (err) return res.status(500).json(err);
      res.json(results);
    });
  });

  // Voir un cours spécifique
  router.get('/courses/:id', (req, res) => {
    const courseId = req.params.id;

    db.query(
      'SELECT * FROM courses WHERE id = ?',
      [courseId],
      (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
      }
    );
  });

  // Voir les cours d’un professeur
  router.get('/courses/teacher/:id', (req, res) => {
    const teacherId = req.params.id;

    db.query(
      'SELECT * FROM courses WHERE teacher_id = ?',
      [teacherId],
      (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
      }
    );
  });

  // Ajouter un cours (admin)
  router.post('/courses', (req, res) => {
    const { name, teacher_id } = req.body;

    db.query(
      'INSERT INTO courses (name, teacher_id) VALUES (?, ?)',
      [name, teacher_id],
      (err, result) => {
        if (err) return res.status(500).json(err);
        res.json({ message: 'Cours ajouté' });
      }
    );
  });

  return router;
};