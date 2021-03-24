from werkzeug.wrappers import Request, Response, ResponseStream

class testMiddleware():

    def __init__(self, app):
        self.app = app

    def __call__(self, environ, start_response):
        request = Request(environ)

        print('-- general middleware before route')
        
        return self.app(environ, start_response)