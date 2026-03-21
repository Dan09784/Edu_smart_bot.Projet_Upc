const express = require('express');
const router = express.Router();

module.exports = (db) => {
  router.post('/register', (req, res) => {
    const { name, email, matricule, password, role } = req.body;

    if (!name || !email || !matricule || !password || !role) {
      return res.status(400).json({ message: 'Tous les champs sont requis' });
    }

    // Vérifier si l'email ou matricule existe déjà
    const checkQuery = role === 'student' 
      ? 'SELECT * FROM students WHERE email = ? OR matricule = ?'
      : 'SELECT * FROM teachers WHERE email = ? OR matricule = ?';

    db.query(checkQuery, [email, matricule], (err, results) => {
      if (err) {
        console.error('Erreur vérification:', err);
        return res.status(500).json({ message: 'Erreur serveur' });
      }

      if (results.length > 0) {
        return res.status(400).json({ message: 'Email ou matricule déjà utilisé' });
      }

      // Insertion selon le rôle
      const insertQuery = role === 'student'
        ? 'INSERT INTO students (name, email, matricule, password) VALUES (?, ?, ?, ?)'
        : 'INSERT INTO teachers (name, email, matricule, password) VALUES (?, ?, ?, ?)';

      db.query(insertQuery, [name, email, matricule, password], (err, result) => {
        if (err) {
          console.error('Erreur insertion:', err);
          return res.status(500).json({ message: 'Erreur lors de l\'inscription' });
        }

        res.status(201).json({ 
          message: 'Inscription réussie',
          id: result.insertId,
          role: role
        });
      });
    });
  });

  return router;
};