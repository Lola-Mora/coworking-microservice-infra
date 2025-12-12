#!/bin/bash
set -e

# --- 1. ENVIRONMENT CONFIGURATION ---
# The application will run from this directory
APP_DIR="/home/ec2-user/coworking-app"
LOG_FILE="/var/log/coworking-app.log"

# --- 2. SYSTEM DEPENDENCY INSTALLATION ---
echo "--- Updating system and installing Node.js ---"
yum update -y
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs git

# --- 3. APPLICATION CODE DOWNLOAD ---
echo "--- Cloning the microservice code ---"
mkdir -p $APP_DIR
cd $APP_DIR

# IMPORTANT NOTE: In a real scenario, the line below would be:
# git clone https://github.com/your-user/coworking-microservice.git .
# For this conceptual MVP, we simulate the download by creating the files:
# rm -rf * # Clean up the directory if it already exists

# --- 4. DEPENDENCY INSTALLATION AND EXECUTION ---
echo "--- Installing Node.js dependencies and executing ---"

# 4a. Create a simulated package.json for npm install
cat << 'EOF' > package.json
{
  "name": "coworking-microservice",
  "version": "1.0.0",
  "scripts": { "start": "node server.js" },
  "dependencies": { "express": "^4.18.2" }
}
EOF

# 4b. Create the server.js file
cat << 'EOF' > server.js
const express = require("express");
const app = express();
const PORT = 8080; // Internal port
app.get("/", (req, res) => {
  res.send("Coworking microservice active 🏢✨");
});
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Node.js server running on port ${PORT}`);
});
EOF


# 4c. Install Express dependencies
npm install 

# 4d. Execute the application in the background
nohup npm start > $LOG_FILE 2>&1 &

echo "Application startup script complete."