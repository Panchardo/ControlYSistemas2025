clear
clc
close all

m_movil = 0.94; % [kg] Masa plato + bobina
m_cubesat = 1.33; %[kg] Masa Cubesat
m_shaker = 100; %[kg]
bm = 1000; % [Ns/m] coeficiente de fricción viscosa (a confirmar)
kem = 15761; % [N/m]

freqcubesat1 = 1134; % [Hz]
kc = (2*pi*freqcubesat1*m_cubesat)^2;

k_shaker = 1; % [N/M]

M = [m_cubesat 0 0;
    0 m_movil 0;
    0 0 m_shaker];
K = [kc -kc 0;
    -kc kc+kem -kem;
    0 -kem kem+k_shaker];


[autovec,autoval]=eig(K,M);
w=diag(autoval^0.5);

dt=0.0001;
T=100;
t=0:dt:T;

x0=[0.0988841011374128;0.0988841011230928;0.0988839618650851];
v0=zeros(3,1);

w=diag(autoval^0.5);

y0=autovec'*M*x0;

y00=autovec'*M*v0;

q1=[y0(1)*cos(w(1)*t);
    y0(2)*cos(w(2)*t);
    y0(3)*cos(w(3)*t);];

q2=[y00(1)/w(1)*sin(w(1)*t);
    y00(2)/w(2)*sin(w(2)*t)
    y00(3)/w(3)*sin(w(3)*t)];

q=q1+q2;

X=autovec*q;

figure(1);
subplot(3,1,1);
plot(t, X(1,:), 'b', 'LineWidth', 1);
xlabel('Tiempo (s)');
ylabel('Posición (m)');
title('Posición GL1 vs Tiempo');
grid on

subplot(3,1,2);
plot(t, X(2,:), 'b', 'LineWidth', 1);
xlabel('Tiempo (s)');
ylabel('Posición (m)');
title('Posición GL2 vs Tiempo');
grid on

subplot(3,1,3);
plot(t, X(3,:), 'b', 'LineWidth', 1);
xlabel('Tiempo (s)');
ylabel('Posición (m)');
title('Posición GL3 vs Tiempo');
grid on


