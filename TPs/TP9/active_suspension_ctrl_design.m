clear
clc
close all
%---------------------------------------------------
% Exercises on Section Assignment 3 - Active suspension control design
% Model parameters
%---------------------------------------------------
load('roaddist.mat')
mc=401;                         % Quarter car mass [kg]
mw=48;                          % Wheel mass [kg]
ds=2200;                        % Suspension damping coefficient [Ns/m]
cs=23000;                       % Suspension spring coefficient [N/m]
cw=250000;                      % Wheel spring coefficient [N/m]
tau=0.001;                      % Actuator time constant [s]

%---------------------------------------------------
% The active suspension model
% A, B, C, and H matrices
%---------------------------------------------------
A=[[0 1 0 0 0];[-(cw+cs)/mw -ds/mw cs/mw ds/mw -1/mw];[0 0 0 1 0];[cs/mc ds/mc -cs/mc -ds/mc 1/mc];[0 0 0 0 -1/tau]];
B=[0 0 0 0 1/tau]';
H=[0 cw/mw 0 0 0]';

C=[[-1 0 1 0 0];[cs/mc ds/mc -cs/mc -ds/mc 1/mc]];   

% Controlable?
M_Controlabilidad = [B A*B A*A*B A*A*A*B A*A*A*A*B]
rango_controlabilidad = rank(M_Controlabilidad)
autovalA = eig(A)
%---------------------------------------------------
% Enter your control design here
%---------------------------------------------------
a1 = 1;
a2 = 1;
y1max = 0.05;
y2max = 5;
umax = 100;
ro = 1;
Qy = [a1/y1max^2 0; 0 a2/y2max^2]
Qx = C'*Qy*C
Qu = ro/umax^2
K = lqr(A,B,Qx,Qu)

M = A - B*K;

X = C * (M \ B) % M \B es equivalente a inv(M)*Bu pero más estable

kr = -1 / X 


%---------------------------------------------------
% For simulation purposes (do not modify)
%---------------------------------------------------
B1=[B H];                   % Put the B and H matrix together as one matrix B1 (for Simulink implementation purposes) 
C1=eye(5);                  % Output all state variables from the model
D1=zeros(5,2);              % Corresponding D matrix


sys = ss(M,B1,C,[0 0;0 0]);
step(sys)
stepinfo(sys)
