import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Basic

import QtWebSockets 1.0

Window {
    visible: true
    width: 800
    height: 600
    title: qsTr("Virtual Sensors and Actuators")
    color: "#121212"    // Dark background

    // Sensor Properties
    property string lightSensor: "Very Dark"
    property int temperatureSensor: 0
    property string motionSensor: "Not Detected"

    // Actuator Properties
    property bool lampState: false
    property bool curtainState: false
    property string coolerState: "Off"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            // Sensors Column
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                spacing: 20

                // Header
                Rectangle {
                    Layout.fillWidth: true
                    height: 50
                    color: "#1F1F1F"
                    radius: 10
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Sensors")
                        font.pixelSize: 24
                        font.bold: true
                        color: "#FFFFFF"
                    }
                }

                // Light Sensor Display
                Rectangle {
                    Layout.fillWidth: true
                    height: 120
                    radius: 10
                    color: "#1E1E1E"
                    border.color: "#333333"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        // Light Sensor Indicator
                        Rectangle {
                            width: 70
                            height: 70
                            radius: 35
                            color: "#FFC107"
                            opacity: getLightOpacity(lightSensor)
                            Behavior on opacity {
                                NumberAnimation { duration: 500 }
                            }
                        }

                        ColumnLayout {
                            spacing: 5
                            Text {
                                text: qsTr("Light Sensor")
                                font.pixelSize: 20
                                font.bold: true
                                color: "#FFFFFF"
                            }
                            Text {
                                text: lightSensor
                                font.pixelSize: 18
                                color: "#CCCCCC"
                            }
                        }
                    }
                }

                // Temperature Sensor Display
                Rectangle {
                    Layout.fillWidth: true
                    height: 120
                    radius: 10
                    color: "#1E1E1E"
                    border.color: "#333333"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        // Temperature Gauge
                        Rectangle {
                            width: 30
                            height: 70
                            radius: 5
                            color: "#333333"

                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: parent.height * (temperatureSensor / 30)
                                radius: 5
                                color: "#F44336"
                            }
                        }

                        ColumnLayout {
                            spacing: 5
                            Text {
                                text: qsTr("Temperature Sensor")
                                font.pixelSize: 20
                                font.bold: true
                                color: "#FFFFFF"
                            }
                            Text {
                                text: temperatureSensor + " °C"
                                font.pixelSize: 18
                                color: "#CCCCCC"
                            }
                        }
                    }
                }

                // Motion Sensor Display
                Rectangle {
                    Layout.fillWidth: true
                    height: 120
                    radius: 10
                    color: "#1E1E1E"
                    border.color: "#333333"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        // Motion Indicator
                        Rectangle {
                            width: 70
                            height: 70
                            radius: 35
                            color: motionSensor === "Detected" ? "#4CAF50" : "#555555"

                            // Pulsing effect when motion is detected
                            SequentialAnimation on scale {
                                loops: Animation.Infinite
                                running: motionSensor === "Detected"
                                NumberAnimation { to: 1.2; duration: 500; easing.type: Easing.InOutQuad }
                                NumberAnimation { to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
                            }
                        }

                        ColumnLayout {
                            spacing: 5
                            Text {
                                text: qsTr("Motion Sensor")
                                font.pixelSize: 20
                                font.bold: true
                                color: "#FFFFFF"
                            }
                            Text {
                                text: motionSensor
                                font.pixelSize: 18
                                color: "#CCCCCC"
                            }
                        }
                    }
                }
            }

            // Actuators Column
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                spacing: 20

                // Header
                Rectangle {
                    Layout.fillWidth: true
                    height: 50
                    color: "#1F1F1F"
                    radius: 10
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Actuators")
                        font.pixelSize: 24
                        font.bold: true
                        color: "#FFFFFF"
                    }
                }

                // Lamp Actuator
                Rectangle {
                    Layout.fillWidth: true
                    height: 120
                    radius: 10
                    color: "#1E1E1E"
                    border.color: "#333333"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        // Lamp Icon
                        Rectangle {
                            width: 70
                            height: 70
                            radius: 35
                            color: lampState ? "#FFD54F" : "#555555"
                        }

                        Text {
                            text: qsTr("Lamp")
                            font.pixelSize: 20
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        Item { Layout.fillWidth: true }

                        // Toggle Switch for Lamp
                        Switch {
                            checked: lampState
                            onCheckedChanged: lampState = checked
                        }
                    }
                }

                // Electric Curtain Actuator
                Rectangle {
                    Layout.fillWidth: true
                    height: 120
                    radius: 10
                    color: "#1E1E1E"
                    border.color: "#333333"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        // Curtain Icon
                        Rectangle {
                            width: 70
                            height: 70
                            radius: 35
                            color: curtainState ? "#8BC34A" : "#555555"
                        }

                        Text {
                            text: qsTr("Electric Curtain")
                            font.pixelSize: 20
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        Item { Layout.fillWidth: true }

                        // Toggle Switch for Curtain
                        Switch {
                            checked: curtainState
                            onCheckedChanged: curtainState = checked
                        }
                    }
                }

                // Swamp Cooler Actuator
                Rectangle {
                    Layout.fillWidth: true
                    height: 120
                    radius: 10
                    color: "#1E1E1E"
                    border.color: "#333333"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        RowLayout {
                            spacing: 10

                            // Cooler Icon
                            Rectangle {
                                width: 50
                                height: 50
                                radius: 25
                                color: "#2196F3"
                            }

                            Text {
                                text: qsTr("Swamp Cooler")
                                font.pixelSize: 20
                                font.bold: true
                                color: "#FFFFFF"
                            }
                        }

                        ComboBox {
                            id: control
                            Layout.fillWidth: true
                            model: ["Off", "Low Speed", "Medium Speed", "High Speed"]

                            background: Rectangle {
                                color: "#2E2E2E"
                                radius: 5
                                border.color: "#444444"
                                border.width: 1
                            }

                            contentItem: Text {
                                text: control.currentText
                                font.pixelSize: 16
                                verticalAlignment: Text.AlignVCenter
                                color: "#FFFFFF"
                                padding: 10
                            }

                            onCurrentIndexChanged: coolerState = model[currentIndex]
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            Button {
                text: qsTr("Send Data to Server")
                width: 300 // Increase the width as desired
                height: 50
                font.pixelSize: 18
                background: Rectangle {
                    color: "#6200EE"
                    radius: 25
                    anchors.fill: parent
                }
                onClicked: {
                    sendDataToServer()
                }
            }
        }
    }

    // Timer to simulate sensor data updates
    Timer {
        interval: 4000   // Update every 1 second
        running: true
        repeat: true
        onTriggered: {
            // Simulate Light Sensor values
            var lightLevels = ["Very Dark", "Dark", "Medium", "Bright", "Very Bright"];
            var randomIndex = Math.floor(Math.random() * lightLevels.length);
            lightSensor = lightLevels[randomIndex];

            // Simulate Temperature Sensor values
            temperatureSensor = Math.floor(Math.random() * 31);

            // Simulate Motion Detection Sensor values
            motionSensor = (Math.random() < 0.5) ? "Not Detected" : "Detected";
        }
    }

    // Function to get opacity for light sensor indicator based on the light level
    function getLightOpacity(lightLevel) {
        switch (lightLevel) {
        case "Very Dark":
            return 0.2;
        case "Dark":
            return 0.4;
        case "Medium":
            return 0.6;
        case "Bright":
            return 0.8;
        case "Very Bright":
            return 1.0;
        default:
            return 0.2;
        }
    }

    // Function to send data to the server
    function sendDataToServer() {
        // Create a new XMLHttpRequest
        var xhr = new XMLHttpRequest();
        var url = "http://localhost:8080";  // Replace with your server URL
        xhr.open("POST", url);
        xhr.setRequestHeader("Content-Type", "application/json");

        // Prepare data to send
        var data = {
            "lightSensor": lightSensor,
            "temperatureSensor": temperatureSensor,
            "motionSensor": motionSensor,
            "lampState": lampState ? "On" : "Off",
            "curtainState": curtainState ? "Open" : "Closed",
            "coolerState": coolerState
        };

        // Send the request with JSON data
        xhr.send(JSON.stringify(data));

        // Handle the response
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    console.log("POST request successful: " + xhr.responseText);
                } else {
                    console.log("Error in POST request: " + xhr.status);
                }
            }
        };
    }
}


WebSocket {
    id: webSocket
    url: "ws://localhost:8000/ws/data/"  // Replace with your server’s address
    onStatusChanged: {
        if (status === WebSocket.Open) {
            console.log("Connected to WebSocket server");
        }
    }

    onMessageReceived: function(message) {
        var data = JSON.parse(message.data);
        updateUIWithData(data);  // Update your QML UI with the received data
    }
}

function updateUIWithData(data) {
    // Use the data to update QML properties or UI elements
    lightSensor = data.lightSensor;
    temperatureSensor = data.temperatureSensor;
    motionSensor = data.motionSensor;
    lampState = data.lampState === "On";
    curtainState = data.curtainState === "Open";
    coolerState = data.coolerState;
}
