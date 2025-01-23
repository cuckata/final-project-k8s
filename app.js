const http = require('http');
const fs = require('fs');
const path = require('path');

// Helper function to serve static files
const serveFile = (filePath, res) => {
  const extname = path.extname(filePath);
  const contentType = {
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png': 'image/png',
    '.gif': 'image/gif',
    '.html': 'text/html',
  }[extname] || 'application/octet-stream';

  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('File Not Found');
    } else {
      res.writeHead(200, { 'Content-Type': contentType });
      res.end(data);
    }
  });
};

// Define a set of routes and their handlers
const routes = {
  '/': (req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(`
      <html>
        <head>
          <title>Welcome to Car Dealership</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              background-color: #f4f4f9;
              color: #222;
              margin: 0;
              padding: 0;
            }
            header, footer {
              background-color: #1e3d59;
              color: white;
              text-align: center;
              padding: 20px 0;
            }
            nav {
              display: flex;
              justify-content: center;
              background-color: #ff6f61;
              padding: 15px 0;
            }
            nav a {
              margin: 0 20px;
              text-decoration: none;
              color: white;
              font-weight: bold;
              font-size: 18px;
            }
            nav a:hover {
              text-decoration: underline;
            }
            .content {
              text-align: center;
              margin: 50px;
            }
            .car {
              display: inline-block;
              margin: 20px;
              text-align: center;
            }
            .car img {
              width: 200px;
              height: auto;
              border: 2px solid #1e3d59;
              border-radius: 10px;
            }
            .car h3 {
              margin: 10px 0;
            }
          </style>
        </head>
        <body>
          <header>
            <h1>Welcome to Premium Car Dealership</h1>
          </header>
          <nav>
            <a href="/">Home</a>
            <a href="/about">About Us</a>
            <a href="/api">API</a>
            <a href="/contact">Contact Us</a>
          </nav>
          <div class="content">
            <h2>Our Featured Cars</h2>
            <div class="car">
              <img src="/public/images/car1.jpg" alt="Car 1">
              <h3>2025 Sports Car</h3>
              <p>Price: $500,000</p>
            </div>
            <div class="car">
              <img src="/public/images/car2.jpg" alt="Car 2">
              <h3>2025 Sports car 2</h3>
              <p>Price: $400,000</p>
            </div>
            <div class="car">
              <img src="/public/images/car3.jpg" alt="Car 3">
              <h3>2025 Sedan</h3>
              <p>Price: $30,000</p>
            </div>
          </div>
          <footer>
            <p>&copy; 2025 Premium Car Dealership. All rights reserved.</p>
          </footer>
        </body>
      </html>
    `);
  },
  '/public/images/car1.jpg': (req, res) => serveFile(path.join(__dirname, 'public/images/car1.jpg'), res),
  '/public/images/car2.jpg': (req, res) => serveFile(path.join(__dirname, 'public/images/car2.jpg'), res),
  '/public/images/car3.jpg': (req, res) => serveFile(path.join(__dirname, 'public/images/car3.jpg'), res),
  '/about': (req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(`
      <html>
        <head>
          <title>About Us</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              background-color: #f4f4f9;
              color: #222;
              margin: 0;
              padding: 0;
            }
            header, footer {
              background-color: #1e3d59;
              color: white;
              text-align: center;
              padding: 20px 0;
            }
            nav {
              display: flex;
              justify-content: center;
              background-color: #ff6f61;
              padding: 15px 0;
            }
            nav a {
              margin: 0 20px;
              text-decoration: none;
              color: white;
              font-weight: bold;
              font-size: 18px;
            }
            nav a:hover {
              text-decoration: underline;
            }
            .content {
              text-align: center;
              margin: 50px;
            }
          </style>
        </head>
        <body>
          <header>
            <h1>About Our Dealership</h1>
          </header>
          <nav>
            <a href="/">Home</a>
            <a href="/about">About Us</a>
            <a href="/api">API</a>
            <a href="/contact">Contact Us</a>
          </nav>
          <div class="content">
            <h2>Why Choose Us?</h2>
            <p>At Premium Car Dealership, we offer a wide range of top-quality vehicles to meet all your needs. With a team of dedicated professionals, we are committed to providing excellent service and ensuring customer satisfaction.</p>
          </div>
          <footer>
            <p>&copy; 2025 Premium Car Dealership. All rights reserved.</p>
          </footer>
        </body>
      </html>
    `);
  },
  '/api': (req, res) => {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    const data = {
      message: 'Welcome to our Car Dealership API!',
      availableCars: [
        { name: '2025 Sports Car', price: '$50,000' },
        { name: '2025 SUV', price: '$40,000' },
        { name: '2025 Sedan', price: '$30,000' }
      ],
      timestamp: new Date().toISOString()
    };
    res.end(JSON.stringify(data, null, 2));
  },
  '/contact': (req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(`
      <html>
        <head>
          <title>Contact Us</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              background-color: #f4f4f9;
              color: #222;
              margin: 0;
              padding: 0;
            }
            header, footer {
              background-color: #1e3d59;
              color: white;
              text-align: center;
              padding: 20px 0;
            }
            nav {
              display: flex;
              justify-content: center;
              background-color: #ff6f61;
              padding: 15px 0;
            }
            nav a {
              margin: 0 20px;
              text-decoration: none;
              color: white;
              font-weight: bold;
              font-size: 18px;
            }
            nav a:hover {
              text-decoration: underline;
            }
            .content {
              text-align: center;
              margin: 50px;
            }
          </style>
        </head>
        <body>
          <header>
            <h1>Contact Premium Car Dealership</h1>
          </header>
          <nav>
            <a href="/">Home</a>
            <a href="/about">About Us</a>
            <a href="/api">API</a>
            <a href="/contact">Contact Us</a>
          </nav>
          <div class="content">
            <h2>Contact Information</h2>
            <p>We would love to hear from you! Reach out at:</p>
            <ul>
              <li>Email: <a href="mailto:support@premiumcars.com">support@premiumcars.com</a></li>
              <li>Phone: +123-456-7890</li>
              <li>Address: 123 Premium Lane, Car City, CA 90210</li>
            </ul>
          </div>
          <footer>
            <p>&copy; 2025 Premium Car Dealership. All rights reserved.</p>
          </footer>
        </body>
      </html>
    `);
  },
  '/not-found': (req, res) => {
    res.writeHead(404, { 'Content-Type': 'text/html' });
    res.end(`
      <html>
        <head>
          <title>404 Not Found</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              background-color: #ffe4e1;
              color: #333;
              text-align: center;
              margin: 0;
              padding: 0;
            }
            header, footer {
              background-color: #1e3d59;
              color: white;
              text-align: center;
              padding: 20px 0;
            }
            nav {
              display: flex;
              justify-content: center;
              background-color: #ff6f61;
              padding: 15px 0;
            }
            nav a {
              margin: 0 20px;
              text-decoration: none;
              color: white;
              font-weight: bold;
              font-size: 18px;
            }
            nav a:hover {
              text-decoration: underline;
            }
          </style>
        </head>
        <body>
          <header>
            <h1>404 - Page Not Found</h1>
          </header>
          <nav>
            <a href="/">Home</a>
            <a href="/about">About Us</a>
            <a href="/api">API</a>
            <a href="/contact">Contact Us</a>
          </nav>
          <div class="content">
            <h2>Oops!</h2>
            <p>Sorry, the page you are looking for does not exist.</p>
            <a href="/">Go back to Home</a>
          </div>
          <footer>
            <p>&copy; 2025 Premium Car Dealership. All rights reserved.</p>
          </footer>
        </body>
      </html>
    `);
  },
};

const server = http.createServer((req, res) => {
  const handler = routes[req.url] || routes['/not-found']; // Default to 404 if route is not found
  handler(req, res);
});

const port = process.env.PORT || 3000;
server.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
