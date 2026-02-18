const http = require('http');

const PORT = process.env.PORT || 3000;
const version = process.env.APP_VERSION || "V1";

http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end(`Hello from the Node.js app version ${version}!`);
}).listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});