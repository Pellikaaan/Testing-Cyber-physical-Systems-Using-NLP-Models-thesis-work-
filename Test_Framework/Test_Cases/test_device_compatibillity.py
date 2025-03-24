import pytest
import re

device_name = "Zephyr" #TODO check what the actual name is
flutter_log_file = "ble_logs.txt"
stability_duration = 20

platforms = ["Android", "iOS"]

class TestDeviceCompatability():

    @pytest.mark.parametrize("platform", platforms)
    def test_device_found(self, platform):
        found_device = False

        with open(flutter_log_file, "r") as log_file:
            for line in log_file:
                if f"[{platform}]Found: {device_name}" in line:
                    found_device = True
                    break
        
        assert found_device, f"{platform}: Device '{device_name}' not found in Flutter logs."
        print(f"{platform}: Device '{device_name}' detected by Flutter.")

    @pytest.mark.parametrize("platform", platforms)
    def test_connection_success_and_duration(self, platform):
        connection_duration = None
        device_connected = False

        with open(flutter_log_file, "r") as log_file:
            for line in log_file:
                if f"[{platform}]" in line and f"Connected to: {device_name}" in line:
                    device_connected = True

                if f"{platform}" in line:
                    match = re.search(r"Connection duration: ([\d.]+) seconds", line)
                    if match:
                        connection_duration = float(match.group(1))
                        print(f"Connection lasted {connection_duration} seconds.")
                        break
        
        assert device_connected, f"{platform}: Flutter app did not connect to '{device_name}'."
        print(f"{platform}: Connection to '{device_name}' established.")

        assert connection_duration is not None, "{platform}: Connection duration not found in logs."
        assert connection_duration >= stability_duration, f"{platform}: Connection dropped too soon. Connection lasted for ({connection_duration} seconds)."
        print(f"{platform}: Connection remained stable for {stability_duration} seconds.")