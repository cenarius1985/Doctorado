%Cargar una señal .txt unidimensional
Signal = load('ECG.txt');

%Cargar una señal .mat con dos vectores
Signal2 = load('ecg.mat');

%Cargar una señal .xlsx de un archivo Excel
Signal3 = xlsread('ECG.xlsx');

%Generar una señal discreta senoidal
Fs = 15; %Frecuencia de muestreo en Hz
Ts = 1/Fs; %Periodo de muestreo: tiempo entre cada muestra en s
ts = 0:Ts:1; %Vector con los momentos en el tiempo para los que está definida la señal
y = sin(2*pi*ts); %Señal senoidal 1 periodo a 16 muestras

%Ejemplo de una señal multicanal
Signal4 = load('MulticanalSignal.mat');