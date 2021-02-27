let http = require('http');
let requests = 0;
let podname = process.env.HOSTNAME;
let startTime;
let host;

let handleRequest = function (request, response) {
    response.setHeader('Content-Type', 'text/plain');
    response.writeHead(200);
    response.write("Hello World! | Running on: \n");
    response.write("Remote address: " + request.headers['x-forwarded-for'] + "\n");
    response.write("Host: " + host + "\n");
    response.end(" | v=1\n");
    console.log("Running On:", host, "| Total Requests:", ++requests, "| App Uptime:", (new Date() - startTime) / 1000, "seconds", "| Log Time:", new Date());
}

let www = http.createServer(handleRequest);
www.listen(8080, function () {
    startTime = new Date();
    host = process.env.HOSTNAME;
    console.log("Kubernetes Bootcamp App Started At:", startTime, "| Running On: ", host, "\n");
});