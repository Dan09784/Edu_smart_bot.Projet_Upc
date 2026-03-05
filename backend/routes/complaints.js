const express = require('express');
const router = express.Router();

module.exports = (db) => {

  // Ajouter plainte
  router.post('/complaints', (req, res) => {
    const { student_id, course_id, message } = req.body;

    db.query(
      'INSERT INTO complaints (student_id, course_id, message) VALUES (?, ?, ?)',
      [student_id, course_id, message],
      (err, result) => {
        if (err) return res.status(500).json(err);
        res.json({ message: 'Plainte enregistrée' });
      }
    );
  });

  // Voir toutes les plaintes (admin)
  router.get('/complaints', (req, res) => {
    db.query('SELECT * FROM complaints', (err, results) => {
      if (err) return res.status(500).json(err);
      res.json(results);
    });
  });

  return router;
};