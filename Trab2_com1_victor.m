clear all
close all
clc

%freq de amostragem
fa = 200e3;
t = [0:1/fa:1]; % periodo
f1 = 1e3;
f2 = 2e3;
f3 = 3e3;
w1 = 2*pi*f1;
w2 = 2*pi*f2;
we = 2*pi*f3;
%amplitudes
A = 1;
Ac = 1;

%sinal 
mt1 = A*cos(w1*t);
mt2 = A*cos(w2*t);
mt3 = A*cos(w3*t);

%portadora
fc1 = 10e3;
fc2 = 12e3;
fc3 = 14e3;
wc1 = 2*pi*fc1;
wc2 = 2*pi*fc2;
wc3 = 2*pi*fc3;
ct1 = Ac*cos(wc1*t);
ct2 = Ac*cos(wc2*t);
ct3 = Ac*cos(wc3*t);


%modulacao

st1 = mt1.*ct1;
st2 = mt2.*ct2;
st3 = mt3.*ct3;


figure(1)
subplot(611)
plot(t,mt1)
xlim([0 1e-2])

subplot(612)
plot(t,ct1)
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



