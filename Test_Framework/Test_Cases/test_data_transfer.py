import pytest
import re

flutter_log_file = "ble_logs.txt"
device_name = "Zephyr" #TODO: Check actual device name
platforms = ["Android", "iOS"]
data_pattern = r"Data sent: (.+)" #TODO: Check if this is the expected pattern

class TestDataTransfer():

    @pytest.mark.parametrize("platform", platforms)
    def test_data_transfer_success(self, platform):
        data_sent_logged = False
        data_received_logged = False

#TODO: Check if this is how the lines of data will look, also might need to add lines into send data file for being printed in the log textfile
        with open(flutter_log_file, "r") as log_file:
            for line in log_file:
                if f"[{platform}]" in line:
                    if "Data sent:" in line:
                        data_sent_logged = True
                        print(f"{platform}: Found log for data sent: {line.strip()}")

                    if "Data received by device:" in line:
                        data_received_logged = True
                        print(f"{platform}: Found log for data received: {line.strip()}")

        assert data_sent_logged, f"{platform}: No log found for data being sent from Flutter."
        assert data_received_logged, f"{platform}: No log found for data being received by nRF5340."