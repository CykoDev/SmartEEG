from flask import Flask


app = Flask(__name__)

# Configurations
if app.config["ENV"] == "production":
    app.config.from_object("config.ProductionConfig")
elif app.config["ENV"] == "testing":
    app.config.from_object("config.TestingConfig")
else:
    app.config.from_object("config.DevelopmentConfig")

print(f'ENV is set to: {app.config["ENV"]}')


# Sample HTTP error handling
@app.errorhandler(404)
def not_found(error):
    return '404 not found'

# Import a module / component using its blueprint handler variable (mod_auth)
from app.models.file_conversion.controller import file_conversion_controller

# Register blueprint(s)
app.register_blueprint(file_conversion_controller)

