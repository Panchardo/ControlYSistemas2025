clear
clc
close all
k1 = 1;
k2 = 4;
c1 = 2;
c2 = 3;
m1 = 1;
m2 = m1;

A = [0 1 0 0;
    -(k2+k1)/m1 -(c2+c1)/m1 k2/m1 c2/m1;
    0 0 0 1; 
    k2/m2 c2/m2 -k2/m2 -c2/m2]
B = [0 0 0 1/m2]'
C = [1 0 0 0;
    0 0 1 0]
D = [0;0]

sys = ss(A,B,C,D)

step(sys)
grid on