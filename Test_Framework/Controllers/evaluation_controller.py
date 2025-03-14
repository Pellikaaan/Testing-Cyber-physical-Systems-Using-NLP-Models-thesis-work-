#analyzes test case effectiveness, computes accuracy metrics.
import json
import difflib

class EvaluationController:
    def __init__(self, expected_results_file):
     
        with open(expected_results_file, "r") as f:
            self.expected_results = json.load(f)

    def evaluate(self, test_cases, actual_results):

        evaluation_report = {}

        for model_name, test_case in test_cases.items():
            expected_result = self.expected_results.get(model_name, "")
            actual_result = actual_results.get(model_name, "")

            accuracy_score = self.calculate_similarity(expected_result, actual_result)

            evaluation_report[model_name] = {
                "generated_test_case": test_case,
                "expected_result": expected_result,
                "actual_result": actual_result,
                "accuracy_score": accuracy_score,
            }

        return evaluation_report

    def calculate_similarity(self, expected, actual):

        return difflib.SequenceMatcher(None, expected, actual).ratio() * 100

# Example usage:
if __name__ == "__main__":
    test_cases = {
        "codegen": "Check if Bluetooth device is discoverable",
    }

    actual_results = {
        "codegen": "Check if Bluetooth is discoverable in settings",
    }

    evaluator = EvaluationController("expected_results.json")
    report = evaluator.evaluate(test_cases, actual_results)
    print(json.dumps(report, indent=2))