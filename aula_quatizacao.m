clear all
close all
clc

Fs = 44.1e3;
f1 = 1e3;
k = 3;
L = 2^k;%numero de niveis
A = 1;
%t = [0:1/Fs:3/f1];
t = [0:1/Fs:5];

%Quantização
y = A*cos(2*pi*f1*t);
passo_q = (2*A) / L;% passo de quantiz 2*1/(numero de niveis)

y_quant = y/passo_q;% dividindo pelo passo, para deixar as amostras proximas aos niveis
y_quant = y_quant + (L/2) - 1e-5; %pra nao passar de 8
y_quant_tx = fix(y_quant); % ajustando o sinal para se enquadrar no numero de niveis

figure(3)
plot(y_quant_tx)
xlim([0 200]); %sinal quantizado
%y_unquant= (y_quant*passo_q) - A;%digital -> analog

%codificacao
y_bin = de2bi(y_quant_tx);
[lin_y , col_y] = size(y_bin);
y_bin_s = reshape(y_bin,1,lin_y*col_y);


%% espera

Y = fftshift(fft(y));
Y_un = fftshift(fft(y_quant_tx));

f = [-Fs/2:1/5:Fs/2];
filtro = fir1(10, (2*1500)/Fs);
y_filter = filter(filtro, 1, y_quant_tx);
Y_filter = fftshift(fft(y_filter));

figure(1)
plot(t,y_quant_tx)
xlim([0 2/f1])
hold on

plot(t, y)
xlim([0 2/f1])
hold on
plot(t, y_filter)
figure(2)
subplot(311)
plot(f,abs(Y))
subplot(312)
plot(f, abs(Y_un))

subplot(313)
plot(f, abs(Y_filter))


