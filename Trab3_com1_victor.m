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


%info = bi2de(info_bin,'left-msb')*dist_nivel - A; 
info = bi2de(info_bin,'left-msb'); % mapeamento para unipolar RZ : 0 - 0V// 1 = 1V;
info_up = upsample(info,N);
figure(1)
subplot(211)
stem(info_up)
xlim([0 N*length(info)])
title('Informação antes do filtro NRZ')
filtro_tx = ones(1,N);
subplot(212)
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


SNR = SNR_max - (10*(log10(N)));
info_rx = awgn(info_tx, SNR,'measured');
figure(3)
subplot(211)
plot(info_rx)
xlim([0 10*N])
title(strcat('Sinal recebido com ruido SNR =', num2str(SNR_max)))


filtro_rx = fliplr(filtro_tx);%filtro casado
info_rx_filter = filter(filtro_tx,1,info_rx)/N;
subplot(212)
plot(info_rx_filter)
xlim([0 10*N])
title('Sinal pos filtro casado')






%% Parte 2
clear all
close all
clc


limiar = 0;
N = 10; %numero de amostras por simbolo
M = 2; %niveis de transmissao(ex 1bit(0 a 2 decimal) = 2 niveis ; 2 bits(0 a 3 decimal) = 4 niveis, 3bits(0 a 7 decimal) = 8 niveis)
l = log2(M); %qtd de bits p/ nivel de transmissao - Rb = Rs*log2(M)
A = 1; %amplitude maxima - para aumentar a amplitude precisa-se fazer um calculo com relação a simetria dos niveis
dist_nivel = 2;
Rb = 1e3;
Rs = Rb/1;
SNR_min = 0;
SNR_max = 10; %relaçao sinal ruido em dB - quanto maior o valor SNR melhor o sinal.
SNR_vec = [SNR_min:SNR_max];
t_final = 5;
t = [0:(1/(Rb*N)):t_final-((1/(Rb*N)))];
num_simb = Rs*t_final;
info_bin = randi([0 1],1, num_simb*l);
info_bin = transpose(reshape(info_bin, l,num_simb));





info = bi2de(info_bin,'left-msb'); % mapeamento para unipolar RZ : 0 - 0V// 1 = 1V;
info_up = upsample(info,N);
figure(1)
subplot(211)
stem(info_up)
xlim([0 N*length(info)])
title('Informação sem o filtro NRZ')
filtro_tx = ones(1,N);
subplot(212)
stem(filtro_tx)
title('Filtro NRZ')

info_tx = filter(filtro_tx, 1, info_up);

figure(2)
subplot(311)
stem(info_tx)
ylim([-2 2])
xlim([0 10*N])
title('Sinal Transmitido')

subplot(312)
plot(info_tx)
xlim([0 10*N])
ylim([-2 2])


info_ruido_rx = awgn(info_tx,SNR_max,'measured');
subplot(313)
plot(info_ruido_rx)
xlim([0 10*N])
title('Sinal recebido com ruido')

filtro_rx = fliplr(filtro_tx);%filtro casado

for SNR = SNR_min:SNR_max
    info_rx = awgn(info_tx, SNR-(log10(N)));
    info_rx_filter = filter(filtro_rx, 1, info_rx)/N;
    info_hat = info_rx_filter(N:N:end) > limiar;
    num_erro(SNR+1) = sum(xor(info_bin, info_hat));
    taxa_erro(SNR+1) = num_erro(SNR+1)/length(info_bin);
end

figure(3)
subplot(311)
plot(t, info_tx)
xlim([0 10e-3])
title('Informação transmitida')

subplot(312)
plot(t, info_rx)
xlim([0 10e-3])
title('Informação recebida')

subplot(313)
plot(t, info_rx_filter)
xlim([0 10e-3])
title('Informação recebida pós-filtro casado')

figure(4)
semilogy(SNR_vec, taxa_erro)
title('Taxa de erros por SNR')











%% Conclusão
%  A relação sinal ruido(SNR) em 10dB causa uma distorção do sinal muito
%  alta, causando muita perda de informação.
%  Utilizando o filtro casado, podemos melhorar a recepção da informação
%  suavizando o sinal, nota-se que é de melhor visualização o grafico
%  pós-filtro casado.
%  
% 

