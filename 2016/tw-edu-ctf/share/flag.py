#!/usr/bin/env/python2
# https://h34dump.com/2013/05/volgactf-quals-2013-crypto-200/

import json

with open('share.json') as dfile:
    data = json.load(dfile)

e1 = data['e1']
e2 = data['e2']
c1 = data['c1']
c2 = data['c2']
n = data['n']

def gcd(a, b):
    if a == 0:
        x, y = 0, 1;
        return (b, x, y);
    tup = gcd(b % a, a)
    d = tup[0]
    x1 = tup[1]
    y1 = tup[2]
    x = y1 - (b / a) * x1
    y = x1
    return (d, x, y)

#solve the Diophantine equation a*x0 + b*y0 = c
def find_any_solution(a, b, c):
    tup = gcd(abs(a), abs(b))
    g = tup[0]
    x0 = tup[1]
    y0 = tup[2]
    if c % g != 0:
        return (False, x0, y0)
    x0 *= c / g
    y0 *= c / g
    if a < 0:
        x0 *= -1
    if b < 0:
        y0 *= -1
    return (True, x0, y0)

import sys
sys.setrecursionlimit(5000)

(x, a1, a2) = find_any_solution(e1, e2, 1)
if a1 < 0:
    (x, c1, y) = find_any_solution(c1, n, 1) #get inverse element
    a1 = -a1
if a2 < 0:
    (x, c2, y) = find_any_solution(c2, n, 1)
    a2 = -a2

m = (pow(c1, a1, n) * pow(c2, a2, n)) % n

print hex(m)[2:-1].decode('hex')
