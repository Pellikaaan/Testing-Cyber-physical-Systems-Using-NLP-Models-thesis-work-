from mimetypes import init
from typing_extensions import Self
import torch
from transformers import AutoModelForSeq2SeqLM, AutoTokenizer

class CodeT5Model:

    def __init__(self): 
        print(" Loading CodeT5 model...")
        self.model_name = "Salesforce/codet5-large"
        self.device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
        self.model = AutoModelForSeq2SeqLM.from_pretrained(self.model_name).to(self.device)
        self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
        print(" Model loaded successfully!")

    def generate(self,prompt):
        print(f" Input prompt: {prompt}")
        inputs = self.tokenizer(prompt, return_tensors="pt").to(self.device)
        print(" Generating text... (this may take a while)")
        with torch.no_grad():
            output = self.model.generate(**inputs, max_length=100, do_sample=True, top_k=50, top_p=0.95)
        generated_text = self.tokenizer.decode(output[0], skip_special_tokens=True).strip()
        print("\n Generated Output:\n", generated_text)