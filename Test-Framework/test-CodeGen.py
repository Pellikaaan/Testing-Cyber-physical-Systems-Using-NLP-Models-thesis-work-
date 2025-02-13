
from transformers import AutoModelForCausalLM, AutoTokenizer

model_name = "Salesforce/codegen-2B-nl"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)

input_text = "def quicksort(arr):"
inputs = tokenizer(input_text, return_tensors="pt")

output = model.generate(**inputs, max_length=100)
generated_text = tokenizer.decode(output[0], skip_special_tokens=True)
print(generated_text)