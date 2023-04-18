close all;
clear all;
clc;
% Generar 2s de un pulso triagular y rectangular
% fs=10khz, ancho de 20 ms
% Formas de onda periodicas.
fs =10000;
t=-1:1/fs:1;
ancho=20e-3;
x1= tripuls(t,ancho);
x2 = rectpuls(t,ancho);
figure();
subplot(4,1,1);
plot(t,x1)
xlabel('Pulso a periodico triangular');
ylabel('Representado por amplitud');
title('Grafica de ECG');
subplot(4,1,2);
plot(t,x2)
xlabel('Pulso a periodico Rectangular');
ylabel('Representado por amplitud');
title('Grafica de ECG');
% Trenes de pulsos
fs=100E9;
D = [2.5 10 17.5]'*1e-9;
t=0:1/fs:2500/fs;
w= 1e-9;
x3=pulstran(t,D,@rectpuls,w);
subplot(4,1,3);
plot(t*10e9,x3)
xlabel('Pulso');
ylabel('Representado por amplitud');
title('Trenes de Pulso');
T= 0:1/50e3:10e-3;
D = [0:1/1e3:10e-3;
    0.8.^(0:10)]';
Y= pulstran(T,D,@gauspuls,10E3,0.5);
subplot(4,1,4);
plot(T*1e3,Y)
xlabel('Pulso a periodico Rectangular');
ylabel('Representado por amplitud');
title('Tren de pulsos guasianos');

    
