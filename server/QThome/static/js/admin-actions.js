document.addEventListener('DOMContentLoaded', function() {
    // WebSocket setup for real-time data updates
    const socket = new WebSocket('ws://localhost:8000/ws/data');

    socket.onmessage = function(event) {
        const data = JSON.parse(event.data);
        updateIndicators(data);

        // Update sensors
        if (data.lightSensor !== undefined) {
            document.getElementById('light-sensor-value').textContent = data.lightSensor;
            document.getElementById('light-indicator').style.opacity = getLightOpacity(data.lightSensor);
        }
        if (data.temperatureSensor !== undefined) {
            document.getElementById('temperature-sensor-value').textContent = data.temperatureSensor + " °C";
            document.getElementById('temperature-fill').style.height = (data.temperatureSensor / 30 * 100) + '%';
        }
        if (data.motionSensor !== undefined) {
            document.getElementById('motion-sensor-value').textContent = data.motionSensor;
            document.getElementById('motion-indicator').style.backgroundColor = data.motionSensor === 'Detected' ? '#4CAF50' : '#555555';
        }
    };

    socket.onopen = function() {
        console.log("WebSocket connection opened");
    };

    socket.onclose = function() {
        console.log("WebSocket connection closed");
    };

    function getLightOpacity(lightSensor) {
        switch (lightSensor) {
            case 'Very Dark':
                return 0.2;
            case 'Dark':
                return 0.4;
            case 'Normal':
                return 0.6;
            case 'Bright':
                return 0.8;
            case 'Very Bright':
                return 1.0;
            default:
                return 0.5;
        }
    }

    function updateIndicators(data) {
        if (data.lampState !== undefined) {
            document.getElementById('lamp-indicator').style.backgroundColor = data.lampState === 'On' ? '#FFD54F' : '#555555';
        }
        if (data.curtainState !== undefined) {
            document.getElementById('curtain-indicator').style.backgroundColor = data.curtainState === 'Open' ? '#8BC34A' : '#555555';
        }
        if (data.coolerState !== undefined) {
            document.getElementById('cooler-indicator').style.backgroundColor = data.cool