@ECHO OFF

start "" node tts-bridge/using-nodejs/tts-bridge.js
start "" node preprocessor/main/preprocessor.js
start "" node db-connector/main/db-connector.js
