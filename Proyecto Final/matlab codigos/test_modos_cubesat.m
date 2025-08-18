clear
clc
close all 

mc = 0.41;
fs = 100000;        % Hz
t = 0:1/fs:10;     % tiempo
f_exc = 1200;        % Hz
y = 10^(-6) * sin(2*pi*f_exc*t);   % desplazamiento base
ypp = -(2*pi*f_exc)^2*y;

meff1 = 0.152219*mc;
meff2 = 0.116567*mc;
meff3 = 0.358055*mc;
meff4 = 0.127348*mc;

w1 = 1208*2*pi;
w2 = 2696*2*pi;
w3 = 3139*2*pi;
w4 = 5273*2*pi;

kef1 = meff1*w1^2;
kef2 = meff2*w2^2;
kef3 = meff3*w3^2;
kef4 = meff4*w4^2;

M_ef = [meff1 0 0 0; 
        0 meff2 0 0;
        0 0 meff3 0;
        0 0 0 meff4]
K_ef = [kef1 0 0 0 ;
        0 kef2 0 0;
        0 0 kef3 0;
        0 0 0 kef4]

%[autovec1, autoval1] = eig(K_ef,M_ef);

sys1 = tf([kef1], [meff1, 0, kef1]);
sys2 = tf([kef2], [meff2, 0, kef2]);
sys3 = tf([kef3], [meff3, 0, kef3]);
sys4 = tf([kef4], [meff4, 0, kef4]);

x_modal1 = lsim(sys1, y, t);
x_modal2 = lsim(sys2, y, t);
x_modal3 = lsim(sys3, y, t);
x_modal4 = lsim(sys4, y, t);

F_base_modal4 = kef1*(x_modal1 - y')+kef2*(x_modal2-y')+ kef3*(x_modal3 -y') + kef4*(x_modal4 - y');
F_base_modal3 = kef1*(x_modal1 - y')+kef2*(x_modal2-y')+ kef3*(x_modal3 -y');
F_base_modal2 = kef1*(x_modal1 - y')+kef2*(x_modal2-y');
F_base_modal1 = kef1*(x_modal1 - y');
F_base_modal_res = kef1*x_modal1-(mc-meff1)*ypp'-(kef1+kef2+kef3+kef4)*y';

figure(2);
plot(t, F_base_modal4, 'b', 'DisplayName','4 Modos'); hold on;
%plot(t, F_base_modal3, 'r--', 'DisplayName','3 Modos');
%plot(t, F_base_modal2, 'black--', 'DisplayName','2 Modos');
%plot(t, F_base_modal1, 'green--', 'DisplayName','1 Modo');
plot(t, F_base_modal_res, 'red--', 'DisplayName','1 Modo + residuo');
xlabel('Tiempo [s]');
ylabel('Fuerza transmitida a la base [N]');
legend;
title('Comparación de fuerza transmitida a la base');
grid on;

figure(1);
plot(t, x_modal1, 'b', 'DisplayName','Modo 1'); hold on;
plot(t, x_modal2, 'r--', 'DisplayName','Modo 2');
plot(t, x_modal3, 'black--', 'DisplayName','Modo 3');
plot(t, x_modal4, 'green--', 'DisplayName','Modo 4');
xlabel('Tiempo [s]');
ylabel('Posición modal (m)');
legend;
title('Comparación de posiciones modales');
grid on;
