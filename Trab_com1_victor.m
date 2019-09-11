clear all
close all
clc

%freq de amostragem
fa = 200e3;
t = [0:1/fa:1]; % periodo
f1 = 1e3;
w = 2*pi*f1;

%amplitudes
A = 3;
Ac = 1;

%sinal
m_t = A*cos(w*t);

%portadora
fc = 10e3;
wc = 2*pi*fc;
c_t = Ac*cos(wc*t);

%modulacao
Ao = 3; %constante
s_t_1 = m_t.*c_t;% AM-DSB-SC
m_t_dsb = m_t+Ao; % sinal deslocado dsb
s_t_2 = (m_t_dsb).*c_t; %AM-DSB

figure(1)
subplot(411)
plot(t,m_t)
xlim([0 1e-2])

subplot(412)
plot(t,c_t)
xlim([0 1e-2])

subplot(413)
plot(t, s_t_1)
hold on
plot(t,m_t)
xlim([0 0.1e-2])
ylim([-3 3])
title('AM-DSB SC')

subplot(414)
plot(t,s_t_2)
hold on
plot(t,m_t_dsb)
xlim([0 0.1e-2])
ylim([-6 6])
title('AM-DSB')

%% demodulação AM-DSB SC

freq = -fa/2:fa/2;

s_t_d = s_t_1.*c_t; 

S_f_d = fftshift(fft(s_t_d));%fft tempo -> Freq

filtro = fir1(50, (2e3)/fa);%criando filtro

s_dsbsc = filter(filtro, 1, s_t_d); %filtrando sinal demodulado s_t_d

S_dsbsc = fftshift(fft(s_dsbsc));

figure(2)
subplot(411)
plot(t,m_t)

subplot(412)
plot(t,s_dsbsc)

subplot(413)
plot(freq,abs(S_f_d))
xlim([-2e3 2e3])

subplot(414)
plot(freq,abs(S_dsbsc))
xlim([-2e3 2e3])



%% fator de modulacao AM-DSB

% FATORES DE MODULAÇÃO
fator = [0.25 0.5 0.75 1 1.15];
figure(3)
sub = 510;
for n = 1:5        
    subplot(sub+n)
    s_t_1 = (1+fator(n)*m_t).*c_t;
    plot(t,s_t_1)
    xlim([0 .001]);
    title(fator(n))
end









