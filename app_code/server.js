// Import Express
const express = require("express");

// Create the app
const app = express();

// Port where the microservice will run (Must match the Target Group)
const PORT = 8080; 

// Endpoint initial (Health Check)
app.get("/", (req, res) => {
  res.send("Microservicio de coworking activo 🏢✨");
});

// Endpoint as example
app.get("/espacios", (req, res) => {
  const espacios = [
    { id: 1, nombre: "Sala Reuniones A", capacidad: 6 },
    { id: 2, nombre: "Coworker Open Space", capacidad: 12 },
    { id: 3, nombre: "Oficina Privada 1", capacidad: 2 }
  ];

  res.json(espacios);
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor Node.js ejecutándose en http://0.0.0.0:${PORT}`);
});