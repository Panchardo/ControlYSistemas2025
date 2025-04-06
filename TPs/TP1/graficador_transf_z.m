close all
clear
clc

a = [1 -1/2]; % Coeficientes del denominador
b = [1]; % Coeficientes del numerador

F = tf(b,a,-1)
zplane(b, a); % Grafica ceros y polos
grid on;
title('Diagrama de polos y ceros');

N = 512; % Número de puntos de frecuencia

[H, w] = freqz(b, a, N); % Calcula la respuesta en frecuencia

figure;
subplot(2,1,1);
plot(w/pi, abs(H)); % Magnitud
xlabel('Frecuencia normalizada (\times\pi rad/muestra)');
ylabel('Magnitud');
title('Respuesta en frecuencia');

subplot(2,1,2);
plot(w/pi, angle(H)); % Fase
xlabel('Frecuencia normalizada (\times\pi rad/muestra)');
ylabel('Fase (radianes)');
title('Fase de la respuesta en frecuencia');

syms n z
v=1;
sympref('HeavisideAtOrigin', v);
y1 = ((1/3)^n) * heaviside(n);
y2 = -((1/2)^n) * heaviside(-n-1);
y3 = ((1/2)^n) * heaviside(n) - 2^n * heaviside(-n-1);
ej1 = ztrans(y1,n) 
ej2 = ztrans(y2,n)% ztrans solo computa la transformada unilateral para n>0
ej3 = ztrans(y3,n)
