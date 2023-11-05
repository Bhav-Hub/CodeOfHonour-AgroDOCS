import pandas as pd
from flask import Flask, jsonify, request

import pandas as pd
from flask import Flask, jsonify

app = Flask(__name__)

# Load the dataset
df = pd.read_csv('/Users/Jay/Documents/CoH/Pythonfiles/PlantDiseaseInfo-final.csv')

# Read the predictions file and store the content in a list
with open('/Users/Jay/Documents/CoH/Pythonfiles/prediction.txt') as f:
    predictions = [line.strip() for line in f.readlines()]

# Define the route to return treatments for all predictions
@app.route('/data', methods=['GET'])
def get_all_treatments():
    treatments_info = {}

    for predict in predictions:
        # Function to check if the input is in the dataset
        def model_input(inputM):
            if inputM in list(df['Disease Name']):
                return inputM
            else:
                return None  # Return None if not found

        # Function to get the disease information
        def disease_info(predict):
            disease_name = model_input(predict)
            if disease_name is not None:
                treatments = df[df['Disease Name'] == disease_name].iloc[0]
                return {
                    'Type': treatments['Type'],
                    'Treatment1': treatments['Treatment 1'],
                    'Treatment2': treatments['Treatment 2'],
                    'Treatment3': treatments['Treatment3']
                }
            else:
                return None  # Return None if disease name not found

        # Get the treatment details and add to the dictionary
        treatment_info = disease_info(predict)
        if treatment_info:
            treatments_info[predict] = treatment_info
        else:
            treatments_info[predict] = 'Disease Name not found in the dataset.'

    # Return the response as JSON
    return jsonify(treatments_info)

if __name__ == '__main__':
    app.run(host='192.168.0.148',debug=True, port=4000)
