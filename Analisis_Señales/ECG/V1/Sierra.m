% Generar una onda diente de sierra y cuadrada
% Formas de Onda Periodicas
fs=1000; %Hz
t= 01:1/fs:1.5;
x1=sawtooth(2*pi*50*t);
x2=square(2*pi*50*t);
figure();
subplot(2,1,1)
plot(t,x1);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Periodica de sierra');
subplot(2,1,2)
plot(t,x2);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Periodica cuadrada');