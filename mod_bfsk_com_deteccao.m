%Modulação BPSK com detecção não coerente

clear all
close all
clc

f1 = 10e3;
f2 = 5e3;


N = 100;
M = 2;
info = randint(1,10,M);

%%Freq 1
passo = ((2*length(info))/f1)/(length(info)*N);
info_format = rectpulse(info, N);
t = [0:passo:((2*length(info))/f1)-passo];
s_t_FSK_1 = (cos(2*pi*t*f1.*(info_format+1)));

subplot(411)
plot(t, s_t_FSK_1)
title('Freq 1 FSK')


%Freq 2
passo = ((2*length(info))/f2)/(length(info)*N);
info_format = rectpulse(info, N);
t = [0:passo:((2*length(info))/f2)-passo];
s_t_FSK_2 = (cos(2*pi*t*f2.*(info_format+1)));

subplot(412)
plot(t, s_t_FSK_2)
title('Freq 2 PSK')


%tem q terminar
