close all;
clear all;

y=load('ECG.txt');
figure();
subplot(3,1,1);
plot(y);
xlabel('Funcion de Numero de Muestras');
ylabel('Representado por amplitud');
title('Grafica de ECG');
nm=length(y);
raf= rand(nm,1)*max(max(y))/8;% Generamos un Vector de Ruido aleatorio.
%ruido blando
y2= raf +y; % Señal con ruido

subplot(3,1,2);

plot(y2);
xlabel('Funcion de Numero de Muestras');
ylabel('Representado por amplitud');
title('Grafica de ECG, con Ruido blanco de alta frecuencia');


fs = 100; % Frecuencia de Muestreo
ts = 1/fs;

t = 0:ts:((nm-1)/fs); % Vector de tiempo
rbf = sin(0.5*pi*t')*max(y)/8; % Señal con ruido de baja frecuencia
y3 = y + rbf; % Señal original más el ruido de baja frecuencia
subplot(3,1,3);
plot(t, y3);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal con ruido de baja frecuencia');

N= 1e4;
n=0:N-1;
fs=3600;
f0=180;
t=n/fs;
y= sin(2*pi*f0*t);
noise= randn(size(y));
dispol=[0.5 0.75 1 0];% Coeficientes del polinomio
%0.5*x^3 + 0.75x^2+x
out=polyval(dispol,y+noise);%Evaluar el polinomio en cada punto

figure();
plot(t,[out;polyval(dispol,y)]); %Grafica la señal normal
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal con ruido de baja frecuencia');

[pxx,f] = pwelch(out,[],[],[],fs);
figure()
pwelch(out,[],[],[],fs);
