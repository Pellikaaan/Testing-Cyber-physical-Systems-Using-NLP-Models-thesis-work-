#calls nlp models, processes test prompts, returns test cases
from email.mime import application
from test_CodeGen import CodeGenModel
from test_CodeT5 import CodeT5Model
from test_StarCoder import StarCoderModel
from test_GPT_Neox import GPT_NEOX_Model
import json

class NLP_Model_Class: 
    def __init__(self):
        self.models = {
            "CodeGen" : CodeGenModel(),
            "GPT-Neox" : GPT_NEOX_Model(),
            "StarCoder" : StarCoderModel(),
            "CodeT5" : CodeT5Model()
        }
    
    def generate_test_case(self,prompt):
        test_cases = {}
        for model_name, model in self.models.items():
            test_cases[model_name] = model.generate(prompt)
        
        return test_cases

        