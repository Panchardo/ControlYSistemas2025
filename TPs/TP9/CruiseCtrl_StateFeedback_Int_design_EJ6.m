%---------------------------------------------------
% Section assignment 3.5.2 - Cruise controller with 
% state feedback with intergral action
%
%---------------------------------------------------
% Model parameters
%---------------------------------------------------

m=40000;                % Vehicle mass [kg]
k=2000;                % Engine torque gain factor [Nm/rad]
r=4;                    % Gear ratio (for a specific gear) [-]
tau=0.8;                % Engine time constant [s]
g=9.82;                 % Gravity [m/s^2]
rho=1.2;                % Air density [kg/m^3]
CD=0.5;                 % Drag coefficient [-]
Af=4;                   % Front area [m^2]
rw=0.5;                 % Wheel radius [m]
f=0.015;                % Rolling resistance coefficient [-]\\
alpha = deg2rad(2);


%---------------------------------------------------
% Equilibrium point 
%---------------------------------------------------
% x2e=                  % Vehicle velocity [m/s]
% x1e=                  % Wheel force [N]
% ue=                   % Pedal position [rad]
% de=                   % Slope [rad]

x2e=15;                 
x1e=0.5*rho*CD*Af*x2e^2+m*g*f;
ue=rw*x1e/k/r;
de=0;


%---------------------------------------------------
% Linear longitudinal vehicle dynamics model 
% A, B, C, D and H matrices
%---------------------------------------------------
%Agrego variable de estado
A=[[-1/tau 0];[1/m -rho*CD*Af*x2e/m]];
B=[k*r/tau/rw 0]';
H=[0 -g]';
C=[0 1];
D=[0];

Aaug = [A [0;0]; C 0]
Baug = [B;0]
Haug = [H;0]
Caug = [C 0]

%-----------------------------------------------------
% Control design part
% Enter your control design here
%-----------------------------------------------------
% ...
z = 1/sqrt(2);
wn = 0.6;
p1 = [1 2*z*wn wn^2];
p2 = [0 1 3*z*wn];
p = conv(p1,p2)
polos = roots(p)
Kaug = acker(Aaug,Baug,polos)
K = Kaug(1, 1:2)
Ki = Kaug(3)
M = A - B*K;

X = C * (M \ B)  

kr = -1 / X 
%Kaug=

%---------------------------------------------------
% For simulation purposes (do not modify)
%---------------------------------------------------
A = Aaug;
B1=[Baug Haug];                   % Put the B and H matrix together as one matrix B1 (for Simulink implementation purposes) 
C1=eye(3);                  % Output all state variables from the model
D1=zeros(3);              % Corresponding D matrix

