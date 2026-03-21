const express = require('express');
const router = express.Router();

module.exports = (db) => {
  // Route pour la connexion
  router.post('/login', (req, res) => {
    const { email, password } = req.body;

    console.log('📝 Tentative de connexion avec:', email);

    // Chercher dans students d'abord
    db.query('SELECT * FROM students WHERE (email = ? OR matricule = ?) AND password = ?', 
      [email, email, password], (err, studentResults) => {
        if(err) {
          console.error('❌ Erreur SQL (students):', err);
          return res.status(500).json({ 
            message: 'Erreur serveur',
            error: err.message 
          });
        }
        
        if(studentResults.length > 0) {
          console.log('✅ Étudiant trouvé:', studentResults[0]);
          return res.json({
            id: studentResults[0].id,
            role: 'student',
            name: studentResults[0].name,
            matricule: studentResults[0].matricule,
            email: studentResults[0].email
          });
        }

        // Chercher dans teachers
        db.query('SELECT * FROM teachers WHERE (email = ? OR matricule = ?) AND password = ?', 
          [email, email, password], (err, teacherResults) => {
            if(err) {
              console.error('❌ Erreur SQL (teachers):', err);
              return res.status(500).json({ 
                message: 'Erreur serveur',
                error: err.message 
              });
            }
            
            if(teacherResults.length > 0) {
              console.log('✅ Enseignant trouvé:', teacherResults[0]);
              return res.json({
                id: teacherResults[0].id,
                role: 'teacher',
                name: teacherResults[0].name,
                matricule: teacherResults[0].matricule,
              });
            }

            // Chercher dans admins
            db.query('SELECT * FROM admins WHERE email = ? AND password = ?', 
              [email, password], (err, adminResults) => {
                if(err) {
                  console.error('❌ Erreur SQL (admins):', err);
                  return res.status(500).json({ 
                    message: 'Erreur serveur',
                    error: err.message 
                  });
                }
                
                if(adminResults.length > 0) {
                  console.log('✅ Admin trouvé:', adminResults[0]);
                  return res.json({
                    id: adminResults[0].id,
                    role: 'admin',
                    name: adminResults[0].name,
                  });
                }

                console.log('⚠️ Utilisateur non trouvé dans aucune table');
                res.status(401).json({ message: 'Email ou mot de passe incorrect' });
              });
          });
    });
  });

  // Endpoint de test pour vérifier la connexion à la BDD
  router.get('/test-db', (req, res) => {
    console.log('🔧 Test de la base de données...');
    
    db.query('SELECT COUNT(*) as count FROM students', (err, results) => {
      if(err) {
        console.error('❌ Erreur BDD:', err);
        return res.status(500).json({ 
          message: 'Erreur connexion BDD',
          error: err.message 
        });
      }
      
      res.json({ 
        message: 'BDD connectée ✅',
        studentsCount: results[0].count 
      });
    });
  });

  return router;
};  