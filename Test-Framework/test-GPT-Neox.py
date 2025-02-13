import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

print("✅ Loading model...")
model_name = "EleutherAI/gpt-neo-2.7b"  # Smaller GPT-NeoX model

# Load model and tokenizer
model = AutoModelForCausalLM.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

print("✅ Model loaded successfully!")

# Define input prompt
prompt = "def fibonacci(n):"
print(f"✅ Input prompt: {prompt}")

# Tokenize input
inputs = tokenizer(prompt, return_tensors="pt").to("cuda" if torch.cuda.is_available() else "cpu")

print("✅ Generating text... (this may take a while)")

# Generate text
with torch.no_grad():
    output = model.generate(**inputs, max_length=100)

# Decode and print output
generated_text = tokenizer.decode(output[0], skip_special_tokens=True)
print("\n📝 Generated Output:\n", generated_text)