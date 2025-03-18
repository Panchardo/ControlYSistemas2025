clear all
clc
close all

%EJ 2

x1 = [1 1 3];  % Coeficientes de X1(z)
x2 = [1 0 3];  % Coeficientes de X2(z)

y_conv = conv(x1, x2);  % Convolución en el dominio Z
disp('Convolución con conv:');
disp(y_conv);

y_filter = filter(x2, 1, [x1 zeros(1, length(x2)-1)]);
disp('Convolución con filter:');
disp(y_filter);

y_filt = filt(x1, 1) * filt(x2, 1);
disp('Convolución con filt: ');
y_filt

%EJ 3
oldparam = sympref('HeavisideAtOrigin',1);
syms n
x = heaviside(n)*(0.5)^n + heaviside(n)*(0.3)^n + heaviside(n)*(0.9)^n
X = ztrans(x)
pretty(X)

% EJ 4.1

H = filt([1], [1 -0.7])

%EJ 4.2
syms z
X = 1;
resp_impulso = H * X
resp_impulso_tiempo = iztrans(1/(1-0.7*z^-1))

%EJ 4.3
X = filt([1], [1 -1])
resp_step = H * X
resp_step_tiempo = iztrans(1/(1-1.7*z^-1+0.7*z^-2))

figure(1)
step(H)

b = [1];             % Numerador
a = [1 -1.7 0.7];    % Denominador
[r, p, k] = residuez(b, a);  % r: residuos, p: polos, k: coef. directos

N = 20; % Número de muestras
impulse = [1 zeros(1, N-1)]; % Secuencia impulso unitario
y_filter = filter(b, a, impulse); % Respuesta al impulso

figure(2)
stem(0:N-1, y_filter, 'filled');
xlabel('n');
ylabel('x[n]');
title('Respuesta al impulso con filter');
grid on;


n = 0:N-1;
x_exacta = r(1) * (p(1).^n) + r(2) * (p(2).^n);
hold on;
stem(n, x_exacta, 'r');
legend('filter', 'Analítica');
hold off;

%EJ 5

Y5 = filt([1], [1 -1]) * filt([1],[1 -0.5 -0.1 -0.2])



