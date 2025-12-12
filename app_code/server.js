// Importamos Express
const express = require("express");

// Creamos la app
const app = express();

// Puerto donde correrá el microservicio (Debe coincidir con el Target Group)
const PORT = 8080; 

// Endpoint inicial (Health Check)
app.get("/", (req, res) => {
  res.send("Microservicio de coworking activo 🏢✨");
});

// Endpoint de ejemplo: lista de espacios
app.get("/espacios", (req, res) => {
  const espacios = [
    { id: 1, nombre: "Sala Reuniones A", capacidad: 6 },
    { id: 2, nombre: "Coworker Open Space", capacidad: 12 },
    { id: 3, nombre: "Oficina Privada 1", capacidad: 2 }
  ];

  res.json(espacios);
});

// Arrancamos el servidor
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor Node.js ejecutándose en http://0.0.0.0:${PORT}`);
});