function noisy_signal = my_awgn(signal, SNR)
    % Calcular la potencia de la señal
    P_signal     = mean(signal.^2);  % Potencia de la señal
    noise_factor = 10^(-SNR/10);     % Factor de reducción de la SNR
    
    % Potencia del ruido
    P_noise     = P_signal * noise_factor;
    
    mu_noise    = 0;
    sigma_noise = sqrt(P_noise);
    
    % Generar y agregar ruido gaussiano mu = 0; sigma = sigma_noise
    noise        = mu_noise + sigma_noise * randn(size(signal));
    noisy_signal = signal + noise;
end