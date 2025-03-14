#handles the entire test process, calls and other componenets


from mimetypes import init
import json
from nlp_model_interface import NLPModelInterface
from test_executor import TestExecutor
from evaluation_controller import EvaluationController

class TestController:
    def __init__(self, device_name, device_address):
        
        self.nlp_model = NLPModelInterface()  
        self.executor = TestExecutor(device_name, device_address)  
        self.evaluator = EvaluationController() 

    def run_tests(self, prompt):
        
        print("Generating test cases from NLP model...")
        test_cases = self.nlp_model.generate_test_cases(prompt) 
        
        if not test_cases:
            print("No test cases generated!")
            return
        
        self.executor.connect_bluetooth()  

        all_results = []
        for i, test_case in enumerate(test_cases):
            print(f"Running Test Case {i+1}: {test_case['description']}")
            result = self.executor.execute_test_case(test_case)
            all_results.append({"test_case": test_case, "result": result})

        self.executor.close_connection()

        print("Evaluating test results...")
        evaluation_report = self.evaluator.evaluate(all_results)

        
        with open("test_results.json", "w") as file:
            json.dump(evaluation_report, file, indent=2)

        print("Testing process completed! Results saved to test_results.json")

if __name__ == "__main__":
    device_name = "nRF5340_Device"
    device_address = "XX:XX:XX:XX:XX:XX"  

    controller = TestController(device_name, device_address)

    test_prompt = "Generate test cases for Bluetooth pairing failures"
    controller.run_tests(test_prompt)