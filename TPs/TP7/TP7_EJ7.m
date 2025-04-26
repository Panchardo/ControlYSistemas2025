clear
clc
close all

m = 250;
c = 2000;
k = 22000;
wn = sqrt(k/m)
f = wn/(2*pi)

num = [0 c k]
den = [m c k]

printsys(num,den)

sys = tf(num,den)

step(sys)
bode(sys)