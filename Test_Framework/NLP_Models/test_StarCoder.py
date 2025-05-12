from mimetypes import init
import sys
sys.path.append("../starcoder")  # Add the cloned repo to Python path
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from torch import autocast


class StarCoderModel:

    def __init__(self):
        print(" Loading model...")
        self.model_name = "bigcode/starcoder2-3b"
        self.device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
        self.model = AutoModelForCausalLM.from_pretrained(self.model_name).to(self.device)
        self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
        print(" Model loaded successfully!")

    def generate(self,prompt):
        inputs = self.tokenizer(prompt, return_tensors="pt").to(self.device)
        print("Generating text... (this may take a while)")
        with torch.no_grad(), autocast(device_type='mps'):
            output = self.model.generate(**inputs, max_length=500, do_sample=False)
        generated_text = self.tokenizer.decode(output[0], skip_special_tokens=True)
        print("\n Generated Output:\n", generated_text)

if __name__ == "__main__":
    model = StarCoderModel()


    prompt = "I’m building a Flutter integration test for my BLE data communication flow. The app uses flutter_blue_plus, and after navigating to the device screen using a test helper, I tap the connect_button to establish a BLE connection. Once connected, I tap the send_data_key button to transmit a message over BLE. The app listens to characteristic notifications, and when a response is received, it opens an AlertDialog with the title Data Received and the received message (e.g., Test Messagesss). Write a complete test using testWidgets (no wrapping in helpers) that launches the app with app.main(), ensures the buttons exist before interacting with them, and verifies that the dialog appears with the correct content. Explain how BLE characteristic notifications are handled and how such asynchronous updates are verified in integration tests. Also mention how platform-specific issues like notification delays or UI blocking might affect timing in Flutter’s test environment."


    print("Generating code for prompt:")
    print(prompt)
    print("-" * 40)

    result = model.generate(prompt)