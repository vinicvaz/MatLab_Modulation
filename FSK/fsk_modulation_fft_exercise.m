pkg load signal
% CRIAR SINAL (y)
bitrate = 50;
tbit=1/bitrate;
tsample = 0.001*tbit;
passo = tsample;

%bitstream = [ 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1]
bitstream = [ 0 1 0 1 0 0 0 0 0 1 0 1 0 0 1 1 1 1 0 0 0 0 0 0 1 1 1 0 0 0 1 1 1 1 1 0]

t=0:tsample:tbit*length(bitstream);

t = t(1:end-1);
samples_per_bit = tbit/tsample;

k=1;
for i=1:length(bitstream)
    for j=1:samples_per_bit
	if (bitstream(i)==0)            
	    y(k) = -1;
	else
	    y(k) = 1;
	end
	k=k+1;
    end
end


% CRIAR PORTADORA DO SINAL DE ORIGEM (c)
fc=500;
amplitude=5;
c=amplitude*sin(2*pi*fc*t);

% CRIAR SINAL MODULADO (m)
deltaf=fc/2;
m=amplitude*sin(2*pi.*(fc+deltaf*y).*t);
% PLOTAR PORTADORA
subplot(3,2,1), plot(t,c), title('Portadora');

% PLOTAR FFT DA PORTADORA
[f1,P1]=fft_fun(c,passo);
subplot(3,2,2), plot(f1,P1), title('FFT da Portadora');

% PLOTAR SINAL
subplot(3,2,3), plot(t,y), title('Sinal');

% PLOTAR FFT DO SINAL
[f2,P2] = fft_fun(y,passo);
subplot(3,2,4), plot(f2,P2), title('FFT do Sinal');

% PLOTAR SINAL MODULADO
subplot(3,2,5), plot(t,m), title('Sinal Modulado');

% PLOTAR FFT DO SINAL MODULADO
[f3,P3] = fft_fun(m,passo);
subplot(3,2,6), plot(f3,P3), title('FFT do Sinal Modulado');


