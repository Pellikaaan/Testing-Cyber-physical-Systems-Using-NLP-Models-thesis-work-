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
            output = self.model.generate(**inputs, max_length=50, do_sample=False)
        generated_text = self.tokenizer.decode(output[0], skip_special_tokens=True)
        print("\n Generated Output:\n", generated_text)