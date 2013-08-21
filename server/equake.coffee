path = require "path"
server = require "jefri-server"
connect = require "connect"

index = path.join __dirname, "..", "index.html"

# Like the rewt of a tree... not the root user
rewt = path.join __dirname, ".."

server.app.get "/", (r, s)-> s.sendfile index
server.app.use connect.static rewt

server.serve()
