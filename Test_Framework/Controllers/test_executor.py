#runs generated test cases on board and flutter app via bluetoothimport bluetooth
import json
import time
import bluetooth 

class TestExecutor:
    def __init__(self, device_name, device_address):
        self.device_name = device_name
        self.device_address = device_address
        self.socket = None

    def connect_bluetooth(self):
       
        try:
            self.socket = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
            self.socket.connect((self.device_address, 1))
            print(f"Connected to {self.device_name}")
        except Exception as e:
            print(f"Bluetooth Connection Failed: {e}")

    def execute_test_case(self, test_case):
  
        results = []
        print(f"Running Test Case: {test_case}")

        for step in test_case["test_steps"]:
            print(f"> Executing: {step}")
            try:
                self.socket.send(step.encode("utf-8"))
                time.sleep(2)
                response = self.socket.recv(1024).decode("utf-8")
                print(f"Response: {response}")
                results.append({"step": step, "response": response})
            except Exception as e:
                print(f"Failed: {e}")
                results.append({"step": step, "response": "ERROR"})

        return results

    def close_connection(self):
        
        if self.socket:
            self.socket.close()
            print("Bluetooth Connection Closed")

# Example usage
if __name__ == "__main__":
    device_name = "nRF5340_Device"
    device_address = "XX:XX:XX:XX:XX:XX" 

    executor = TestExecutor(device_name, device_address)
    executor.connect_bluetooth()

    # Example Test Case
    test_case = {
        "test_steps": [
            "Turn on Bluetooth",
            "Pair with nRF5340",
            "Send data packet",
            "Check connection status"
        ]
    }
    
    results = executor.execute_test_case(test_case)
    print(json.dumps(results, indent=2))
    
    executor.close_connection()