#!/bin/bash
set -e

# --- 1. CONFIGURACIÓN DEL ENTORNO ---
# La aplicación se ejecutará desde este directorio
APP_DIR="/home/ec2-user/coworking-app"
LOG_FILE="/var/log/coworking-app.log"

# --- 2. INSTALACIÓN DE DEPENDENCIAS DEL SISTEMA ---
echo "--- Actualizando el sistema e instalando Node.js ---"
yum update -y
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs git

# --- 3. DESCARGA DEL CÓDIGO DE LA APLICACIÓN ---
echo "--- Clonando el código del microservicio ---"
mkdir -p $APP_DIR
cd $APP_DIR

# NOTA IMPORTANTE: En un escenario real, la línea de abajo sería:
# git clone https://github.com/tu-usuario/coworking-microservice.git .
# Para este MVP conceptual, usaremos un directorio vacío y simulamos la descarga:
# rm -rf * # Limpiar el directorio si ya existe

# --- 4. INSTALACIÓN DE DEPENDENCIAS Y EJECUCIÓN ---
echo "--- Instalando dependencias de Node.js y ejecutando ---"

# 4a. Crear un package.json simulado para npm install
cat << 'EOF' > package.json
{
  "name": "coworking-microservice",
  "version": "1.0.0",
  "scripts": { "start": "node server.js" },
  "dependencies": { "express": "^4.18.2" }
}
EOF

# 4b. Crear el archivo server.js
cat << 'EOF' > server.js
const express = require("express");
const app = express();
const PORT = 8080; // Puerto interno
app.get("/", (req, res) => {
  res.send("Microservicio de coworking activo 🏢✨");
});
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor Node.js ejecutándose en puerto ${PORT}`);
});
EOF


# 4c. Instalar las dependencias de Express
npm install 

# 4d. Ejecutar la aplicación en segundo plano
nohup npm start > $LOG_FILE 2>&1 &

echo "Script de arranque de la aplicación completo."