
from transformers import AutoModelForCausalLM, AutoTokenizer

class CodeGenModel:
    
    def __init__(self):
        self.model_name = "Salesforce/codegen-2B-nl"
        self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
        self.model = AutoModelForCausalLM.from_pretrained(self.model_name)

    def generate(self,prompt):
        inputs = self.tokenizer(prompt, return_tensors="pt")
        output = self.model.generate(**inputs, max_length=100)
        generated_text = self.tokenizer.decode(output[0], skip_special_tokens=True)
        print(generated_text)
        return(generated_text)