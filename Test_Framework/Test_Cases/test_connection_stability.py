import pytest
import time

device_name = "Zephyr" #TODO check what the actual name is
stability_duration = 20
flutter_log_file = "ble_logs.txt"

class TestConnectionStability():

    def test_device_detection():
        found_device = False

        with open(flutter_log_file, "r") as log_file:
            for line in log_file.readlines():
                if f"[Found: {device_name}" in line:
                    found_device = True
                    break
        
        assert found_device, f"Device '{device_name}' not found in Flutter logs."
        print(f"Device '{device_name}' detected by Flutter.")

    def test_connection_stability():
        device_connected = False
        connection_stable = False

        with open(flutter_log_file, "r") as log_file:
            for line in log_file.readlines():
                if f"Connected to: {device_name}" in line:
                    device_connected = True
                    break

        assert device_connected, f"Flutter app did not connect to '{device_connected}'."
        print(f"Connection to '{device_name}' established.")

        start_time = None
        for line in log_file.readlines:
            if "Connected to" in line:
               start_time = time.time()
            if "Disconnected" in line:
                if start_time and (time.time() - start_time) >= stability_duration:
                    stable = True
                    break

        assert stable, f"Connection to '{device_name}' dropped before {stability_duration} seconds."
        print(f"Connection to '{device_name}' remained stable for {stability_duration} seconds.")