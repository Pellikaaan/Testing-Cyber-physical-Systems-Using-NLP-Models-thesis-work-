import torch
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

class CodeT5Large:
    def __init__(self):
        print("Loading CodeT5-large model...")
        self.model_name = "Salesforce/codet5-large"
        self.device = torch.device("mps" if torch.backends.mps.is_available()
                                   else "cuda" if torch.cuda.is_available()
                                   else "cpu")

        self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
        self.model = AutoModelForSeq2SeqLM.from_pretrained(self.model_name).to(self.device)
        print("Model loaded successfully!")

    def generate(self, prompt, max_new_tokens=128):
        print(f"\nInput prompt:\n{prompt}\n")
        inputs = self.tokenizer(prompt, return_tensors="pt", truncation=True).to(self.device)

        with torch.no_grad():
            output_ids = self.model.generate(
                input_ids=inputs["input_ids"],
                attention_mask=inputs["attention_mask"],
                max_new_tokens=max_new_tokens,
                do_sample=True,
                temperature=0.7,
                top_k=50,
                top_p=0.95,
                pad_token_id=self.tokenizer.eos_token_id
            )

        generated = self.tokenizer.decode(output_ids[0], skip_special_tokens=True)
        print("\nGenerated output:\n", generated)
        return generated


if __name__ == "__main__":
    model = CodeT5Large()

    prompt = (
        "I’m building a Flutter (dart) integration test for a scenario where Bluetooth is turned off before launching the app. Using flutter_blue_plus, write a test that verifies FlutterBluePlus.adapterState reflects BluetoothAdapterState.off. Disable Bluetooth manually, start the app (app.main()), check that UI components like ‘enable_BT_button’ are shown and properly handled. Ensure the app disables scanning or connection buttons accordingly. Include expect() checks and use pumpAndSettle(). "
    )

    print("Generating code for prompt:")
    print(prompt)
    print("-" * 40)
    model.generate(prompt)