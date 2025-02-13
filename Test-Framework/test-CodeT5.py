import torch
from transformers import AutoModelForSeq2SeqLM, AutoTokenizer

print("✅ Loading CodeT5 model...")
model_name = "Salesforce/codet5-large"

device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")

model = AutoModelForSeq2SeqLM.from_pretrained(model_name).to(device)
tokenizer = AutoTokenizer.from_pretrained(model_name)

print("✅ Model loaded successfully!")

prompt = "def fibonacci(n):\n    \"\"\"Compute the nth Fibonacci number.\"\"\"\n"
print(f"✅ Input prompt: {prompt}")

inputs = tokenizer(prompt, return_tensors="pt").to(device)

print("✅ Generating text... (this may take a while)")
with torch.no_grad():
    output = model.generate(**inputs, max_length=100, do_sample=True, top_k=50, top_p=0.95)

generated_text = tokenizer.decode(output[0], skip_special_tokens=True).strip()
print("\n📝 Generated Output:\n", generated_text)