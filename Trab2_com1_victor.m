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
w3 = 2*pi*f3;
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


subplot(613)
plot(t,mt2)
xlim([0 1e-2])

subplot(614)
plot(t,ct2)
xlim([0 1e-2])


subplot(615)
plot(t,mt3)
xlim([0 1e-2])

subplot(616)
plot(t,ct3)
xlim([0 1e-2])


figure(2)
subplot(311)
plot(t,st1)
xlim([0 1e-2])

subplot(312)
plot(t,st2)
xlim([0 1e-2])

subplot(313)
plot(t,st3)
xlim([0 1e-2])


Sf1 = fftshift(fft(st1));
Sf2 = fftshift(fft(st2));
Sf3 = fftshift(fft(st3));


freq = -fa/2:fa/2;

figure(3)
subplot(311)
plot(freq,abs(Sf1))
xlim([-18e3 18e3])

subplot(312)
plot(freq,abs(Sf2))
xlim([-18e3 18e3])

subplot(313)
plot(freq,abs(Sf3))
xlim([-18e3 18e3])

%filtrando s1 s2 s3

filtro_PF1 = [zeros(1,88000) ones(1,2000) zeros(1,20000) ones(1,2000) zeros(1,88001)];
filtro_PF2 = [zeros(1,85000) ones(1,2000) zeros(1,26000) ones(1,2000) zeros(1,85001)];
filtro_PF3 = [zeros(1,81500) ones(1,2000) zeros(1,33000) ones(1,2000) zeros(1,81501)];


figure(4)
subplot(311)
plot(freq,filtro_PF1)
xlim([-20000 20000])

subplot(312)
plot(freq,filtro_PF2)
xlim([-20000 20000])

subplot(313)
plot(freq,filtro_PF3)
xlim([-20000 20000])

Sf1 = Sf1.*filtro_PF1;
Sf2 = Sf2.*filtro_PF2;
Sf3 = Sf3.*filtro_PF3;

figure(5)
subplot(311)
plot(freq,abs(Sf1))
xlim([-18e3 18e3])

subplot(312)
plot(freq,abs(Sf2))
xlim([-18e3 18e3])

subplot(313)
plot(freq,abs(Sf3))
xlim([-20e3 20e3])

%soma as componentes filtradas



%demodula cada componente pela portadora original

figure(6)
sinal_f = Sf1+Sf2+Sf3;
plot(freq,abs(sinal_f))


s_t1 = ifft(Sf1).*ct1;
s_t2 = ifft(Sf2).*ct2;
s_t3 = ifft(Sf3).*ct3;

Sf1 = fft(s_t1);
Sf2 = fft(s_t2);
Sf3 = fft(s_t3);
SFfinal = Sf1+Sf2+Sf3;

figure(7)
subplot(411)
plot(freq,abs(Sf1))
subplot(412)
plot(freq,abs(Sf2))
subplot(413)
plot(freq,abs(Sf3))
subplot(414)
plot(freq,abs(SFfinal))


%passa baixa para recuperar o sinal original

filtro_PB1 = [zeros(1,96000) ones(1,8000) zeros(1,96001)];
Sf_filtrado = filtro_PB1.*SFfinal;

figure(8)
subplot(211)
plot(freq,abs(Sf_filtrado))


St_filtrado = ifft(Sf_filtrado);
subplot(212)
plot(t,St_filtrado)

%passa faixa para separar os sinais originais

filtro_PF1 = [zeros(1,98500)  ones(1,1000) zeros(1,1000) ones(1,1000)  zeros(1,98501)];
filtro_PF2 = [zeros(1,97500) ones(1,1000) zeros(1,3000) ones(1,1000) zeros(1,97501)];
filtro_PF3 = [zeros(1,96500) ones(1,1000) zeros(1,5000) ones(1,1000) zeros(1,96501)];

figure(9)
plot(freq,filtro_PF1)

mf1 = Sf_filtrado.*filtro_PF1;

mt1 = ifft(mf1);
subplot(611)
plot(t,mt1)
xlim([0 0.01])
subplot(612)
plot(freq,abs(mf1))

mf2 = Sf_filtrado.*filtro_PF2;

mt2 = ifft(mf2);

subplot(613)
plot(t,mt2)
xlim([0 0.01])
subplot(614)
plot(freq,abs(mf2))

mf3 = Sf_filtrado.*filtro_PF3;

mt3 = ifft(mf3);

subplot(615)
plot(t,mt3)
xlim([0 0.01])
subplot(616)
plot(freq,abs(mf3))
 
