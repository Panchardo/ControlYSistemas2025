%---------------------------------------------------
% Exercises on 3.4.2 - Driveline control
% Vehicle parameters
%---------------------------------------------------

Jc=6250;                        % Chassis inertia [kgm^2]
Jf=0.625;                       % Flywheel inertia [kgm^2]
ds=1000;                        % Driveshaft damping coefficient [Nms/rad]
cs=75000;                       % Driveshaft spring coefficient [Nm/rad]
i=57;                           % Gear ratio [-]

%---------------------------------------------------
% Enter your A, B and H matrices here
%---------------------------------------------------
 A=[-ds/(Jf*i^2) ds/(Jf*i) -cs/(Jf*i);
     ds/(Jc*i) -ds/Jc cs/Jc;
     1/i -1 0];
 B=[1/Jf;0;0];
 H= [0;-1/Jc; 0];
 C = [0 1 0]

%---------------------------------------------------
% Enter your control design here
% Hint: charpoly - could be a good  and useful function
%---------------------------------------------------
% Wr=
% Wr_tilde=
% K=
% kr=
z = 1/sqrt(2);
wn = 40;
p1 = [1 2*z*wn wn^2];
p2 = [0 1 1*z*wn];
p3 = [0 1 0.005*z*wn];
p = conv(p1,p2);
p = conv(p,p3)
polos = roots(p)


%% CONTROL INTEGRAL AGREGADO POR LOS JIJEOS

Aaug = [A [0;0;0]; C 0]
Baug = [B;0]
Kaug = acker(Aaug,Baug,polos)
K = Kaug(1, 1:3)
Ki = Kaug(4)
M = A - B*K;
X = C * (M \ B);  % Equivalente a inv(M)*Bu pero más estable
% Finalmente, kr = -inv(Y)
kr = -1 / X  % Si Y es escalar
Br = [0 0 0 -1]'
sys = ss(Aaug - Baug*Kaug, Baug*kr+Br, [C 0], 0);
stepinfo(sys)
step(sys)
% ---------------------------------------------------
% For simulation purposes (do not modify)
%---------------------------------------------------

B1=[B H];                       % Put the B and H matrix together as one matrix B1 (for Simulink implementation purposes) 
C=eye(3);                       % Output all state variables from the model
D=zeros(3,2);                   % Corresponding D matrix
x0=[120 2 0]';                  % Initial conditions for the state variables

