import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

class GPT_NEOX_Model:

    def __init__(self):
        print("Loading model...")
        self.model_name = "EleutherAI/gpt-neo-2.7b"
        self.model = AutoModelForCausalLM.from_pretrained(self.model_name)
        self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
        print("Model loaded successfully!")

    def generate(self,prompt):
        inputs = self.tokenizer(prompt, return_tensors="pt").to("cuda" if torch.cuda.is_available() else "cpu")
        print("Generating text... (this may take a while)")
        with torch.no_grad():
            output = self.model.generate(**inputs, max_length=100)
        generated_text = self.tokenizer.decode(output[0], skip_special_tokens=True)
        print("\n Generated Output:\n", generated_text)