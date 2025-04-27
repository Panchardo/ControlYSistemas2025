m1 = 250;
m2 = 25;
k1 = 22000;
k2 = k1;
c1 = 2000;

A = [0 1 0 0;
    -k1/m1 -c1/m1 k1/m1 c1/m1;
    0 0 0 1;
    k1/m2 c1/m2 -(k1+k2)/m2 -c1/m2]
B = [0 0 0 k2/m2]'
C = [1 0 0 0;
    0 0 1 0]
D = [0;0]


sys = ss(A,B,C,D)

step(sys)

syms s

lol = s*eye(4)- A
C*inv(lol)*B