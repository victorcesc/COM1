%% Transformação da sequência binária em componentes em fase e quadratura
clear all; close all; clc;

n = 4; % log2(16); 16-QAM
l = 10000; % quantidade de bits;
N = 100;
symbols = l/n;

info = randi([0 1], symbols, 4);
info_sym = bi2de(info);
info_sym = reshape(info_sym, 1, symbols);
info_mod = qammod(info_sym, 16);
info_fase = real(info_mod);
info_quad = imag(info_mod);

info_fase = rectpulse(info_fase, N);
info_quad = rectpulse(info_quad, N);



subplot(411); plot(info_fase); axis([0 2500 -4 4]); title('Informação em fase');
subplot(412); plot(info_quad); axis([0 2500 -4 4]); title('Informação em quadratura');

%% Geração dos sinais de portadora
Fp = 30000; 
Fs = 250000;
Ts = 1/Fs;
Tp = 1/Fp; Tf = 1;
delta = Ts;
t = delta:delta:Tf;

Si = cos(2*pi*Fp*t);
Sq = sin(2*pi*Fp*t);

subplot(413); plot(Si); title('Portadora em fase'); axis([0 2500 -1.5 1.5]);
subplot(414); plot(Sq); title('Portadora em quadratura'); axis([0 2500 -1.5 1.5]);

%% Multiplicação dos sinais pelas portadoras, e soma das frequências em fase e quadratura

info_desl_fase = info_fase .* Si;
info_desl_quad = info_quad .* Sq;

info_out = info_desl_fase - info_desl_quad;

figure(2)
subplot(311); plot(info_desl_fase);title('Info Mult. em fase pela portadora');
subplot(312); plot(info_desl_quad);title('Info Mult. em quad pela portadora');
subplot(313); plot(info_out);title('Sinal Transmitido');





infodemod = qamdemod(info_out,16);
figure(3)
subplot(211);plot(infodemod); xlim([1 150])
subplot(212);plot(info); xlim([1 150])



