# ENVIRONMENTS: production/development/testing

# USAGE:
# (Linux)   export FLASK_ENV=development 
# (Windows) setx FLASK_ENV "development"
# python run.py

# Viewing current environment
# (Linux)   echo $FLASK_ENV
# (Windows) echo %FLASK_ENV%

from app import app

if __name__ == '__main__':
    app.run()