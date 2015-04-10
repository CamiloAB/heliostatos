%% histogramas_por_temporada.m
% Realiza un histograma (de la primer repetici�n del archivo
% con los datos por cada temporada (verano, invierno, primavera)
% sin contemplar la otra temporada de quinoxio al ser muy similares.
clear all
close all
clc

%% Carga los datos necesarios para realizar y guardar los histogramas

% campo = 0 es el campo chico, y campo = 1 es el campo mediano
campo = 1;
if campo == 0
    archivo_posiciones = '../campos_info/posiciones_chico.txt';
    archivos_datos = '../data_gen/campo_chico/heliostato';    
    archivos_imagen = '../figuras/campo_chico/histograma_';
elseif campo == 1
    archivo_posiciones = '../campos_info/posiciones_grande.txt';
    archivos_datos = '../data_gen/campo_grande/heliostato';    
    archivos_imagen = '../figuras/campo_grande/histograma_';
end
heliostatos = load(archivo_posiciones, '-ascii');    

% desviaciones asumiendo que se simul� previamente el
% campo utilizando la funci�n simulacion_anual.m
desviaciones_nominales = [0.5e-3, 0.5e-3, 0.5e-3, 0.5e-3; ...
                          1.5e-3, 1.5e-3, 1.5e-3, 1.5e-3; ...
                          2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3; ...
                          5e-3,     5e-3,   5e-3,   5e-3; ...
                          1e-3,        0,      0,      0; ...
                          3e-3,        0,      0,      0; ...
                          5e-3,        0,      0,      0; ...
                         10e-3,        0,      0,      0; ...
                             0,     1e-3,      0,      0; ...
                             0,     3e-3,      0,      0; ...
                             0,     5e-3,      0,      0; ...
                             0,    10e-3,      0,      0; ...
                             0,        0,   1e-3,      0; ...
                             0,        0,   3e-3,      0; ...
                             0,        0,   5e-3,      0; ...
                             0,        0,  10e-3,      0; ...
                             0,        0,      0,   1e-3; ...
                             0,        0,      0,   3e-3; ...
                             0,        0,      0,   5e-3; ...
                         0,        0,      0,  10e-3];
                         
% desviaciones_nominales = [5e-3,     5e-3,   5e-3,   5e-3; ...
%                          10e-3,        0,      0,      0; ...
%                              0,    10e-3,      0,      0; ...
%                              0,        0,  10e-3,      0; ...
%                              0,        0,      0,  10e-3];
                         

% Numero de bins del histograma
bins = 20;

% Resumen de resultados donde cada linea trae
% temporada beta gamma epsilon xi k(weibull) lambda(weibull) p h0s 
% 
% donde temporada = 1(equinoccio) 2(solsticio verano) 3(solsticio invierno)
resumen = [];


%% Realiza los histogramas por periodo de tiempo y calcula el ajuste para una weibull

for des_index = 1:size(desviaciones_nominales, 1)
    
    close all

    desviaciones = desviaciones_nominales(des_index, :);
    des_str = sprintf('_%1.1f', desviaciones * 1e3);

    % Inicializa los vectores de error
    E_primavera = [];
    E_verano = [];
    E_invierno = [];

    for h = 1:size(heliostatos, 1)
        load([archivos_datos, int2str(h), des_str, '.mat']);
        
        temp = TNE(TNE(:,1) == 80, 3);
        E_primavera = [E_primavera; temp(1:12:end)];
        
        temp = TNE(TNE(:,1) >= 172 - 11 & TNE(:,1) <= 172, 3);
        E_verano = [E_verano; temp(1:12:end)];
         
        temp = TNE(TNE(:,1) >= 355 - 11 & TNE(:,1) <= 355, 3);
        E_invierno = [E_invierno; temp(1:12:end)];
        
        clear TNE TNX TNY        
    end

    err_str = sprintf('\\beta = %1.2g, \\gamma = %1.2g, \\epsilon = %1.2g, \\xi = %1.2g, ', ...
                      desviaciones(1), desviaciones(2), desviaciones(3), desviaciones(4)) ;

    [h0s, p_media] = varias_muestras(E_primavera, 500, 10, bins);
    weibull_str = sprintf('p = %0.3f, h0s = %d', p_media, h0s); 
    params_wbl = wblfit(E_primavera);
    resumen = [resumen; [1, desviaciones, params_wbl, p_media, h0s]];
    
    figure();
    histfit(E_primavera, bins,'Weibull');
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');
    title(['\fontsize{12}', 'Spring', err_str, weibull_str]);
    ylabel('Frequency', 'FontSize', 18, 'FontName', 'Times New Roman');
    xlabel('\theta (rad)', 'FontSize', 18, 'FontName', 'Times New Roman')
    saveas(gcf, [archivos_imagen, 'primavera_', des_str,'.fig']);
    saveas(gcf, [archivos_imagen, 'primavera_', des_str,'.png']);

    
    [h0s, p_media] = varias_muestras(E_verano, 500, 10, bins);
    weibull_str = sprintf('p = %0.3f, h0s = %d', p_media, h0s); 
    params_wbl = wblfit(E_verano);
    resumen = [resumen; [2, desviaciones, params_wbl, p_media, h0s]];
    
    figure();
    histfit(E_verano, bins,'Weibull');
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');
    title(['\fontsize{12}', 'Summer', err_str, weibull_str]);
    ylabel('Frequency', 'FontSize', 18, 'FontName', 'Times New Roman');
    xlabel('\theta (rad)', 'FontSize', 18, 'FontName', 'Times New Roman')
    saveas(gcf, [archivos_imagen, 'verano_', des_str,'.fig']);
    saveas(gcf, [archivos_imagen, 'verano_', des_str,'.png']);

    
    [h0s, p_media] = varias_muestras(E_invierno, 500, 10, bins);
    weibull_str = sprintf('p = %0.3f, h0s = %d', p_media, h0s); 
    params_wbl = wblfit(E_invierno);
    resumen = [resumen; [3, desviaciones, params_wbl, p_media, h0s]];
    
    figure();
    histfit(E_invierno, bins,'Weibull');
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');
    title(['\fontsize{12}', 'Winter', err_str, weibull_str]);
    ylabel('Frequency', 'FontSize', 18, 'FontName', 'Times New Roman');
    xlabel('\theta (rad)', 'FontSize', 18, 'FontName', 'Times New Roman')
    saveas(gcf, [archivos_imagen, 'invierno_', des_str,'.fig']);
    saveas(gcf, [archivos_imagen, 'invierno_', des_str,'.png']);
        
end
