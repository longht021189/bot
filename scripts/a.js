const fs = require('fs');

// Function to read file and convert to base64
function convertFileToBase64(filePath) {
    // Read the file
    fs.readFile(filePath, (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return;
        }
        // Convert to base64
        const base64Data = data.toString('base64');
        console.log('Base64 Data:', base64Data);
    });
}

// Specify the file path
const filePath = 'C:/Users/longh/.ssh/id_ed25519.pub';
convertFileToBase64(filePath);