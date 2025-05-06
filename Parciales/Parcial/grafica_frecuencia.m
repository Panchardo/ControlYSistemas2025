function grafica_frecuencia(f, X, titulo, modo_dB)
% grafica_frecuencia - Grafica un espectro en frecuencia en magnitud o dB.
%
% Parámetros:
%   f       - Vector de frecuencias [Hz]
%   X       - Magnitud del espectro
%   titulo  - Título del gráfico (string)
%   modo_dB - (opcional) true para graficar en dB, false en magnitud

    if nargin < 4
        modo_dB = false;
    end

    figure;
    if modo_dB
        plot(f, 20*log10(abs(X) + eps), 'LineWidth', 1.5);  % +eps para evitar log(0)
        ylabel('Magnitud [dB]');
        title([titulo ' (dB)']);
    else
        plot(f, abs(X), 'LineWidth', 1.5);
        ylabel('Magnitud');
        title([titulo ' (magnitud)']);
    end

    xlabel('Frecuencia [Hz]');
    grid on;

    % Ajustar límites automáticamente
    xlim([min(f), max(f)]);
    ylim([min(ylim), max(ylim)]);

end
