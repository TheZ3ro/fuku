var http = require("http"),
    url = require("url"),
    path = require("path"),
    fs = require("fs"),
    exec = require('child_process').exec,
    port = process.argv[2] || 8888,
    browser = process.argv[3] || "null";
    
http.createServer(function(request, response) {
  	
  var req = url.parse(request.url, true)
    , method = request.method   // request method
    , query = req.query  // optional /index.html?p=somethinglikethis
    , uri = req.pathname  // request URI pathname /index.html
    , filename = path.join(process.cwd(), uri);  // request absolute filename

  if(uri == "/exit"){
    response.writeHead(418, {"Content-Type": "text/plain"});
    response.write("418 I'm a teapot - Server is Closing\n");
    response.end();
    console.log("END");
    process.exit(0);
  }

  if(method == "POST"){
	var body = '';
    request.on('data', function (data) {
      body += data;
      //console.log("Partial body: " + body);
    });
    request.on('end', function () {
	  query = url.parse(uri+"?"+body, true).query
	  console.log("{\"method\":\""+method+"\",\"uri\":\""+uri+"\",\"serial\":\""+body+"\",\"json\":"+JSON.stringify(query, null, 0)+"}");
      response.writeHead(200, {"Content-Type": "text/plain"});
	  response.write("Request Sent\n");
      response.end();
      return;
    });  
  }

  var contentTypesByExtension = {
    '.html': "text/html",
    '.css':  "text/css",
    '.js':   "text/javascript"
  };

  fs.exists(filename, function(exists) {
    if(!exists) {
      response.writeHead(404, {"Content-Type": "text/plain"});
      response.write("404 Not Found\n");
      response.end();
      return;
    }

    if (fs.statSync(filename).isDirectory()) filename += '/index.html';

    fs.readFile(filename, "binary", function(err, file) {
      if(err) {        
        response.writeHead(500, {"Content-Type": "text/plain"});
        response.write(err + "\n");
        response.end();
        return;
      }

      var headers = {};
      var contentType = contentTypesByExtension[path.extname(filename)] || 'text/plain';
      if (contentType) headers["Content-Type"] = contentType;
      response.writeHead(200, headers);
      response.write(file, "binary");
      response.end();
    });
  });
}).listen(parseInt(port, 10));

console.log("# Static file server running at\n#  => http://localhost:" + port + "/\n# CTRL + C to shutdown");

if(browser == "null"){
  if(process.platform == "win32") { 
	exec("start http://localhost:" + port);
  } else if(process.platform == "darwin") { 
	exec("start http://localhost:" + port);
  } else if(process.platform == "linux") { 
    exec("x-www-browser http://localhost:" + port);
  }
} else {
  exec(browser+" http://localhost:"+port);
}
