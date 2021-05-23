from functools import wraps

def test_decorator():
    def _test_decorator(f):
        @wraps(f)
        def __test_decorator(*args, **kwargs):
            print('---- decorator middleware before route')
            result = f(*args, **kwargs)
            print(result)
            print('---- decorator middleware after route')
            return result
        return __test_decorator
    return _test_decorator