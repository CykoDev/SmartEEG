from flask import Flask
import os


app = Flask(__name__)

# Configurations
if app.config["ENV"] == "production":
    app.config.from_object("config.ProductionConfig")
elif app.config["ENV"] == "testing":
    app.config.from_object("config.TestingConfig")
else:
    app.config.from_object("config.DevelopmentConfig")



from config import basedir
UPLOAD_DIRECTORY =  basedir + "\\uploads"
if not os.path.exists(UPLOAD_DIRECTORY):
    os.makedirs(UPLOAD_DIRECTORY)

print(UPLOAD_DIRECTORY)

# Sample HTTP error handling
@app.errorhandler(404)
def not_found(error):
    return '404 not found'

# Import a module / component using its blueprint handler variable (mod_auth)
from app.models.file_conversion.controller import file_conversion_controller

# Register blueprint(s)
app.register_blueprint(file_conversion_controller)

