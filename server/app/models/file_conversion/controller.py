from flask import Blueprint, request, render_template, flash, g, session, redirect, url_for, send_from_directory, send_file, after_this_request
from app import UPLOAD_DIRECTORY
import os
import numpy as np
import mne
import time
from app.models.file_conversion.utils import write_mne_edf
from app.models.file_conversion.utils import _stamp_to_dt


file_conversion_controller = Blueprint('conversion', __name__, url_prefix='/conversion')

@file_conversion_controller.route("/edf2csv", methods=['POST'])
def edf_to_csv2():

    tmp_edf_file = f'in_{time.time()}.edf'
    with open(os.path.join(UPLOAD_DIRECTORY, tmp_edf_file), "wb") as fp:
        fp.write(request.data)

    # perform conversion
    edf = mne.io.read_raw_edf(UPLOAD_DIRECTORY + "\\" +tmp_edf_file)
    header = ','.join(edf.ch_names)
    tmp_csv_file = f'out_{time.time()}.csv'
    np.savetxt(UPLOAD_DIRECTORY+'/'+tmp_csv_file, edf.get_data().T, delimiter=',', header=header)

    os.remove(UPLOAD_DIRECTORY+'/'+ tmp_edf_file)
    return send_from_directory(UPLOAD_DIRECTORY, tmp_csv_file, as_attachment=True), 200


@file_conversion_controller.route("/csv2edf/<outputfilename>", methods=['POST'])
def edf_to_csv2():

    tmp_csv_file = f'in_{time.time()}.csv'
    with open(os.path.join(UPLOAD_DIRECTORY, tmp_edf_file), "wb") as fp:
        fp.write(request.data)

    # perform conversion
    
    
    return 200


# test route
@file_conversion_controller.route("/download/<filename>", methods=['GET'])
def download(filename):
    return send_from_directory(UPLOAD_DIRECTORY, filename, as_attachment=True)