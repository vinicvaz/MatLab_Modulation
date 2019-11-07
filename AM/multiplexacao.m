pkg load signal

passo = 1e-5; %passo da simulação
tempo_total = 10;  % tempo da simulação (em segundos)
t = 0:passo:tempo_total;

% CRIAR SINAL (y)
[Y,wav_fs] = audioread("teste.wav");
ywav = Y(:,1); % pegar só um canal

%CRIAR SINAL 2 (y2)
[Y2, wav_fs2] = audioread("teste2.wav");
y2wav = Y2(:,1);

%y = Y(1:30000,1); % pegar primeiros valores (caso haja problemas de memória em pegar todos) e só um canal;
ywav = ywav'; 
wav_passo = 1/wav_fs;
twav = 0:wav_passo:wav_passo*(length(ywav)-1);

y2wav = y2wav'; 
wav_passo2 = 1/wav_fs2;
t2wav = 0:wav_passo2:wav_passo2*(length(y2wav)-1);

% converter para passo do WAV para passo da simulação
k = 1;
for i=1:length(t) 
    if (k>=length(ywav))
       y(i) = 0;
    else
        if (twav(k) < t(i))
      	    k = k + 1;
        end  
        y(i) = ywav(k);
    end
end

% converter para passo do WAV para passo da simulação 2
k = 1;
for i=1:length(t) 
    if (k>=length(y2wav))
       y2(i) = 0;
    else
        if (t2wav(k) < t(i))
      	    k = k + 1;
        end  
        y2(i) = y2wav(k);
    end
end

%figure(1)
%plot(t,y2);

[f0,P0] = fft_fun(y,passo);
%figure(1)
%plot(f0,P0);

% Restringir sinal a aprox. 2 kHz
  Fs = 1/passo;
  cutoff_freq=2e3;
  Fnorm=2*cutoff_freq/Fs;
  [b,a]=butter(5,Fnorm);
  filtered=filter(b,a,y);
  x=filtered;
  
  % Restringir sinal 2 a aprox. 2 kHz
  Fs = 1/passo;
  cutoff_freq=2e3;
  Fnorm=2*cutoff_freq/Fs;
  [b,a]=butter(5,Fnorm);
  filtered=filter(b,a,y2);
  x2=filtered;
  
  %fft sinal filtrado
  [fx,Px]=fft_fun(x,passo);
  [fx2,Px2]=fft_fun(x2,passo);
%  figure(2)
%  plot(fx,Px);

% CRIAR PORTADORA (c)
  fc=5000;
  c=1*sin(2*pi*fc*t);
  %fft portadora
  [fc,Pc]=fft_fun(c,passo);
  
  
  %CRIAR PORTADORA 2
  fc2 = 10000;
  c2=1*sin(2*pi*fc2*t);
  [fc2,Pc2]=fft_fun(c2,passo);
  %figure(1)
  %plot(t,c);
  %figure(2)
  %plot(f,P), title('FFT portadora');
  
  
  

% CRIAR SINAL MODULADO (m)
  m=c.*x;
%fft sinal modulado
[fm,Pm]=fft_fun(m,passo);

% CRIAR MODULADO 2
  m2=c2.*x2;
[fm2,Pm2]=fft_fun(m2,passo);  
  %SOMA DOS SINAIS
  
  m3=m+m2;
  
  
  
  
  
  
%  plot(t,m3);




%fft mixer
  
 
  
  %FILTRO PASSA BANDA
  Fs = 1/passo;
  ff1norm=2*3500/Fs;
  ff2norm=2*7500/Fs;
  [b,a]=butter(5,[ff1norm,ff2norm]);
  u=filter(b,a,m3);    

  Fs = 1/passo;
  ff1norm=2*8500/Fs;
  ff2norm=2*11500/Fs;
  [b,a]=butter(5,[ff1norm,ff2norm]);
  u2=filter(b,a,m3); 
  
  % DEMODULAÇÃO - MIXER
  mixer = u.*c;
  
  %MIXER 2
  mixer2=u2.*c2;
  %FFT mixer
  [fmx,Pmx]=fft_fun(mixer,passo);
  [fmx2,Pmx2]=fft_fun(mixer2,passo);
  
% DEMODULAÇÃO - Filtro Passa Baixas
  Fs = 1/passo;
  cutoff_freq=3e3;
  Fnorm=2*cutoff_freq/Fs;
  [b,a]=butter(5,Fnorm);
  filtered=filter(b,a,mixer);
  d=filtered;
  
  Fs = 1/passo;
  cutoff_freq=3e3;
  Fnorm=2*cutoff_freq/Fs;
  [b,a]=butter(5,Fnorm);
  filtered=filter(b,a,mixer2);
  d2=filtered;
  
  %FFT Demodulado
  [fd,Pd]=fft_fun(d,passo);
  [fd2,Pd2]=fft_fun(d2,passo);
  
%  figure(1)
%  subplot(3,1,1),plot(t,m), title('Sinal Modulado');
%  subplot(3,1,2),plot(t,d),title('Sinal demodulado');
%  subplot(3,1,3),plot(t,x), title('Sinal');
  
  
% Salvar saída em WAV
 audiowrite ("output.wav",d, 1/passo);
 audiowrite ("saida2.wav",d2, 1/passo);

% figure(1)
% plot(t,d),title('demodulado');
% figure(2)
% plot(t,x),title('sinal 1');
% figure(3)
% plot(t,d2),title('demodulado');
% figure(4)
% plot(t,x2), title('sinal 2');
 
 figure(1)
% PLOTAR PORTADORA
 subplot(5,2,1), plot(t,c), title('Portadora 1')
% ...
 subplot(5,2,2),plot(fc,Pc), title('FFT Portadora 1')
% ...

% PLOTAR SINAL ORIGINAL
 subplot(5,2,3), plot(t,x), title('Sinal 1')
% ...
 subplot(5,2,4), plot(fx,Px), title('FFT Sinal 1')
% ...

% PLOTAR SINAL MODULADO
 subplot(5,2,5), plot(t,m), title('Sinal Modulado 1')
% ...
 subplot(5,2,6), plot(fm,Pm), title('FFT Sinal Modulado 1')
% ...

% PLOTAR SINAL DEPOIS DO MIXER
  subplot(5,2,7), plot(t,mixer), title('Sinal Mixer 1')
% ...
  subplot(5,2,8), plot(fmx,Pmx), title('FFT Mixer 1')
% ...

% PLOTAR SINAL DEMODULADO
 subplot(5,2,9), plot(t,d), title('Sinal Demodulado 1')
% ...
 subplot(5,2,10), plot(fd,Pd), title('FFT Demodulado 1')
 ...
figure(2)
 subplot(5,2,1), plot(t,c), title('Portadora 1')
% ...
 subplot(5,2,2),plot(fc,Pc), title('FFT Portadora 1')
% ...

% PLOTAR SINAL ORIGINAL
 subplot(5,2,3), plot(t,x2), title('Sinal 2')
 subplot(5,2,4), plot(fx2,Px2), title('FFT Sinal 2')
% ...

% PLOTAR SINAL MODULADO
 subplot(5,2,5), plot(t,m2), title('Sinal Modulado 2')
 subplot(5,2,6), plot(fm2,Pm2), title('FFT Sinal Modulado 2')

% PLOTAR SINAL DEPOIS DO MIXER
  subplot(5,2,7), plot(t,mixer2), title('Sinal Mixer 2')
% ...
  subplot(5,2,8), plot(fmx2,Pmx2), title('FFT Mixer 2')
% ...

% PLOTAR SINAL DEMODULADO
 subplot(5,2,9), plot(t,d2), title('Sinal Demodulado 2')
% ...
 subplot(5,2,10), plot(fd2,Pd2), title('FFT Demodulado 2')
 
 figure(3)
 plot(t, m3), title('Soma dos Sinais')
 
