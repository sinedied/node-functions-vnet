const fs = require('fs');
const path = require('path');

// Define the path to the dist directory
const distDir = path.join(__dirname, 'dist');

// Delete the dist directory if it exists
if (fs.existsSync(distDir)) {
  fs.rmSync(distDir, { recursive: true });
}

// Create the dist directory
fs.mkdirSync(distDir);

// Read the index.html file
let indexHtml = fs.readFileSync(path.join(__dirname, 'index.html'), 'utf8');

// Replace __API_URL__ with the environment variable
indexHtml = indexHtml.replace('__API_URL__', process.env.API_URL);

// Write the updated content to dist/index.html
fs.writeFileSync(path.join(distDir, 'index.html'), indexHtml);

// Log a success message
console.log(`Build success! API URL: ${process.env.API_URL}`);
