clear
clc
close all

m1 = 2;
m2 = 1;
k1 = 1000;
k2 = 2000;
k3 = 3000;
mt = m1+m2;
M = [m1 0;
    0 m2];
K = [k3+k1 -k3;
    -k3 k3+k2];

B = [k1;
     k2];

[autovec, autoval] = eig(K,M);

w = diag(autoval^0.5);
f = w/(2*pi);


fs = 10000;        % Hz
t = 0:1/fs:6;     % tiempo
f_exc = 60;        % Hz
y = 0.01 * sin(2*pi*f_exc*t);   % desplazamiento base
ypp = -(2*pi*f_exc)^2*y;
F = B * y; % Fuerza equivalente generada por movimiento de la base

%% Simulación del sistema físico real
A1 = [zeros(2), eye(2);
     -M\K, zeros(2)];
Bu1 = [zeros(2,1); M\B];

sys_real = ss(A1,Bu1,eye(4),zeros(4,1));

resp_real = lsim(sys_real, y', t);

x1 = resp_real(:,1);
x2 = resp_real(:,2);

F_base_real = k1*(x1 - y') + k2*(x2 - y');
          
%% Con masa efectiva

coef_part_1 = autovec(:,1)'*M*[1;1];
coef_part_2 = autovec(:,2)'*M*[1;1];

masa_eff_1 = coef_part_1^2
masa_eff_2 = coef_part_2^2

kef1 = masa_eff_1*autoval(1,1)
kef2 = masa_eff_2*autoval(2,2)
M_ef = [masa_eff_1 0; 
        0 masa_eff_2]
K_ef = [kef1 0 ;
        0 kef2]

%[autovec1, autoval1] = eig(K_ef,M_ef);

sys1 = tf([kef1], [masa_eff_1, 0, kef1]);
sys2 = tf([kef2], [masa_eff_2, 0, kef2]);

x_modal1 = lsim(sys1, y, t);
x_modal2 = lsim(sys2, y, t);

F_base_modal = kef1*(x_modal1 - y')+kef2*(x_modal2-y');

F_base_masa_residual = kef1*x_modal1-(masa_eff_2)*ypp'-(kef1+kef2)*y';

Finercialy = masa_eff_2*ypp';
Felasticay = -kef2*x_modal2;

%% Gráfica
figure(1);
subplot(2,1,1)
plot(t, x1, 'black', 'DisplayName','x1 física');
hold on
grid on
plot(t, x_modal1, 'b--', 'DisplayName','x1 modal');
subplot(2,1,2)
plot(t, x2, 'black', 'DisplayName','x2 física');
hold on
plot(t, x_modal2, 'r--', 'DisplayName','x2 modal');
xlabel('Tiempo [s]');
ylabel('Desplazamiento [m]');
legend;
title('Comparación de desplazamientos físicos vs modales');
grid on;

figure(2);
plot(t, F_base_real, 'b', 'DisplayName','Física real'); hold on;
plot(t, F_base_modal, 'r--', 'DisplayName','Modelo modal');
plot(t, F_base_masa_residual, 'black--', 'DisplayName','Modelo modal con masa residual');
xlabel('Tiempo [s]');
ylabel('Fuerza transmitida a la base [N]');
legend;
title('Comparación de fuerza transmitida a la base');
grid on;

figure(3);
plot(t, Finercialy, 'b', 'DisplayName','Inercial'); hold on;
plot(t, Felasticay, 'r--', 'DisplayName','Elástica');
xlabel('Tiempo [s]');
ylabel('Fuerza [N]');
legend;
title('Fuerza inercial vs elastica');
grid on;

