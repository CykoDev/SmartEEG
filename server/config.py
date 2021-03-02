import os
basedir = os.path.abspath(os.path.dirname(__file__))

class Config(object):

    SECRET_KEY = os.environ.get('SECRET_KEY') or 'ze-dream-team-aaas'

    # Uploads
    UPLOADS_CSV_DEST = os.path.join(basedir, 'app/static/csv/')
    UPLOADS_CSV_URL = 'http://localhost:5000/static/img/'
    
    UPLOADED_EDF_DEST = os.path.join(basedir, 'app/static/edf/')
    UPLOADED_EDF_URL = 'http://localhost:5000/static/edf/'