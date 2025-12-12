// Import Express
const express = require("express");

// Create the app
const app = express();

// Port where the microservice will run (Must match the Target Group)
const PORT = 8080; 

// Endpoint initial (Health Check)
app.get("/", (req, res) => {
  res.send("Coworking microservice active 🏢✨");
});

// Endpoint as example
app.get("/spaces", (req, res) => {
  const spaces = [
    { id: 1, name: "Sala Reuniones A", capacity: 6 },
    { id: 2, name: "Coworker Open Space", capacity: 12 },
    { id: 3, name: "Oficina Privada 1", capacity: 2 }
  ];

  res.json(spaces);
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server Node.js execute in http://0.0.0.0:${PORT}`);
});