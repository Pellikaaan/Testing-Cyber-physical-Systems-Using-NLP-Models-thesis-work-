import pytest

flutter_log_file = "ble_log.txt"
platforms = ["Android", "iOS"]

class TestNoBluetooth:
    
    @pytest.mark.parametrize("platform", platforms)
    def test_bluetooth_unavailable_detected(self, platform):
        bluetooth_off_detected = False

        with open(flutter_log_file, "r") as log_file:
            for line in log_file:
                if f"[{platform}] Bluetooth is OFF or unavailable" in line:
                    bluetooth_off_detected = True
                    print(f"{platform}: Bluetooth is unavailable logged.")
                    break

        assert bluetooth_off_detected, f"{platform}: App did not detect Bluetooth unavailability correctly."