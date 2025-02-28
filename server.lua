-- Simple ComputerCraft HTTP Server (Lua)

local http = require("http")
local term = require("term")

local port = 8080 -- Change this to your desired port
local running = true

local function handleRequest(request)
  local method = request.getMethod()
  local path = request.getPath()
  local headers = request.getHeaders()
  local body = request.getBody()

  term.clear()
  term.setCursorPos(1, 1)

  print("Request received:")
  print("Method: " .. method)
  print("Path: " .. path)
  print("Headers:")
  for k, v in pairs(headers) do
    print("  " .. k .. ": " .. v)
  end
  if body then
    print("Body: " .. body)
  end

  -- Basic routing example
  local responseBody = "404 Not Found"
  local statusCode = 404
  local contentType = "text/plain"

  if path == "/" then
    responseBody = "Hello from ComputerCraft!"
    statusCode = 200
  elseif path == "/time" then
      responseBody = os.date("%c")
      statusCode = 200
  elseif path == "/data" then
      responseBody = textutils.serialize({message = "This is some data", value = 123})
      statusCode = 200
      contentType = "application/json"
  end

  local response = http.Response.new()
  response.setStatusCode(statusCode)
  response.setBody(responseBody)
  response.addHeader("Content-Type", contentType)

  return response
end

local server = http.createServer(port)

if server then
  print("Server started on port " .. port)

  while running do
    local request = server.poll()
    if request then
      local response = handleRequest(request)
      if response then
        server.send(response)
      end
    end
    os.sleep(0.01) -- Prevent CPU hogging
  end

  server.close()
  print("Server stopped.")
else
  print("Failed to start server on port " .. port)
end

-- Function to stop the server (e.g., when a key is pressed)
local function stopServer()
  running = false
end

-- Example of stopping the server when the 's' key is pressed.
local event, key = os.pullEvent("key")

if key == keys.s then
    stopServer()
end
