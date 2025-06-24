clear
clc
close all

freqcubesat1 = 1134; % [Hz]

m_movil = 0.94; % [kg] Masa plato + bobina
m_cubesat = 1.33; %[kg] Masa Cubesat
m_shaker = 100; %[kg]

kem = 15761; % [N/m]
kc = (2*pi*freqcubesat1*m_cubesat)^2;
k_shaker = 5000; % [N/M]

M = [m_cubesat 0 0;
    0 m_movil 0;
    0 0 m_shaker];
K = [kc -kc 0;
    -kc kc+kem -kem;
    0 -kem kem+k_shaker];


[autovec,autoval]=eig(K,M);
w=diag(autoval^0.5)
f = w/(2*pi)

dt=0.0001;
T=5;
t=0:dt:T;

x0=[0;0.01;0];
v0=zeros(3,1);

w=diag(autoval^0.5);

y0=autovec'*M*x0;

y00=autovec'*M*v0;

zittam1 = 0.9;
zittam2 = 0.08;
zittam3 = 0.01;

zitta = [zittam1;zittam2;zittam3];
wd = zeros(length(w),1);

for i = 1:length(w)
    wd(i) = w(i)*sqrt(1-zitta(i)^2);
end

q1 = [exp(-zitta(1)*w(1)*t) .* y0(1) .* cos(wd(1)*t);
      exp(-zitta(2)*w(2)*t) .* y0(2) .* cos(wd(2)*t);
      exp(-zitta(3)*w(3)*t) .* y0(3) .* cos(wd(3)*t)];

q2 = [exp(-zitta(1)*w(1)*t) .* zitta(1)/(sqrt(1-zitta(1)^2)) .* sin(wd(1)*t) .* y0(1);
      exp(-zitta(2)*w(2)*t) .* zitta(2)/(sqrt(1-zitta(2)^2)) .* sin(wd(2)*t) .* y0(2);
      exp(-zitta(3)*w(3)*t) .* zitta(3)/(sqrt(1-zitta(3)^2)) .* sin(wd(3)*t) .* y0(3)];

q3 = [y00(1)/wd(1) .* sin(wd(1)*t) .* exp(-zitta(1)*w(1)*t);
      y00(2)/wd(2) .* sin(wd(2)*t) .* exp(-zitta(2)*w(2)*t);
      y00(3)/wd(3) .* sin(wd(3)*t) .* exp(-zitta(3)*w(3)*t)];




q=q1+q2+q3;

X=autovec*q;

Cmodal = [2*zitta(1)*w(1) 0 0;
          0 2*zitta(2)*w(2) 0;
          0 0 2*zitta(3)*w(3);];
          
C = M*autovec*Cmodal*autovec'*M;

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


