app = require "app"
BrowserWindow = require "browser-window"
require "crash-reporter"
    .start()

# Keep a reference of the window object so that the window won't be closed automatically when the object is GC'd.
appWindow = null

# Quit when all windows are closed.
app.on "window-all-closed", ->
    # On OS X it is common for applications and their menu bar to stay active until the user quits explicitly
    # with Cmd + Q
    app.quit() if process.platform != "darwin"

app.on "ready", ->
    appWindow = new BrowserWindow
        width: 800
        height: 600

    appWindow.loadUrl "file://#{__dirname}/index.html"
    appWindow.openDevTools();

    appWindow.on "closed", ->
        appWindow = null
