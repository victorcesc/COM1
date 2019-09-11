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
Ao = 3; 
s_t_1 = m_t.*c_t;% AM-DSB-SC
m_t_dsb = m_t+Ao;
s_t_2 = (m_t_dsb).*c_t; %AM-DSB

figure(1)
plot(t,m_t)
xlim([0 1e-2])

figure(2)
plot(t,c_t)
xlim([0 1e-2])

figure(3)
plot(t, s_t_1)
hold on
plot(t,m_t)
xlim([0 0.1e-2])
title('AM-DSB-SC')

figure(4)
plot(t,s_t_2)
hold on
plot(t,m_t_dsb)
xlim([0 0.1e-2])
title('AM-DSB')







