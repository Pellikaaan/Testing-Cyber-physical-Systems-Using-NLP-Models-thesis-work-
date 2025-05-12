## Testing-Cyber-physical-Systems-Using-NLP-Models-thesis-work-
Thesis work 2025

This thesis investigates the feasibility of using Natural Language Processing (NLP) models for automating test generation in Flutter applications that utilize Bluetooth (BLE) communication, particularly in the context of Cyber-Physical Systems (CPS).

The core idea is to evaluate how well open-source NLP code-generation models can generate test cases — including edge cases — compared to manually written ones.

## Objectives of this thesis
•	Evaluate the ability of NLP models to generate E2E and integration tests for Bluetooth-enabled Flutter apps.
•	Identify strengths, limitations, and key performance differences among selected models.
•	Explore edge case coverage (e.g., unstable Bluetooth connections, device compatibility).

## Prerequisites and Tools

Flutter + flutter_blue_plus
nRF5340 (BLE hardware)
Python with transformers and torch

### NLP Models:
•	StarCoder
•	CodeGen
•	GPT-NeoX
•	CodeT5

### Evaluation Metrics:
•	Syntactically Incorrect (SI)
•	Functionally Incorrect (FI)
•	Functionally Correct (FC)
•	Test coverage & execution success rate

## Experimental setup

### Flutter App
A minimal app with BLE scanning, connection, and data transmission features. Used as the base for generating test cases.

### BLE Hardware
Used nRF5340 and Nordic’s peripheral_uart sample flashed using the west tool.

### NLP Test Framework
Python-based framework to:
	•	Load and run NLP models
	•	Generate Dart test code based on prompts
	•	Categorize results into SI, FI, or FC
	•	Compare model-generated tests to manually written baselines

## How to start
Prerequisites
	•	Python 3.9+
	•	Flutter SDK
	•	BLE-compatible Android/iOS device
	•	nRF5340 board
	•	flutter_blue_plus installed in your Flutter app

## Clone and Install
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
pip install -r requirements.txt

## Using the Models
Run a Prompt with a Model:
Alter the value of the variable "prompt", for example
    prompt = "This is my test prompt"

## Flash and configure the hardware
Make sure to have the nrf folder downloaded through the Zephyr pack and navigate to the peripheral_uart, when downloaded correctly, the path should be like this: nrf/samples/bluetooth/peripheral_uart

in our case we used the nRF5340 board as a hardware device, example build:
west build -b nrf5340dk/nrf5340/cpuapp --pristine
west flash

to use a different nordic semiconductor board, please look at https://www.nordicsemi.com/Products/Wireless/Bluetooth-Low-Energy to find you hardware device and board-specific configurations 

# Repository structure 

	flutter_app/ – Flutter BLE application
	
    nrf/ – Nordic SDK sample (peripheral_uart)
	
    Test_Framework/
    NLP_models/ – NLP test framework
    • test_CodeGen.py 
    • test_CodeT5.py 
    • test_GPT_Neox.py 
    • test_StarCoder.py 
    requirements.txt – Python dependencies
	
    README.md – Project documentation (this file)             

## How to reproduce results
How to Reproduce Results
	1.	Use predefined prompts from excel sheet.
	2.	Generate code with each model using the framework scripts.
	3.	Copy generated test files into the Flutter integration test file "test.dart", located: app/integration_test.
	4.	Run tests using Flutter’s integration test tools.
	5.	Log execution results and label SI/FI/FC.
	6.	Compare with manually written tests for accuracy.

## Limitations
	Only small model variants (2–3B parameters) used due to hardware constraints.
	
    BLE testing was limited to a specific setup using nRF5340.

	Models struggled with complex prompt interpretation and edge case handling.