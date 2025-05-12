import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from torch.cuda.amp import autocast  # Mixed precision

class GPT_NEOX_Model:
    def __init__(self):
        print("Loading model...")
        self.model_name = "EleutherAI/gpt-neo-2.7b"
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        
        self.model = AutoModelForCausalLM.from_pretrained(self.model_name).to(self.device)
        self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
        print("Model loaded successfully!")

    def generate(self, prompt):
        inputs = self.tokenizer(prompt, return_tensors="pt").to(self.device)
        
        print("Generating text... (this may take a while)")
        
        with torch.amp.autocast('cpu',  torch.bfloat16):  # Enable mixed precision
            output = self.model.generate(
                **inputs,
                max_new_tokens=500,
                do_sample=True,
                temperature=0.7,
                top_k=50,
                top_p=0.95,
                pad_token_id=self.tokenizer.eos_token_id,
            )
        
        generated_text = self.tokenizer.decode(output[0], skip_special_tokens=True)
        print("\nGenerated Output:\n", generated_text)

if __name__ == "__main__":
    model = GPT_NEOX_Model()
    prompt = "I’m building a Flutter integration test for my BLE data communication flow. The app uses flutter_blue_plus, and after navigating to the device screen using a test helper, I tap the connect_button to establish a BLE connection. Once connected, I tap the send_data_key button to transmit a message over BLE. The app listens to characteristic notifications, and when a response is received, it opens an AlertDialog with the title Data Received and the received message (e.g., Test Messagesss). Write a complete test using testWidgets (no wrapping in helpers) that launches the app with app.main(), ensures the buttons exist before interacting with them, and verifies that the dialog appears with the correct content. Explain how BLE characteristic notifications are handled and how such asynchronous updates are verified in integration tests. Also mention how platform-specific issues like notification delays or UI blocking might affect timing in Flutter’s test environment."
    print("Generating code for prompt:")
    print(prompt)
    print("-" * 40)
    model.generate(prompt)