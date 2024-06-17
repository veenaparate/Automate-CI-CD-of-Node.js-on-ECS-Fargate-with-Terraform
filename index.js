// Importing required modules
const http = require('http');

// Creating a server
const server = http.createServer((req, res) => {
    // Setting the response header
    res.writeHead(200, {'Content-Type': 'text/plain'});

    // Sending the response
    res.end('Hello, this is Veena Parate I am aspiring AWS Devops\n');
});

// Specifying the port and starting the server
const port = 3000;
server.listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});
