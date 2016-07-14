import json
from sympy import randprime

p = randprime(2 ** 512, 2 ** 513)
q = randprime(2 ** 512, 2 ** 513)
n = p * q

e1 = randprime(2 ** 1000, 2 ** 1001)
e2 = randprime(2 ** 1000, 2 ** 1001)

m = int(open('flag').read().strip().encode('hex'), 16)
assert m < n
c1 = pow(m, e1, n)
c2 = pow(m, e2, n)

print json.dumps({'n': n, 'e1': e1, 'e2': e2, 'c1': c1, 'c2': c2})

