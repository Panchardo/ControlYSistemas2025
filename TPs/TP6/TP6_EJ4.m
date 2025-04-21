clear
clc
close all

fc1 = 300; % Hz
fc2 = 3400; % Hz
fs = 10000; % Hz
dt = 1/fs ; % s
orden = 10;
ripple = 1;

% b) Normalice las frecuencias de corte en radianes según la frecuencia de muestreo:
wc1_n = 2*pi*fc1/fs;
wc2_n = 2*pi*fc2/fs;

% c) Aplique precombado (pre-warping) a las frecuencias analógicas de interés.
wc1_p = (2/dt)*tan(wc1_n/2);
wc2_p = (2/dt)*tan(wc2_n/2);

% d) Diseñe el filtro analógico conlas funciones cheb1ap() y lp2bp():
[Z, P, K] = cheb1ap(orden, ripple);
[ B, A ] = zp2tf(Z, P, K); % B es num y A es den
figure(3)
freqs(B, A)
figure(5);
sys = tf(B,A);
pzmap(sys);
w_central = sqrt(wc1_p*wc2_p);
bw = wc2_p - wc1_p;
[num_a, den_a] = lp2bp(B,A, w_central, bw);

% e) Discretice el filtro analógico:
H_analog = tf(num_a, den_a);
H_digital = c2d(H_analog, dt, 'tustin');
num_d = H_digital.numerator{1, 1};
den_d = H_digital.denominator{1, 1};
% f) Grafique la respuesta del filtro digital en el plano Z:
figure(4)
zplane(num_d, den_d, 500000)
grid on

% g) Determine la respuesta en frecuencia de ambos filtros:
[h_a, w_a] = freqs(num_a, den_a, 1000);
[h_d, w_d] = freqz(num_d, den_d, 1000);
% h) Grafique la respuesta en frecuencia y fase del filtro digital:
mag_a = abs(h_a);
phi_a = phase(h_a);
f_a = w_a/pi/2;
mag_d = abs(h_d);
phi_d = phase(h_d);
f_d = w_d/pi/2 * fs;

figure(1)
plot (f_a, mag_a, 'b');
hold on
plot (f_d, mag_d, 'g');
title('RESPUESTA EN FRECUENCIA')
grid on
legend('Filtro analogico', 'Filtro digital')

figure(2)
plot (f_a, phi_a, 'b');
hold on
plot (f_d, phi_d, 'g');
title('RESPUESTA EN FASE')
grid on
legend('Filtro analogico', 'Filtro digital')