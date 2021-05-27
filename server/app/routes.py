from flask import render_template, flash, redirect, url_for, request
from app import app
import pandas as pd

@app.route('/csv_to_edf', methods = ['GET', 'POST'])
def handle_request():
    if request.method == 'POST':
        if request.files:

            request.files['file'].save(UPLOADS_CSV_DEST)
            data = pd.read_csv(request.files['file'])
            print(data)

            return 'Conversion Complete'
        return 'No Files Recieved'
    return 'Method not POST'

@app.route('/edf_to_csv', methods = ['GET', 'POST'])
def handle_request():
    if request.method == 'POST':
        if request.files:

            data = pd.read_csv(request.files['file'])
            print(data)

            return 'Conversion Complete'
        return 'No Files Recieved'
    return 'Method not POST'