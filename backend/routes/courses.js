const express = require("express");
const router = express.Router();
const db = require("../db");


// voir tous les cours
router.get("/", (req, res) => {

  db.query("SELECT * FROM courses", (err, result) => {

    if(err){
      return res.status(500).json({message: "Erreur serveur"});
    }

    res.json(result);

  });

});


// ajouter un cours (admin)
router.post("/", (req, res) => {

  const { title, teacher_id } = req.body;

  const sql = "INSERT INTO courses (title, teacher_id) VALUES (?, ?)";

  db.query(sql, [title, teacher_id], (err, result) => {

    if(err){
      return res.status(500).json({message: "Erreur serveur"});
    }

    res.json({message: "Cours ajouté"});
  });

});


// voir les cours d'un professeur
router.get("/teacher/:id", (req, res) => {

  const teacherId = req.params.id;

  const sql = "SELECT * FROM courses WHERE teacher_id = ?";

  db.query(sql, [teacherId], (err, result) => {

    if(err){
      return res.status(500).json({message: "Erreur serveur"});
    }

    res.json(result);

  });

});


module.exports = router;