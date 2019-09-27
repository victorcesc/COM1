clear all
close all
clc

N = 10; % número de amostras por símbolo
M = 2;
t_final = 5; % em segundos
Rb = 1e3; % taxa de transmissão
l = log2(M);
Rs = Rb/l;
A = 1 % amplitude máxima
t = [0:(1/(Rb*N)):t_final-((1/(Rb*N)))];
limiar = A/2;
SNR_min = 0;
SNR_max = 10;
SNR_vec = [SNR_min:SNR_max];
filtro_tx = ones(1,N);
filtro_rx = fliplr(filtro_tx);
num_simb = Rs*t_final;
info_bin = randi([0 1],1, num_simb*l);
info_bin = transpose(reshape(info_bin, l, num_simb));
info = bi2de(info_bin, 'left-msb')*A;
info_up = upsample(info, N);




figure(1)
stem(filtro_tx)
title('Filtro NRZ')
%info_tx = filter(filtro_NRZ,1,info_up);%convolução do sinal com o filtro

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
