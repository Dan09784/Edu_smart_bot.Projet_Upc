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

  // Voir les plaintes d’un étudiant
  router.get('/complaints/student/:id', (req, res) => {
    const studentId = req.params.id;

    db.query(
      'SELECT * FROM complaints WHERE student_id = ?',
      [studentId],
      (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
      }
    );
  });

  // Voir les plaintes d’un cours
  router.get('/complaints/course/:id', (req, res) => {
    const courseId = req.params.id;

    db.query(
      'SELECT * FROM complaints WHERE course_id = ?',
      [courseId],
      (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
      }
    );
  });

  // Modifier le statut d’une plainte
  router.put('/complaints/:id/status', (req, res) => {
    const complaintId = req.params.id;
    const { status } = req.body;

    db.query(
      'UPDATE complaints SET status = ? WHERE id = ?',
      [status, complaintId],
      (err, result) => {
        if (err) return res.status(500).json(err);
        res.json({ message: 'Statut mis à jour' });
      }
    );
  });

  // Supprimer une plainte
  router.delete('/complaints/:id', (req, res) => {
    const complaintId = req.params.id;

    db.query(
      'DELETE FROM complaints WHERE id = ?',
      [complaintId],
      (err, result) => {
        if (err) return res.status(500).json(err);
        res.json({ message: 'Plainte supprimée' });
      }
    );
  });

  return router;
};