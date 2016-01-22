import json
from sympy import randprime
p = randprime(2 ** 157, 2 ** 158)
q = randprime(2 ** 157, 2 ** 158)
n = p * q
e = 65537
m = int(open('flag').read().strip().encode('hex'), 16)
assert m < n
c = pow(m, e, n)
print json.dumps({'n': n, 'e': e, 'c': c})
