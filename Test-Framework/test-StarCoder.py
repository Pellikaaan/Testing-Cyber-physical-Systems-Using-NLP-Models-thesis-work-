import sys
sys.path.append("../starcoder")  # Add the cloned repo to Python path
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from torch import autocast

print("✅ Loading model...")
model_name = "bigcode/starcoder2-3b"

# Move model to device (MPS if available, else CPU)
device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
model = AutoModelForCausalLM.from_pretrained(model_name).to(device)
tokenizer = AutoTokenizer.from_pretrained(model_name)

print("✅ Model loaded successfully!")

# Define input prompt
prompt = "def fibonacci(n):"
print(f"✅ Input prompt: {prompt}")

# Tokenize input and move to the device
inputs = tokenizer(prompt, return_tensors="pt").to(device)

print("✅ Generating text... (this may take a while)")

# Generate text with optimizations (lower max_length, no sampling)
with torch.no_grad(), autocast(device_type='mps'):
    output = model.generate(**inputs, max_length=50, do_sample=False)

# Decode and print output
generated_text = tokenizer.decode(output[0], skip_special_tokens=True)
print("\n📝 Generated Output:\n", generated_text)