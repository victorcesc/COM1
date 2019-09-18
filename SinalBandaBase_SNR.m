clear all
close all
clc



limiar = 0;
N = 100; %numero de amostras por simbolo
M = 2; %niveis de transmissao(ex 2 bits(0 a 3 decimal) = 4 niveis, 3bits(0 a 7 decimal) = 8 niveis)
t_final = 5; %tempo em seg
Rb = 1e3; %taxa de transmissao
Rs = log2(M)/Rb; %taxa de simbolos
t_amos = [0:(1/(Rb*N)):t_final]; %tempo de amostragem, fa = Rb*N.

l = log2(M); %qtd de bits p/ nivel de transmissao - Rb = Rs*log2(M)
A = 1; %amplitude maxima - para aumentar a amplitude precisa-se fazer um calculo com relação a simetria dos niveis
dist_nivel = 2; %aqui podemos fazer uma divisao por 2 e pegar o resto pra verificar se o valor é simetrico em relação aos niveis.
SNR_min = 0;
SNR_max = 15; %relaçao sinal ruido em dB - quanto maior o valor SNR melhor o sinal.
SNR_vec = SNR_min:SNR_max;
num_simb = 10000;
info_bin = randi([0 1],1,(num_simb*l));
info_bin = transpose(reshape(info_bin, l,num_simb));


info = bi2de(info_bin,'left-msb')*dist_nivel - A; % mapeamento : 00 -> 0 -> -3V // 01 -> 1 -> -1V // 10 -> 2 -> 1V // 11 -> 3 -> 3V
info_up = upsample(info,N);
stem(info)
 
stem(info_up)
filtro_NRZ = ones(1,N);
figure(1)
stem(filtro_NRZ)
title('Filtro NRZ')


info_tx = filter(filtro_NRZ,1,info_up);%convolução do sinal com o filtro

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


%% recepção


info_ruido_rx = awgn(info_tx,SNR_max,'measured');
subplot(313)
plot(info_ruido_rx)
xlim([0 10*N])
title('Sinal recebido com ruido')


corte = 2*10e3/(Rb*N);
filtro_PB = fir1(50,corte);

%ruido
for SNR = SNR_min:SNR_max
    info_rx = awgn(info_tx,SNR_max,'measured');
    info_rx = filter(filtro_PB,1,info_rx);
    info_hat = info_rx(N/2:N:end) > limiar; %chave de amostragem//comparacao limiar
    num_erro(SNR + 1) = sum(xor(info_bin,info_hat))
    taxa_erro(SNR + 1) = num_erro(SNR+1)/length(info_bin)
end
   

figure(3)
semilogy(SNR_vec,taxa_erro)


