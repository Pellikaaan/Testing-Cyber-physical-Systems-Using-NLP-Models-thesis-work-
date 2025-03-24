import pytest
import re

device_name = "Zephyr" #TODO check what the actual name is
stability_duration = 20
flutter_log_file = "ble_logs.txt"

class TestConnectionStability():

    def test_device_detection(self):
        
        found_device = False

        with open(flutter_log_file, "r") as log_file:
            for line in log_file:
                if f"Found: {device_name}" in line:
                    found_device = True
                    break
        
        assert found_device, f"Device '{device_name}' not found in Flutter logs."
        print(f"Device '{device_name}' detected by Flutter.")

    def test_connection_stability(self):
        device_connected = False
        connection_duration = None

        with open(flutter_log_file, "r") as log_file:
            for line in log_file:
                if f"Connected to: {device_name}" in line:
                    device_connected = True

                match = re.search(r"Connection duration: ([\d.]+) seconds", line)
                if match:
                    connection_duration = float(match.group(1))
                    print(f"Connection lasted {connection_duration} seconds.")
                    break
        
        assert device_connected, f"Flutter app did not connect to '{device_name}'."
        print(f"Connection to '{device_name}' established.")
        assert connection_duration is not None, "Connection duration not found in logs."
        assert connection_duration >= stability_duration, f"Connection dropped too soon. Connection lasted for ({connection_duration} seconds)."
        print(f"Connection remained stable for {stability_duration} seconds.")