pkg load signal
clc
clear all
    % CRIAR SINAL (y)
    bitrate = 50;
    tbit=1/bitrate;
    tsample = 0.001*tbit;
    passo = tsample;
    Fs = 1/tsample;
    
    bitstream0 = [ 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1]
    bitstream1 = [ 0 1 0 1 0 0 0 0 0 1 0 1 0 0 1 1 1 1 0 0 0 0 0 0 1 1 1 0 0 0 1 1 1 1 1 0]
    bitstream2 = [ 1 0 1 0 1 1 1 1 1 0 1 0 1 1 0 0 0 0 1 1 1 1 1 1 0 0 0 1 1 1 0 0 0 0 0 1]
    

    t=0:tsample:tbit*length(bitstream0);

    t = t(1:end-1);
    samples_per_bit = tbit/tsample;
    
    %bitstream0
    k=1;
  for i=1:length(bitstream0)
	  for j=1:samples_per_bit
	    if (bitstream0(i)==0)            
		    y0(k) = -1;
	    else
		    y0(k) = 1;
	    end
	    k=k+1;
	  end
  end
  
    %bitstream1
    k=1;
  for i=1:length(bitstream1)
	  for j=1:samples_per_bit
	    if (bitstream1(i)==0)            
		    y1(k) = -1;
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
		    y2(k) = -1;
	    else
		    y2(k) = 1;
	    end
	    k=k+1;
	  end
  end
 
  
    % CRIAR PORTADORA DO SINAL DE ORIGEM (c)
    
    %portadora0
    fc0=500;
    amplitude0=5;
    c0=amplitude0*sin(2*pi*fc0*t);
    
    %portadora1
    fc1=1000;
    amplitude1=5;
    c1=amplitude1*sin(2*pi*fc1*t);
  
    %pordaroa2
    fc2=1500;
    amplitude2=5;
    c2=amplitude2*sin(2*pi*fc2*t); 
     
    % CRIAR SINAL MODULADO (m)
    
    %modulado 0
    deltaf0=100;   %% 2deltaf >= S/2 (S = bitrate)
    m0=amplitude0*sin(2*pi.*(fc0+deltaf0*y0).*t);
   
    %modulado 1
    deltaf1=100;
    m1=amplitude1*sin(2*pi.*(fc1+deltaf1*y1).*t); 
    
    %modulado 2
    deltaf2=100;
    m2=amplitude2*sin(2*pi.*(fc2+deltaf2*y2).*t); 
    
%    figure(1)
%   subplot(3,1,1), plot(t,m0),title('Sinal Modulado 1');
%   subplot(3,1,2), plot(t,m1), title('Sinal Modulado2');
%   subplot(3,1,3), plot(t,m2), title('Sinal Modulado 3');
    
%   %soma dos modulados
%    m3=m0+m1+m2;
%    
%    
%     %filtrando modulado 1
%  Fs = 1/passo;
%  f1norm=2*500/Fs;
%  f2norm=2*1500/Fs
%  [b,a]=butter(5,[f1norm,f2norm]);
%  u0=filter(b,a,m3);
%  
%  
% 
%  
% %filtrando modulado 2 (B=(1+d).S (s=bitrate)
%  Fs = 1/passo;
%  ff1norm=2*2000/Fs;
%  ff2norm=2*3000/Fs
%  [b,a]=butter(5,[ff1norm,ff2norm]);
%  u1=filter(b,a,m3);
%  
%  %filtrando modulado 3
%  Fs = 1/passo;
%  fff1norm=2*3500/Fs;
%  fff2norm=2*5000/Fs
%  [b,a]=butter(5,[fff1norm,fff2norm]);
%  u2=filter(b,a,m3);

%  figure(2)
%  subplot(3,1,1), plot(t,u0),title('Sinal 1 Modulado (passa banda)');
%  subplot(3,1,2), plot(t,u1), title('Sinal 2 Modulado');
%  subplot(3,1,3), plot(t,u2), title('Sinal 3 Modulado');

%  [f1,P1]=fft_fun(m0,passo);
%  [f2,P2]=fft_fun(m1,passo);
%  [f3,P3]=fft_fun(m2,passo);
%  
%  figure(1)
%  subplot(3,1,1), plot(f1,P1),title('fft');
%  subplot(3,1,2), plot(f2,P2), title('fft m');
%  subplot(3,1,3), plot(f3,P3), title('fft');
%  
%  [f4,P4]=fft_fun(u0,passo);
%  [f5,P5]=fft_fun(u1,passo);
%  [f6,P6]=fft_fun(u2,passo);
%  figure(2)
%  subplot(3,1,1), plot(f4,P4),title('fft');
%  subplot(3,1,2), plot(f5,P5), title('fft u');
%  subplot(3,1,3), plot(f6,P6), title('fft');
    
    
    % DEMODULAR
    filtered_value0 = 0;
    filtered_value1 = 0;
    filtered_value2 = 0;
    for i=1:length(m0)
      %VCO 0 
      fvco0 = fc0+deltaf0*10*filtered_value0(i);
      vco0(i) = sin(2*pi*fvco0*t(i));
      
      %VCO 1
      fvco1 = fc1+deltaf1*10*filtered_value1(i);
      vco1(i) = sin(2*pi*fvco1*t(i));
      
      %VCO 2
      fvco2 = fc2+deltaf2*10*filtered_value2(i);
      vco2(i) = sin(2*pi*fvco2*t(i));
      
        % phase detector 0
        input_pll0(i)=(m0(i)>=0);
        vco_abs0(i) = (vco0(i)>=0);
        phase_detector0(i) = vco_abs0(i) - input_pll0(i);
        
        % phase detector 1
        input_pll1(i)=(m1(i)>=0);
        vco_abs1(i) = (vco1(i)>=0);
        phase_detector1(i) = vco_abs1(i) - input_pll1(i);
        
        % phase detector 2
        input_pll2(i)=(m2(i)>=0);
        vco_abs2(i) = (vco2(i)>=0);
        phase_detector2(i) = vco_abs2(i) - input_pll2(i);
        
	      % low pass 0
        filtered_value0(i+1) = 1*filtered_value0(i) + (1e-1)*(phase_detector0(i));
        %filtered_value0(i+1) = 1*filtered_value0(i) + 0.5*(phase_detector0(i));
        
        % low pass 1
        filtered_value1(i+1) = 1*filtered_value1(i) + (1e-1)*(phase_detector1(i));
        %filtered_value1(i+1) = 1*filtered_value1(i) + 0.5*(phase_detector1(i));
        
        % low pass 1
        filtered_value2(i+1) = 1*filtered_value2(i) + (1e-1)*(phase_detector2(i));
        %filtered_value2(i+1) = 1*filtered_value2(i) + 0.5*(phase_detector2(i));
      end
      
      %0
      filtered_value0 = filtered_value0(1:end-1);
      d0=(filtered_value0>0);
      
      %1
      filtered_value1 = filtered_value1(1:end-1);
      d1=(filtered_value1>0);
      
      %2
      filtered_value2 = filtered_value2(1:end-1);
      d2=(filtered_value2>0);
      
      

    %PLOTAR 0
    figure(1)
    subplot(4,2,1), plot(t,y0), title('Sinal 0'); % PLOTAR SINAL DE ENTRADA
    subplot(4,2,2), plot(t,m0), title('Modulado 0'); % PLOTAR VALOR MODULADO
    subplot(4,2,3), plot(t,phase_detector0) ,title('Detector de fase 0'); % PLOTAR SAIDA DO DETECTOR DE FASE
    subplot(4,2,4), plot(t,filtered_value0) ,title('Saida do filtro 0');  % PLOTAR SAIDA DO FILTRO
    subplot(4,2,5), plot(t,vco0), title ('Saida do VCO'); % PLOTAR SAIDA DO VCO
    subplot(4,2,6), plot(t,d0), title ('Valor Demodulado');% PLOTAR VALOR DEMODULADO
    
    %PLOTAR 1
    figure(2)
    subplot(4,2,1), plot(t,y1), title('Sinal 1'); % PLOTAR SINAL DE ENTRADA
    subplot(4,2,2), plot(t,m1), title('Modulado 1'); % PLOTAR VALOR MODULADO
    subplot(4,2,3), plot(t,phase_detector1) ,title('Detector de fase 1'); % PLOTAR SAIDA DO DETECTOR DE FASE
    subplot(4,2,4), plot(t,filtered_value1) ,title('Saida do filtro 1');  % PLOTAR SAIDA DO FILTRO
    subplot(4,2,5), plot(t,vco1), title ('Saida do VCO 1'); % PLOTAR SAIDA DO VCO
    subplot(4,2,6), plot(t,d1), title('Valor Demodulado');% PLOTAR VALOR DEMODULADO
    
    %PLOTAR 2
    figure(3)
    subplot(4,2,1), plot(t,y2), title('Sinal 2'); % PLOTAR SINAL DE ENTRADA
    subplot(4,2,2), plot(t,m2), title('Modulado 2'); % PLOTAR VALOR MODULADO
    subplot(4,2,3), plot(t,phase_detector2) ,title('Detector de fase 2'); % PLOTAR SAIDA DO DETECTOR DE FASE
    subplot(4,2,4), plot(t,filtered_value2) ,title('Saida do filtro 2');  % PLOTAR SAIDA DO FILTRO
    subplot(4,2,5), plot(t,vco2), title ('Saida do VCO 2'); % PLOTAR SAIDA DO VCO
    subplot(4,2,6), plot(t,d2), title('Valor Demodulado');% PLOTAR VALOR DEMODULADO
   
