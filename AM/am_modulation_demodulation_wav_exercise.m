pkg load signal

passo = 1e-5; %passo da simulação
tempo_total = 10;  % tempo da simulação (em segundos)
t = 0:passo:tempo_total;

% CRIAR SINAL (y)
[Y,wav_fs] = audioread("teste.wav");
ywav = Y(:,1); % pegar só um canal

%y = Y(1:30000,1); % pegar primeiros valores (caso haja problemas de memória em pegar todos) e só um canal;
ywav = ywav'; 
wav_passo = 1/wav_fs;
twav = 0:wav_passo:wav_passo*(length(ywav)-1);

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
  
  %fft sinal filtrado
  [fx,Px]=fft_fun(x,passo);
%  figure(2)
%  plot(fx,Px);

% CRIAR PORTADORA (c)
  fc=10e3;
  c=1*sin(2*pi*fc*t);
  %fft portadora
  [fc,Pc]=fft_fun(c,passo);
  
  %figure(1)
  %plot(t,c);
  %figure(2)
  %plot(f,P), title('FFT portadora');
  
  
  

% CRIAR SINAL MODULADO (m)
  m=c.*x;
%fft sinal modulado
[fm,Pm]=fft_fun(m,passo);


% DEMODULAÇÃO - MIXER
  mixer = m.*c;
%fft mixer
  [fmx,Pmx]=fft_fun(mixer,passo);

% DEMODULAÇÃO - Filtro Passa Baixas
  Fs = 1/passo;
  cutoff_freq=3e3;
  Fnorm=2*cutoff_freq/Fs;
  [b,a]=butter(5,Fnorm);
  filtered=filter(b,a,mixer);
  d=filtered;
  
  %FFT Demodulado
  [fd,Pd]=fft_fun(d,passo);
  
%  figure(1)
%  subplot(3,1,1),plot(t,m), title('Sinal Modulado');
%  subplot(3,1,2),plot(t,d),title('Sinal demodulado');
%  subplot(3,1,3),plot(t,x), title('Sinal');
  
  
% Salvar saída em WAV
 audiowrite ("output.wav",d, 1/passo);

% PLOTAR PORTADORA
 subplot(5,2,1), plot(t,c), title('Portadora')
% ...
 subplot(5,2,2),plot(fc,Pc), title('FFT Portadora')
% ...

% PLOTAR SINAL ORIGINAL
 subplot(5,2,3), plot(t,x), title('Sinal')
% ...
 subplot(5,2,4), plot(fx,Px), title('FFT Sinal')
% ...

% PLOTAR SINAL MODULADO
 subplot(5,2,5), plot(t,m), title('Sinal Modulado')
% ...
 subplot(5,2,6), plot(fm,Pm), title('FFT Sinal Modulado')
% ...

% PLOTAR SINAL DEPOIS DO MIXER
  subplot(5,2,7), plot(t,mixer), title('Sinal Mixer')
% ...
  subplot(5,2,8), plot(fmx,Pmx), title('FFT Mixer')
% ...

% PLOTAR SINAL DEMODULADO
 subplot(5,2,9), plot(t,d), title('Sinal Demodulado')
% ...
 subplot(5,2,10), plot(fd,Pd), title('FFT Demodulado')
 ...
