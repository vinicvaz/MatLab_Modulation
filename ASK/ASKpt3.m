pkg load signal
% CRIAR SINAL (y)
  bitrate = 50;
  tbit=1/bitrate;
  tsample = 0.01*tbit;
  passo = tsample; %5000

  bitstream = [ 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1]
  bitstream1 = [ 0 1 0 1 0 0 0 0 0 1 0 1 0 0 1 1 1 1 0 0 0 0 0 0 1 1 1 0 0 0 1 1 1 1 1 0]
  bitstream2 = [ 1 0 1 0 1 1 1 1 1 0 1 0 1 1 0 0 0 0 1 1 1 1 1 1 0 0 0 1 1 1 0 0 0 0 0 1]
  
  t=0:tsample:tbit*length(bitstream);

  t = t(1:end-1);
  samples_per_bit = tbit/tsample;

  %bitstream0
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
  
  %bitstream1
  k=1;
  for i=1:length(bitstream1)
      for j=1:samples_per_bit
	  if (bitstream1(i)==0)            
	      y1(k) = 0;
	  else
	      y1(k) = 1;
	  end
	  k=k+1;
      end
  end
  
  %bitstream2
  k=1;
  for i=1:length(bitstream2)
      for j=1:samples_per_bit
	  if (bitstream2(i)==0)            
	      y2(k) = 0;
	  else
	      y2(k) = 1;
	  end
	  k=k+1;
      end
  end
  
  fc=500;
  fc1=1000;
  fc2=1500;
  % CRIAR PORTADORA (c)
  % ...
  c=sin(2*pi*fc*t);
  c1=sin(2*pi*fc1*t);
  c2=sin(2*pi*fc2*t);
  
  
  %plot(t,c);

  % CRIAR SINAL MODULADO (m)
  % ...
  m=y.*c;
  m1=y1.*c1;
  m2=y2.*c2;
  
  %soma dos sinais modulados
  m3=m+m1+m2;
 
 %  FFT's bitstream 0
 [f1,P1]=fft_fun(c,passo); %FFT DA PORTADORA
 [f2,P2]=fft_fun(y,passo); %FFT do sinal
 [f3,P3]=fft_fun(m,passo); %FFT do sinal modulado
  %%%%%%%%%%%%%FIGURA 1%%%%%%%%%%%%%%
  
  %PLOTS BITSTREAM 0
  subplot(3,2,1), plot(t,c), title('Portadora0'); % PLOTAR PORTADORA 0
  subplot(3,2,2), plot(f1,P1), title('FFT da Portadora'); %plotar fft da portadora
  subplot(3,2,3), plot(t,y,'g'), title('Sinal Digital'); %plotar sinal
  subplot(3,2,4), plot(f2,P2,'g'), title('FFT do Sinal'); % PLOTAR FFT DO SINAL
  subplot(3,2,5), plot(t,m), title('Sinal Modulado');  %PLOTAR SINAL MODULADO
  subplot(3,2,6),  plot(f3,P3), title('FFT do Sinal Modulado'); % PLOTAR FFT DO SINAL MODULADO
  
  %%%%%%%%%%%%%%FIGURA 2%%%%%%%%%%%%%%%%
  %  FFT's bitstream 1
 [f1,P1]=fft_fun(c1,passo); %FFT DA PORTADORA
 [f2,P2]=fft_fun(y1,passo); %FFT do sinal
 [f3,P3]=fft_fun(m1,passo); %FFT do sinal modulado
 
 figure(2)
 %PLOTS BITSTREAM 1
  subplot(3,2,1), plot(t,c1), title('Portadora1'); % PLOTAR PORTADORA 0
  subplot(3,2,2), plot(f1,P1), title('FFT da Portadora'); %plotar fft da portadora
  subplot(3,2,3), plot(t,y1,'g'), title('Sinal Digital'); %plotar sinal
  subplot(3,2,4), plot(f2,P2,'g'), title('FFT do Sinal'); % PLOTAR FFT DO SINAL
  subplot(3,2,5), plot(t,m1), title('Sinal Modulado');  %PLOTAR SINAL MODULADO
  subplot(3,2,6),  plot(f3,P3), title('FFT do Sinal Modulado'); % PLOTAR FFT DO SINAL MODULADO
  
  figure(3)
  %  FFT's bitstream 2
 [f1,P1]=fft_fun(c2,passo); %FFT DA PORTADORA
 [f2,P2]=fft_fun(y2,passo); %FFT do sinal
 [f3,P3]=fft_fun(m2,passo); %FFT do sinal modulado
 
 %PLOTS BITSTREAM 2
 subplot(3,2,1), plot(t,c2), title('Portadora2'); % PLOTAR PORTADORA 0
  subplot(3,2,2), plot(f1,P1), title('FFT da Portadora'); %plotar fft da portadora
  subplot(3,2,3), plot(t,y2,'g'), title('Sinal Digital'); %plotar sinal
  subplot(3,2,4), plot(f2,P2,'g'), title('FFT do Sinal'); % PLOTAR FFT DO SINAL
  subplot(3,2,5), plot(t,m2), title('Sinal Modulado');  %PLOTAR SINAL MODULADO
  subplot(3,2,6),  plot(f3,P3), title('FFT do Sinal Modulado'); % PLOTAR FFT DO SINAL MODULADO
  
  figure(4)
  %FFT da soma dos sinais modulados
  [f3,P3]=fft_fun(m3,passo); %FFT do sinal modulado
  
  %PLOTS SOMA DOS SINAIS MODULADOS
  subplot(2,1,1), plot(t,m3), title('Sinal Modulado');
  subplot(2,1,2), plot(f3,P3), title('FFT da soma dos Sinais Modulados'); %PLOTAR FFT DO SINAL MODULADO
  
  %filtros passa banda
 
  %filtrando modulado 1
  Fs = 1/passo;
  f1norm=2*450/Fs;
  f2norm=2*550/Fs
  [b,a]=butter(5,[f1norm,f2norm]);
  u=filter(b,a,m3);
  figure(10)
  plot(u);
  
 %filtrando modulado 2 (B=(1+d).S (s=bitrate)
  Fs = 1/passo;
  ff1norm=2*950/Fs;
  ff2norm=2*1050/Fs
  [b,a]=butter(5,[ff1norm,ff2norm]);
  u1=filter(b,a,m3);
  
  %filtrando modulado 3
  Fs = 1/passo;
  fff1norm=2*1450/Fs;
  fff2norm=2*1550/Fs
  [b,a]=butter(5,[fff1norm,fff2norm]);
  u2=filter(b,a,m3);
  
  
  
  %retificaçao
  r=max(0,u);
  r1=max(0,u1);
  r2=max(0,u2);
 
  
  %close all;
  %plot(r);
  
  %FILTROS 
  
  Fs = 1/passo;
  input=r;
  fcut=50;
  Fnorm=2*fcut/Fs;
  [b,a]=butter(7,Fnorm);
  
  
  x=filter(b,a,input);
  x1=filter(b,a,r1);
  x2=filter(b,a,r2);
 
  
  %plot(t,x);
  
  for i=1:length(x)
    if(x(i)>0.15)
      x(i)=1;
    else
      x(i)=0;
    end
  end
  
  for i=1:length(x1)
    if(x1(i)>0.15)
      x1(i)=1;
    else
      x1(i)=0;
    end
  end
  
  for i=1:length(x2)
    if(x2(i)>0.15)
      x2(i)=1;
    else
      x2(i)=0;
    end
  end
  
  %Plotar sinais demodulados
  figure(5)
  plot(t,x);
  figure(6)
  plot(t,x1);
  figure(7)
  plot(t,x2)
 