
from transformers import AutoModelForCausalLM, AutoTokenizer

class CodeGenModel:
    
    def __init__(self):
        self.model_name = "Salesforce/codegen-2B-multi"
        self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
        self.model = AutoModelForCausalLM.from_pretrained(self.model_name)

    def generate(self,prompt):
        inputs = self.tokenizer(prompt, return_tensors="pt")
        output = self.model.generate(**inputs, max_length=750)
        generated_text = self.tokenizer.decode(output[0], skip_special_tokens=True)
        print(generated_text)
        return(generated_text)

if __name__ == "__main__":
    model = CodeGenModel()


    prompt = "I’m building a Flutter integration test for my BLE data communication flow. The app uses flutter_blue_plus, and after navigating to the device screen using a test helper, I tap the connect_button to establish a BLE connection. Once connected, I tap the send_data_key button to transmit a message over BLE. The app listens to characteristic notifications, and when a response is received, it opens an AlertDialog with the title Data Received and the received message (e.g., Test Messagesss). Write a complete test using testWidgets (no wrapping in helpers) that launches the app with app.main(), ensures the buttons exist before interacting with them, and verifies that the dialog appears with the correct content. Explain how BLE characteristic notifications are handled and how such asynchronous updates are verified in integration tests. Also mention how platform-specific issues like notification delays or UI blocking might affect timing in Flutter’s test environment."


    print("Generating code for prompt:")
    print(prompt)
    print("-" * 40)

    result = model.generate(prompt)