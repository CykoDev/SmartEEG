from flask import Blueprint, request, render_template, flash, g, session, redirect, url_for, send_from_directory, send_file
from app import UPLOAD_DIRECTORY
import os
import numpy as np
import mne
import time

file_conversion_controller = Blueprint('conversion', __name__, url_prefix='/conversion')

@file_conversion_controller.route('/test/', methods=['GET'])
def test():
    return "boo", 200

# @file_conversion_controller.route("/edftocsv1/<filename>", methods=['POST'])
# def edf_to_csv1(filename):
    
#     # upload source file
#     if "/" in filename:
#         return "no subdirectories allowed", 400

#     with open(os.path.join(UPLOAD_DIRECTORY, filename), "wb") as fp:
#         fp.write(request.data)

#     # download converted file data
#     return send_from_directory(UPLOAD_DIRECTORY, filename, as_attachment=True), 200

@file_conversion_controller.route("/edftocsv2", methods=['POST'])
def edf_to_csv2():
    
    # data = request.data

    tmp_edf_file = f'in_{time.time()}.edf'
    with open(os.path.join(UPLOAD_DIRECTORY, tmp_edf_file), "wb") as fp:
        fp.write(request.data)

    # perform conversion
    edf = mne.io.read_raw_edf(UPLOAD_DIRECTORY + "\\" +tmp_edf_file)
    header = ','.join(edf.ch_names)
    tmp_csv_file = f'out_{time.time()}.csv'
    np.savetxt(UPLOAD_DIRECTORY+'/'+tmp_csv_file, edf.get_data().T, delimiter=',', header=header)


    # with open(UPLOAD_DIRECTORY + "/" + tmp_csv_file, 'r') as file:
    #     converted_data = file.read()

    # return send_file(UPLOAD_DIRECTORY + "/" + tmp_csv_file, as_attachment=True), 200

    return send_from_directory(UPLOAD_DIRECTORY, tmp_csv_file, as_attachment=True)

    # print(converted_data)
    # return converted_data, 200