#include "webconnector.h"

const char* ssid = "MINIKAME";
const char* password = "asdf";
WiFiServer server(80);
String webPage = "";

void WebConnector::init() {
  WiFi.mode(WIFI_AP);
  WiFi.softAP(ssid, password);
  server.begin();
  activeCommand = 12;
}

void WebConnector::handleConnection() {
  WiFiClient client = server.available();
  while (client.connected()||client.available()) {
    if (client.available()) {
        input = client.readStringUntil('\n');
        if (input.startsWith("GET")) {
          // this is our get request, check if we have a parameter
          int commandPosition = input.indexOf("?command=");
          if (commandPosition > -1) {
            // a command, how exciting.
            activeCommand = input.substring(commandPosition+9, commandPosition+11);
            Serial.println("The active command is: " + activeCommand);
            client.println("HTTP/1.1 200 OK");
            client.println("Content-Type: text/html");
            client.println("Connection: close");
            client.println();
            client.println("<!DOCTYPE HTML><html></html>");
            client.stop();
          } else {
            // give back the ajax page with commands
            client.println("HTTP/1.1 200 OK");
            client.println("Content-Type: text/html");
            client.println("Connection: close");
            client.println();
            
            //web page construct
            webPage += "<!DOCTYPE HTML><!doctype html> <html> <head> <meta charset=\"utf-8\"> ";
            webPage += "<title>Mini Kame</title>";
            webPage += "<style> div { width: 100%; height: 400px; } div div { width: 33%; height: 33%; outline: 1px solid; float: left; font-size: 24px; color: white; text-align: center; line-height: 500%; } .cB { background-color: blue; } .cBStop { background-color: red; } .cBDir { background-color: orange; } </style> ";
            webPage += "<script type=\"text/javascript\"> function fireCommand(value) { document.getElementById(value).style.background = \"black\"; var xhttp = new XMLHttpRequest(); xhttp.onreadystatechange = function() { if (xhttp.readyState == 4) { document.getElementById(value).style.background = ''; }}; xhttp.open(\"GET\", \"cmd.html?command=\"+value, true); xhttp.send(); } </script> ";
            webPage += "</head> ";
            webPage += "<body> <div> ";
            webPage += "<div class=\"cB\" id=\"06\" onclick=\"fireCommand('06')\" >Heart</div> ";
            webPage += "<div class=\"cBDir\" id=\"01\" onclick=\"fireCommand('01')\">Walk</div> ";
            webPage += "<div class=\"cB\" id=\"07\" onclick=\"fireCommand('07')\">Fire</div> ";
            webPage += "<div class=\"cBDir\" id=\"03\" onclick=\"fireCommand('03')\">Left</div> ";
            webPage += "<div class=\"cBStop\" id=\"05\" onclick=\"fireCommand('05')\">Stop</div> ";
            webPage += "<div class=\"cBDir\" id=\"04\" onclick=\"fireCommand('04')\">Right</div> ";
            webPage += "<div class=\"cB\" id=\"09\" onclick=\"fireCommand('09')\">Cross</div> ";
            webPage += "<div class=\"cBDir\" id=\"10\" onclick=\"fireCommand('10')\">Back</div> ";
            webPage += "<div class=\"cB\" id=\"08\" onclick=\"fireCommand('08')\">Jump</div> ";
            webPage += "<div class=\"cB\" id=\"11\" onclick=\"fireCommand('11')\">Dance</div> ";
            webPage += "<div class=\"cB\" id=\"12\" onclick=\"fireCommand('12')\">Fetch</div> ";
            webPage += "<div class=\"cB\" id=\"13\" onclick=\"fireCommand('13')\">Auto</div> ";
            webPage += "</div> </body> </html>";

            client.println(webPage);
            client.stop();
          }
        }      
    }
  }
}

String WebConnector::getActiveCommand() {
  return activeCommand;
}
