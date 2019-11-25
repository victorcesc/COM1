clear all
close all
clc
% DA para fazer o teste com outras mod aqui!

N = 100;
M = 16;%nivel de modulaçao 16 = 16 pontos na constelação = 16 simbolos diferentes

SNR = 10;
info = randi([0 M-1],1,100e3);
infomod = qammod(info,M);
scatterplot(infomod)
title('info modulada')
inforx = awgn(infomod,SNR);
scatterplot(inforx)
title('info transmitida')
infodemod = qamdemod(inforx,M);
[num,taxa] = symerr(info,infodemod);