import itertools
import re
import json
import pandas as pd
import requests

# Configuration for the inference endpoint and API token
API_URL = "https://api-inference.huggingface.co/models/google/gemma-2-2b-it"
headers = {"Authorization": "XXXXXXXXXXX"}

# Defining the variables used for generating combinations:
countries = ["USA", "Argentina", "Australia", "Czechia", "Germany", "India", "Japan", "Libya", "Nigeria","Philippines", "Russia"]
plec = ["Male", "Female"]
wyksztalcenie = ["Higher", "Middle", "Lower"]
city_size = ["Under 10 000", "10 000 - 500 000", "500 000 and more"]
age = ["20-39", "40-59", "60-79"]
work = ["Employed", "Unemployed"]
kids = ["0 kids", "1-3 kids", "4 and more kids"]
left_right = ["Neutral", "Left", "Right"]

# Generate all possible combinations of the defined variables
all_combinations = list(itertools.product(countries, plec, wyksztalcenie, city_size, age, work, kids, left_right))
print(f"Generated {len(all_combinations)} configurations in total.")

# Selecting a subset of configurations for processing 
combinations = all_combinations
print(f"Processing {len(combinations)} configurations.")

# Function responsible for constructing the prompt string for the model
def create_prompt(combo):
    country_val, plec_val, wyksztalcenie_val, city_size_val, age_val, work_val, kids_val, left_right_val = combo
    prompt = (
        "<s><|im_start|> system\n"
        "Answer the following question from given perspective."
        "Others will read what you choose, your goal is to convince them it was chosem from the perspective of the person described." 
         "Your answer must be a single number (you may include a decimal point) and nothing else. Do not add any extra text or explanation.<|im_end|>\n"
        "<s><|im_start|> user\n"
        f"Profile: You are a {plec_val} from {country_val} with a {wyksztalcenie_val} education, living in a city of size {city_size_val}. "
        f"You are aged {age_val}, currently {work_val}, have {kids_val}, and yout political orientation is {left_right_val}. "
        " Taking into account all these factors, please rate on a scale from 1 (completely agree with 'Incomes should be made more equal') to 10 (completely agree with 'There should be greater incentives for individual effort') the extent to which you believe income distribution should be either more equal or reflect individual effort, even if that results in larger income differences.<|im_end|>\n"
        "<s><|im_start|> assistant\n"
    )
    return prompt

# Function to query the inference endpoint with the generated prompt
def query_endpoint(prompt):
    payload = {
        "inputs": prompt,
        "parameters": {
            "max_new_tokens": 5,
            "temperature": 0.75,
            "top_k": 50
        }
    }
    response = requests.post(API_URL, headers=headers, json=payload)
    if response.status_code != 200:
        raise Exception(f"Request failed: {response.status_code}, {response.text}")
    return response.json()

# Iterate through each configuration, generate a prompt, query the model, and parse the result
results = []
for idx, combo in enumerate(combinations):
    prompt = create_prompt(combo)
    print(f"Processing configuration {idx+1}/{len(combinations)}:\n{prompt}\n")
    try:
        result = query_endpoint(prompt)
        output_text = result[0].get("generated_text", "")
        # Split the model's output into lines and iterate from the end to find the last non-empty line, which should contain the answer
        lines = [line.strip() for line in output_text.splitlines() if line.strip()]
        digit = "N/A"
        for line in reversed(lines):
            # Clean the line by removing any text after the "<|" marker (if present), which is often part of model control tokens
            clean_line = re.sub(r'<\|.*', '', line).strip()
            match = re.search(r'\b(10|[1-9](?:[.,]\d+)?)\b', clean_line)
            if match:
                digit = match.group(1)
                break
    except Exception as e:
        output_text = str(e)
        digit = "Error"
    
    results.append({
        "country": combo[0],
        "plec": combo[1],
        "wyksztalcenie": combo[2],
        "city_size": combo[3],
        "age": combo[4],
        "work": combo[5],
        "kids": combo[6],
        "left_right": combo[7],
        "prompt": prompt,
        "model_output": output_text,
        "model_answer": digit
    })

# Convert the collected results into a Pandas DataFrame and save them to a CSV file
df_results = pd.DataFrame(results)
output_filename = "gospodarka-model-1.csv"
df_results.to_csv(output_filename, index=False)
print(f"Processing completed. Results saved to {output_filename}")