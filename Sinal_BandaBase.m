clear all
close all
clc

N = 100;
M = 2; %niveis de transmissao(ex 2 bits(0 a 3 decimal) = 4 niveis, 3bits(0 a 7 decimal) = 8 niveis)
l = log2(M); %qtd de bits p/ nivel de transmissao - Rb = Rs*log2(M)
A = 1; %amplitude maxima - para aumentar a amplitude precisa-se fazer um calculo com relação a simetria dos niveis
dist_nivel = 2; %aqui podemos fazer uma divisao por 2 e pegar o resto pra verificar se o valor é simetrico em relação aos niveis.
num_simb = 10000;
info_bin = randint(1,(num_simb*l));
info_bin = transpose(reshape(info_bin, l,num_simb));


info = bi2de(info_bin,'left-msb')*dist_nivel - A; % mapeamento : 00 -> 0 -> -3V // 01 -> 1 -> -1V // 10 -> 2 -> 1V // 11 -> 3 -> 3V
info_up = upsample(info,N);
stem(info)
 
stem(info_up)
filtro_NRZ = ones(1,N);
figure(1)
stem(filtro_NRZ)

info_tx = filter(filtro_NRZ,1,info_up);%convolução do sinal com o filtro

figure(2)
subplot(211)
stem(info_tx)
ylim([0 2])


subplot(212)
plot(info_tx)
xlim([0 10*N])

v = 1.65; %quanto maior a variancia maior o ruido
%adicionando ruido
ruido = v.*randn(length(info_tx),1); %variancia*rndn + media;
figure(3)
hist(ruido,100)

%No_2 = 0.1;
info_rx = info_tx + ruido;
figure(4)
plot(info_rx)
xlim([0 10*N])



% receptor
limiar = 0;
figure(5)
info_hat = info_rx(N/2:N:end) > limiar;
stem(info_hat)

%taxa de erro

num_erro = sum(xor(info_bin,info_hat))
taxa_erro = num_erro/length(info_bin)




%% gaussiana
%media
mean(ruido)
%variancia
var(ruido)
%desvio padrao
std(ruido)
