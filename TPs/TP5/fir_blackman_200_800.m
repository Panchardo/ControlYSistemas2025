function Hd = fir_blackman_200_800
%FIR_BLACKMAN_200_800 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.8 and Signal Processing Toolbox 8.4.
% Generated on: 13-Apr-2025 13:53:48

% FIR Window Bandpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 10000;  % Sampling Frequency

N    = 100;      % Order
Fc1  = 200;      % First Cutoff Frequency
Fc2  = 800;      % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = blackman(N+1);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

% [EOF]
