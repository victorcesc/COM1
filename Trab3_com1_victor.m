clear all
close all
clc


limiar = 0;
N = 10; %numero de amostras por simbolo
M = 2; %niveis de transmissao(ex 1bit(0 a 2 decimal) = 2 niveis ; 2 bits(0 a 3 decimal) = 4 niveis, 3bits(0 a 7 decimal) = 8 niveis)
l = log2(M); %qtd de bits p/ nivel de transmissao - Rb = Rs*log2(M)
A = 1; %amplitude maxima - para aumentar a amplitude precisa-se fazer um calculo com relação a simetria dos niveis
dist_nivel = 2; %aqui podemos fazer uma divisao por 2 e pegar o resto pra verificar se o valor é simetrico em relação aos niveis.

SNR_max = 10; %relaçao sinal ruido em dB - quanto maior o valor SNR melhor o sinal.

num_simb = 11;
info_bin = [0;1;1;0;1;0;1;1;0;1;0];
info_bin = transpose(reshape(info_bin, l,num_simb));
 

%info = bi2de(info_bin,'left-msb')*dist_nivel - A; % mapeamento para polar NRZ : 00 -> 0 -> -3V // 01 -> 1 -> -1V // 10 -> 2 -> 1V // 11 -> 3 -> 3V
info = bi2de(info_bin,'left-msb'); % mapeamento para unipolar RZ : 0 - 0V// 1 = 1V;
info_up = upsample(info,N);
stem(info_up)
filtro_tx = ones(1,N);
figure(1)
stem(filtro_tx)
title('Filtro NRZ')

info_tx = filter(filtro_tx,1,info_up);%convolução do sinal com o filtro

figure(2)
subplot(211)
stem(info_tx)
ylim([-2 2])
xlim([0 10*N])
title('Sinal Transmitido')

subplot(212)
plot(info_tx)
xlim([0 10*N])
ylim([-2 2])


%SNR = SNR_max - 10*(log10(N));
info_rx = awgn(info_tx, SNR_max,'measured');
figure(3)
subplot(211)
plot(info_rx)
xlim([0 10*N])
title(strcat('Sinal recebido com ruido SNR =', num2str(SNR_max)))


filtro_rx = fliplr(filtro_tx);
info_rx_filter = filter(filtro_tx,1,info_rx)/N;
subplot(212)
plot(info_rx_filter)
xlim([0 10*N])
title('Sinal pos filtro casado')

