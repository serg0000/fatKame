#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <Servo.h>
#include "octosnake.h"
#include "minikame.h"
#include "sensoreyes.h"
#include "webconnector.h"
#include "commandexecutor.h"

MiniKame robot;
SensorEyes eyes;
WebConnector connector;
CommandExecutor executor;

void setup() {
  Serial.begin(115200);
  delay(1000);
  connector.init();
  robot.init();
  eyes.init();
  executor.init(&robot);
}

void loop() {
  // if there is a connection waiting, process it
  connector.handleConnection();
  // get the active command
  String activeCommand = connector.getActiveCommand();
  // check if we still have room before us
  //eyes.measureDistance();
  // execute the active command, which calls the robot
  executor.parseCommand(activeCommand);
}
