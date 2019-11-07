pkg load signal
% CRIAR SINAL (y)
  bitrate = 50;
  tbit=1/bitrate;
  tsample = 0.01*tbit;
  passo = tsample; %5000

  bitstream = [ 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1]
  %bitstream1 = [ 0 1 0 1 0 0 0 0 0 1 0 1 0 0 1 1 1 1 0 0 0 0 0 0 1 1 1 0 0 0 1 1 1 1 1 0]
  %bitstream2 = [ 0 1 0 1 0 0 0 0 0 1 0 1 0 0 1 1 1 1 0 0 0 0 0 0 1 1 1 0 0 0 1 1 1 1 1 0]
  
  t=0:tsample:tbit*length(bitstream);

  t = t(1:end-1);
  samples_per_bit = tbit/tsample;

  k=1;
  for i=1:length(bitstream)
      for j=1:samples_per_bit
	  if (bitstream(i)==0)            
	      y(k) = 0;
	  else
	      y(k) = 1;
	  end
	  k=k+1;
      end
  end
  
  fc=500;

  % CRIAR PORTADORA (c)
  % ...
  c=sin(2*pi*fc*t);
  %plot(t,c);

  % CRIAR SINAL MODULADO (m)
  % ...
  m=y.*c;
 
  

  % PLOTAR PORTADORA
  subplot(3,2,1), plot(t,c), title('Portadora');
  % ...

  % PLOTAR FFT DA PORTADORA
  [f,P]=fft_fun(c,passo);
  %plot(f,P);
  subplot(3,2,2), plot(f,P), title('FFT da Portadora');
  % ...

  % PLOTAR SINAL
  subplot(3,2,3), plot(t,y), title('Sinal Digital');
  % ...
  
  % PLOTAR FFT DO SINAL
  [f,P]=fft_fun(y,passo);
  subplot(3,2,4), plot(f,P), title('FFT do Sinal');
  % ...

  % PLOTAR SINAL MODULADO
  subplot(3,2,5), plot(t,m), title('Sinal Modulado');
  % ...

  % PLOTAR FFT DO SINAL MODULADO
  [f,P]=fft_fun(m,passo);
  subplot(3,2,6),  plot(f,P), title('FFT do Sinal Modulado');
  % ...
  
  %retificaçao
  r=max(0,m);
  %close all;
  %plot(r);
  
  Fs = 1/passo;
  input=r;
  fcut=50;
  Fnorm=2*fcut/Fs;
  [b,a]=butter(7,Fnorm);
  
  x=filter(b,a,input);
  
  %plot(t,x);
  
  for i=1:length(x)
    if(x(i)>0.1)
      x(i)=1;
    else
      x(i)=0;
    end
  end
  
  %plot(t,x);
  
  
  
  
 
  
