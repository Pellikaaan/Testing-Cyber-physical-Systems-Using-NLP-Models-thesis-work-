from Test_Framework.Controllers.test_controller import TestController

if __name__ == "__main__":
    DEVICE_NAME = "nRF5340_Device"
    DEVICE_ADDRESS = "XX:XX:XX:XX:XX:XX"

    controller = TestController(DEVICE_NAME, DEVICE_ADDRESS)

    test_prompts = [
        "Generate test cases for Bluetooth pairing failures",
        "Generate test cases for data transmission errors",
        "Generate test cases for device reconnection"
    ]

    for prompt in test_prompts:
        print(f"\n Running tests for prompt: {prompt}")
        controller.run_tests(prompt)

    print("\n All tests completed! Check test_results.json for details.")