%% Signals and Systems - MATLAB DSP Project
% Digital filter design, spectral analysis, and audio processing.
% Developed for the Signals and Systems course at NTUA (2020-2021).
%
% Required input files are intentionally not redistributed. Place:
%   viola_series.wav, viola_note.wav, piano_note.wav
% in ../audio/input/ before running this script.

script_dir = fileparts(mfilename('fullpath'));
project_root = fileparts(script_dir);
addpath(script_dir);
audio_input_dir = fullfile(project_root, 'audio', 'input');
audio_output_dir = fullfile(project_root, 'audio', 'output');
if ~exist(audio_output_dir, 'dir')
    mkdir(audio_output_dir);
end

%% Part 1.1 - Echo and Reverberation Filters

%1.1.a
%echo effect filters
 %first filter(c =0.55 and P=2)
a_echo_1 = [1 0 0 ];
b_echo_1 = [0.55 0 0.45];
 %second filter(c=0.55 and P=5)
a_echo_2 = [1 0 0 0 0 0];
b_echo_2 = [0.55 0 0 0 0 0.45];

%1.1.b
figure(1);
freqz(b_echo_1,a_echo_1);
title('magnitude and phase response of the echo filter for c=0.55 and P=2');
figure(2);
freqz(b_echo_2,a_echo_2);
title('magnitude and phase response of the echo filter for c=0.55 and P=5');

%1.1.c 
[Z_echo_1,P_echo_1,K1] = tf2zp(b_echo_1,a_echo_1);
figure(3);
zplane(Z_echo_1,P_echo_1);
title('zeros and poles of the echo filter for c=0.55 and P=2');
[Z_echo_2,P_echo_2,K2] = tf2zp(b_echo_2,a_echo_2);
figure(4);
zplane(Z_echo_2,P_echo_2);
title('zeros and poles of the echo filter for c=0.55 and P=5');

%1.1.d
%impulse response of the first filter
[h_echo_1,t_echo_1] = impz(b_echo_1,a_echo_1);
figure(5);
impz(b_echo_1,a_echo_1);
xlabel('Time(in samples');
ylabel('Amplitude');
title('Impulse response of the echo filter for c=0.55 and P=2');
%impulse response of the second filter
[h_echo_2,t_echo_2] = impz(b_echo_2,a_echo_2);
figure(6);
impz(b_echo_2,a_echo_2);
xlabel('Time(in samples)');
ylabel('Amplitude');
title('Impulse response of the echo filter for c=0.55 and P=5');

%1.1.e
%3rd degree reverberation filter using three echo filters in
%series(P=2)
h_help = conv(h_echo_1,h_echo_1);
h_reverb = conv(h_help,h_echo_1);%impulse response of the reverberation filter
M_help = toeplitz(h_reverb);
a_reverb = inv(M_help)*h_reverb;%finds vector a of the filter
b_reverb = h_reverb;% finds vector b of the filter
%amplitude and phase response of the reverberation filter
figure(7);
freqz(b_reverb',a_reverb');
title('magnitude and phase response of the reverberation filter');
%plotting the poles and zeros of the reverberation filter
[Z_reverb,P_reverb,K_reverb] = tf2zp(b_reverb',a_reverb');
figure(8);
zplane(Z_reverb,P_reverb);
title('zeros and poles of the reverberation filter');
figure(9);
impz(b_reverb,a_reverb);
xlabel('Time(in samples)');
ylabel('Amplitude');
title('Impulse response of the reverberation filter');

%1.1.f
%a,b vectors of the dereverberation filter
H_reverb = fft(h_reverb,500);
H_dereverb = 1./H_reverb;
h_dereverb = ifft(H_dereverb,500);%impulse response of the dereverberation filter
M_dereverb = toeplitz(h_dereverb);
a_dereverb = inv(M_dereverb)*h_dereverb;
b_dereverb = h_dereverb;
%x[n] = u[n] - u[n-5]
n = -20:20;
x = heaviside(n) - heaviside(n-5);
figure(10);
stem(n,x,'filled');
xlabel('Time(in samples)');
ylabel('x[n]');
title('x[n]=u[n] - u[n-5]');
Y1 = filter(b_reverb,a_reverb,x); %signal x enters the reverberation filter
figure(11);
stem(n,Y1,'filled');
xlabel('Time(in samples)');
ylabel('Y1[n]');
title('Reverberation filter response'); 
Y2 = filter(b_dereverb,a_dereverb,Y1); %signal Y1 enters the dereverberation filter
figure(12);
stem(n,Y2,'filled');
xlabel('Time(in samples)');
ylabel('Y2[n]');
title('Dereverberation filter response');

%% Part 1.2 - Band-Pass Filter Design

%1.2.a
%poles and zeros of the bandpass filter
P_bandpass = [0.65 + 0.65i 0.65-0.65i];
Z_bandpass = [ 0.8 0.8 0.8i -0.8i];
figure(13);
zplane(Z_bandpass',P_bandpass');
title('poles and zeros of the bandpass filter');
K_bandpass = 1;%we consider the gain of the bandpass filter to be equal to 1
%numerator and denominator of the transfer function of the bandpass filter
[b_bandpass,a_bandpass] = zp2tf(Z_bandpass',P_bandpass',K_bandpass);
[h_bandpass,t_bandpass]=impz(b_bandpass,a_bandpass);%impulse response of the bandpass filter

%1.2.b
%amplitude and phase response of the bandpass filter
figure(14);
freqz(b_bandpass,a_bandpass);
title('magnitude and phase response of the bandpass filter');

%1.2.c
figure(15);
impz(b_bandpass,a_bandpass);
title('impulse response of the bandpass filter');
figure(16);
stepz(b_bandpass,a_bandpass);
title('step response of the bandpass filter');

%1.2.d
%poles' coordinates p={0.7±0.7i}
P_bandpass_1 = [0.7+0.7i 0.7-0.7i];
Z_bandpass = [ 0.8 0.8 0.8i -0.8i];
figure(17);
zplane(Z_bandpass',P_bandpass_1');
title('poles and zeros diagram for p=(0.7±0.7i)');
[b_bandpass_1,a_bandpass_1] = zp2tf(Z_bandpass',P_bandpass_1',K_bandpass);
figure(18);
impz(b_bandpass_1,a_bandpass_1);
title('impulse response of the bandpass filter for p=(0.7±0.7i)');
figure(19);
freqz(b_bandpass_1,a_bandpass_1);
title('magnitude and phase response of the bandpass filter for p=(0.7±0.7i)');
%poles' coordinates p={0.707±0.707i}
P_bandpass_2 = [0.707+0.707i 0.707-0.707i];
Z_bandpass = [ 0.8 0.8 0.8i -0.8i];
figure(20);
zplane(Z_bandpass',P_bandpass_2');
title('poles and zeros diagram for p={0.707±0.707i}');
[b_bandpass_2,a_bandpass_2] = zp2tf(Z_bandpass',P_bandpass_2',K_bandpass);
figure(21);
subplot(2,1,1);
impz(b_bandpass_2,a_bandpass_2);
title('impulse response of the bandpass filter for p=(0.707±0.707i)');
subplot(2,1,2);
impz(b_bandpass_2,a_bandpass_2);
xlim([40000 40100]);
title('Zoomed-in impulse response of the bandpass filter for  p=(0.707±0.707i)');
%poles' coordinates p={0.75±0.75i}
P_bandpass_3 = [0.75+0.75i 0.75-0.75i];
Z_bandpass = [ 0.8 0.8 0.8i -0.8i];
figure(22);
zplane(Z_bandpass',P_bandpass_3');
title('poles and zeros diagram for p=(0.75±0.75i)');
[b_bandpass_3,a_bandpass_3] = zp2tf(Z_bandpass',P_bandpass_3',K_bandpass);
figure(23);
impz(b_bandpass_3,a_bandpass_3);
title('impulse response of the bandpass filter for p=(0.75±0.75i)');

%1.2.e
%poles coordinates p={0.4±0.7i}
P_bandpass_e = [0.4+0.7i 0.4-0.7i];
Z_bandpass = [ 0.8 0.8 0.8i -0.8i];
figure(24);
zplane(Z_bandpass',P_bandpass_e');
title('zeros and poles diagram for p=(0.4±0.7i)');
[b_bandpass_e,a_bandpass_e] = zp2tf(Z_bandpass',P_bandpass_e',K_bandpass);
figure(25);
impz(b_bandpass_e,a_bandpass_e);
title('impulse response of the bandpass filter for p=(0.4±0.7i)');
[h_bandpass_e,t_bandpass_e]=impz(b_bandpass_e,a_bandpass_e);
figure(26);
freqz(b_bandpass_e,a_bandpass_e);
title('magnitude and phase response of the bandpass filter for p=(0.4±0.7i)');

%1.2.f
%zeros coordinates z={0.77±0.2i,0.2±0.77i}
Z_bandpass_f1 = [0.77+0.2i 0.77-0.2i 0.2+0.77i 0.2-0.77i];
P_bandpass =[0.65+0.65i 0.65-0.65i];
figure(27);
zplane(Z_bandpass_f1',P_bandpass');
title('poles and zeros of the bandpass filter for z=(0.77±0.2i,0.2±0.77i)');
[b_bandpass_f1,a_bandpass_f1] = zp2tf(Z_bandpass_f1',P_bandpass',K_bandpass);
[h_bandpass_f1,t_bandpass_f1]=impz(b_bandpass_f1,a_bandpass_f1);
figure(28);
freqz(b_bandpass_f1,a_bandpass_f1);
title('magnitude and phase response for z=(0.77±0.2i,0.2±0.77i)');
%zeros coordinates z={0.4±0.7i,0.7±0.4i}
Z_bandpass_f2 = [0.4+0.7i 0.4-0.7i 0.7+0.4i 0.7-0.4i];
P_bandpass =[0.65+0.65i  0.65-0.65i];
figure(29);
zplane(Z_bandpass_f2',P_bandpass');
title('poles and zeros of the bandpass filter for z=(0.4±0.7i,0.7±0.4i)');
[b_bandpass_f2,a_bandpass_f2] = zp2tf(Z_bandpass_f2',P_bandpass',K_bandpass);
[h_bandpass_f2,t_bandpass_f2]=impz(b_bandpass_f2,a_bandpass_f2);
figure(30);
freqz(b_bandpass_f2,a_bandpass_f2);
title('magnitude and phase response for z=(0.4±0.7i,0.7±0.4i)');

%% Part 2.1 - Musical Signal Analysis

%2.1.a
[d,fs] = audioread(fullfile(audio_input_dir, 'viola_series.wav'));
dt = 1/fs;
t_d = 0:dt:(length(d)*dt)-dt;%time(in seconds)
figure(31);
plot(t_d,d);
xlabel('Time(in seconds)');
ylabel('Amplitude');
title('viola series waveform');
sound(d,fs);

%2.1.b
nd = scaledata(d,-1,1);%normalized signal d in area [-1,1]
N=1000;%samples
W = hamming(N);%hamming window
E = conv(nd.*nd,W); %E[n] = sum(nd[n]*nd[n]*w[n-m])
figure(32);
nd_scaled = scaledata(d,-40,40);
t_nd = 0:dt:(length(nd)*dt)-dt;
plot(t_nd,nd_scaled);
hold on;
t_E = 0:dt:(length(E)*dt)-dt;
plot(t_E,E);
hold off;
legend('Viola series waveform','Energy of the audio signal');
xlabel('Time(in seconds)');

%2.1.c
figure(33);
D = fft(d);
Nd = length(d);
fax_d = [0:Nd-1];%x_axis starting from 0
fax_d_Hz = fax_d*fs/Nd;
plot(fax_d_Hz,abs(D));
xlim([0 6000]);%we limit the graph in the positive frequencies(in negative frequencies its the mirror graph)
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('DFT of signal viola series');

%2.1.d
figure(34);
samples = [1,100000];
[first_note,fs] = audioread(fullfile(audio_input_dir, 'viola_series.wav'), samples);%first note of the viola series
t_first_note = 0:dt:(length(first_note)*dt)-dt;%time(in seconds)
plot(t_first_note,first_note);
xlabel('Time(in seconds)');
ylabel('Amplitude');
title('First note of viola series');
%visual determination of the note's period in seconds
% T=3,9ms
figure(35);
plot(t_first_note,first_note);
xlim([0.35 0.36]);
xlabel('Time (in seconds)');
ylabel('Amplitude');
title('Zoomed in signal of the first note');
%visual determination of the note's period in samples
% N = 170 samples
figure(36);
plot(first_note);
xlim([1.54*10^4 1.59*10^4]);
xlabel('Time(in samples)');
ylabel('Amplitude');
title('Zoomed in signal of the first note');

%2.1.e
N_first_note = length(first_note);
fax_samples = [0:N_first_note-1];%x-axis(samples) starting from 0
fax_Hz = fax_samples*fs/N_first_note;
FIRST_NOTE = fft(first_note); %dft of the first note
figure(37);
plot(fax_Hz,abs(FIRST_NOTE));
xlim([0 5000]);%we limit the graph in the positive frequencies
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('DFT of the first note');

%2.1.f
[note,fs_note] = audioread(fullfile(audio_input_dir, 'viola_note.wav'));
dt_note = 1/fs_note;
t_note = 0:dt_note:(length(note)*dt_note)-dt_note;%time(in seconds)
figure(38);
subplot(2,1,1);
plot(t_note,note);
xlabel('Time(in seconds)');
ylabel('Amplitude');
title('Viola note signal');
subplot(2,1,2);
plot(t_note,note);
xlim([0.27 0.3]);
xlabel('Time(in seconds)');
ylabel('Amplitude');
title('Zoomed-in viola note signal');
N_note = length(note);
fax_note_samples = [0: N_note-1];%x-axis(samples) starting from 0
fax_note_Hz = fax_note_samples*fs_note/N_note;%x-axis in Hz
NOTE = fft(note);%DFT of the viola note
figure(39);
plot(fax_note_Hz,abs(NOTE));
xlim([0 5000]);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('DFT of the viola note');
y2= bandpass(note,[600 700],fs);%bandpass filter for isolating the second harmonic frequency
y4 = bandpass(note,[1200 1400],fs);%bandpass filter for isolating the fourth harmonic frequency
t_y2 = 0:dt:(length(y2)*dt)-dt;
t_y4 = 0:dt:(length(y4)*dt)-dt;
figure(40);
subplot(2,1,1);
plot(t_y2,y2);
xlim([0 1.2]);
xlabel('Time(in seconds)');
ylabel('Amplitude');
title('Output of the filter used to isolate the second harmonic');
subplot(2,1,2);
plot(t_y2,y2);
xlim([0.31 0.32]);
xlabel('Time(in seconds)');
ylabel('Amplitude');
title('Zoomed-in output of the filter used to isolate the second harmonic');
figure(41);
subplot(2,1,1);
plot(t_y4,y4);
xlim([0 0.8]);
xlabel('Time(in seconds)');
ylabel('Amplitude');
title('Output of the filter used to isolate the fourth harmonic');
subplot(2,1,2);
plot(t_y4,y4);
xlim([0.14 0.15]);
xlabel('Time(in seconds)');
ylabel('Amplitude');
title('Zoomed-in output of the filter used to isolate the fourth harmonic');
N_y2 = length(y2);
fax_y2_samples = [0:N_y2-1];
fax_y2_Hz = fax_y2_samples*fs/N_y2;
Y2 = fft(y2);
figure(42);
plot(fax_y2_Hz,abs(Y2));
xlim([0 20000]);
xlabel('Frequency(Hz)');
ylabel('Magnitude');
title('DFT of the output of the filter used to isolate the second harmonic');
N_y4 = length(y4);
fax_y4_samples = [0:N_y4-1];
fax_y4_Hz = fax_y4_samples*fs/N_y4;
Y4 = fft(y4);
figure(43);
plot(fax_y4_Hz,abs(Y4));
xlim([0 20000]);
xlabel('Frequency(Hz)');
ylabel('Magnitude');
title('DFT of the output of the filter used to isolate the fourth harmonic');

%% Part 2.2 - Echo and Reverb on Musical Signals

%2.2.a
[p,fs] = audioread(fullfile(audio_input_dir, 'piano_note.wav'));
dt_p = 1/fs;
t_p = 0:dt_p:(length(p)*dt_p)-dt_p;%time(in seconds)
figure(44);
plot(t_p,p);
xlabel('Time(in seconds)');
ylabel('Amplitude');
title('Piano note waveform');
sound(p);

%2.2.b
P = fs.*0.15;%time delay parameter
%echo filter
a_echo_p = [1 ,zeros(1,P)];%vectors a and b of the echo filter
b_echo_p = [0.6 , zeros(1,P-1) ,0.4];
[h_echo_p,t_echo_p] = impz(b_echo_p,a_echo_p);%impulse response of the echo filter
%reverberation filter(3 echo filters put in series)
h_reverb_help = conv(h_echo_p,h_echo_p);
h_reverb_p = conv(h_reverb_help,h_echo_p);%impulse response of the reverberation filter
a_reverb_p = [1 ,zeros(1,length(h_reverb_p)-1)];
b_reverb_p = h_reverb_p';
y_echo_p = filter(b_echo_p,a_echo_p,p);
y_reverb_p = conv(h_reverb_p,p);
t_ye = 0:dt_p:(length(y_echo_p)*dt_p)-dt_p;
t_yr = 0:dt_p:(length(y_reverb_p)*dt_p)-dt_p;
figure(45);
plot(t_ye,y_echo_p);
xlabel('Time(in seconds)');
ylabel('Amplitude');
title(' Echoed piano note');
sound(y_echo_p);
figure(46);
plot(t_yr,y_reverb_p);
xlabel('Time (in seconds)');
ylabel('Amplitude');
title('Reverbed piano note');
sound(y_reverb_p);

%2.2.c
P_fft = fft(p,fs);
Y_ECHO_P = fft(y_echo_p,fs);
Y_REVERB_P = fft(y_reverb_p,fs);
figure(47);
plot(20*log10(abs(P_fft)));
hold on
plot(20*log10(abs(Y_ECHO_P)));
plot(20*log10(abs(Y_REVERB_P)));
xlabel('Frequency (in samples)');
ylabel('Magnitude(dB)');
legend('DFT of piano note','DFT of echoed piano note','DFT of reverbed piano note');
hold off;
figure(57);
plot(20*log10(abs(P_fft)));
xlabel('FrequencyIin samples)');
ylabel('Magnitude(dB)');
title('DFT of piano note');
figure(58);
plot(20*log10(abs(Y_ECHO_P)));
xlabel('Frequency(in samples)');
ylabel('Magnitude(dB)');
title('DFT of echoed piano note');
figure(59);
plot(20*log10(abs(Y_REVERB_P)));
xlabel('Frequency(in samples)');
ylabel('Magnitude(dB)');
title('DFT of reverbed piano note');
%2.2.d
a_echo_ps = [1 ,zeros(1,1321)];%vectors a and b of the echo filter
b_echo_ps = [0.6 , zeros(1,1320) ,0.4];%P = 1321
y_echo_ps = filter(b_echo_ps,a_echo_ps,p);
t_yes = 0:dt_p:(length(y_echo_ps)*dt_p)-dt_p;
figure(48);
plot(t_yes,y_echo_ps);
xlabel('Time(in seconds)');
ylabel('Amplitude');
title('Echoed piano note(non distinguishable echo effect)');
sound(y_echo_ps);

%2.2.e
audiowrite(fullfile(audio_output_dir, 'echoed_piano_note.wav'), y_echo_p, fs);%writes audio
audiowrite(fullfile(audio_output_dir, 'reverbed_piano_note.wav'), y_reverb_p, fs);

%2.2.f
a_dereverb_p = b_reverb_p;
b_dereverb_p = a_reverb_p;
y_dereverbed_p = filter(b_dereverb_p,a_dereverb_p,y_reverb_p);
t_ydp = 0:dt_p:(length(y_dereverbed_p)*dt_p)-dt_p;
figure(49);
plot(t_ydp,y_dereverbed_p,'g');
hold on;
plot(t_p,p,'r');
hold off;
xlabel('Time(in seconds)');
ylabel('Amplitude');
title('Initial and dereverbed piano signal');

%2.2.g
P1 = P + 5;%5 samples greater time delay 
P2 = P + 10;%10 samples greater time delay 
P3 = P + 50;%15 samples greater time delay 
%P1
a_echo_p1 = [1 ,zeros(1,P1)];%vectors a and b of the echo filter
b_echo_p1 = [0.6 , zeros(1,P1-1) ,0.4];
[h_echo_p1,t_echo_p1] = impz(b_echo_p1,a_echo_p1);%impulse response of the echo filter
%reverberation filter
h_reverb_help1 = conv(h_echo_p1,h_echo_p1);
h_reverb_p1 = conv(h_reverb_help1,h_echo_p1);%impulse response of the reverberation filter(5 samples off)
a_reverb_p1 = [1 ,zeros(1,length(h_reverb_p1)-1)];%vectors a and b of the reverberation filter(5 samples off)
b_reverb_p1 = h_reverb_p1';
a_dereverb_p1 = b_reverb_p1;%vectors a and b of the new dereverberation filter(5 samples off)
b_dereverb_p1 = a_reverb_p1;
y_dereverbed_p1 = filter(b_dereverb_p1,a_dereverb_p1,y_reverb_p);
t_ydp1 = 0:dt_p:(length(y_dereverbed_p1)*dt_p)-dt_p;
figure(50);
plot(t_ydp1,y_dereverbed_p1);
xlabel('Time(in seconds)');
title('Dereverbed piano signal(5 samples off)');
%P2
a_echo_p2 = [1 ,zeros(1,P2)];%vectors a and b of the echo filter
b_echo_p2 = [0.6 , zeros(1,P2-1) ,0.4];
[h_echo_p2,t_echo_p2] = impz(b_echo_p2,a_echo_p2);%impulse response of the echo filter
%reverberation filter
h_reverb_help2 = conv(h_echo_p2,h_echo_p2);
h_reverb_p2 = conv(h_reverb_help2,h_echo_p2);%impulse response of the reverberation filter(10 samples off)
a_reverb_p2 = [1 ,zeros(1,length(h_reverb_p2)-1)];
b_reverb_p2 = h_reverb_p2';
a_dereverb_p2 = b_reverb_p2;%vectors a and b of the new dereverberation filter(10 samples off)
b_dereverb_p2 = a_reverb_p2;
y_dereverbed_p2 = filter(b_dereverb_p2,a_dereverb_p2,y_reverb_p);
t_ydp2 = 0:dt_p:(length(y_dereverbed_p2)*dt_p)-dt_p;
figure(51);
plot(t_ydp2,y_dereverbed_p2);
xlabel('Time(in seconds)');
title('Dereverbed piano signal(10 samples off)');
%P3
a_echo_p3 = [1 ,zeros(1,P3)];%vectors a and b of the echo filter
b_echo_p3 = [0.6 , zeros(1,P3-1) ,0.4];
[h_echo_p3,t_echo_p3] = impz(b_echo_p3,a_echo_p3);%impulse response of the echo filter
%reverberation filter
h_reverb_help3 = conv(h_echo_p3,h_echo_p3);
h_reverb_p3 = conv(h_reverb_help3,h_echo_p3);%impulse response of the reverberation filter(50 samples off)
a_reverb_p3 = [1 ,zeros(1,length(h_reverb_p3)-1)];
b_reverb_p3 = h_reverb_p3';
a_dereverb_p3 = b_reverb_p3;
b_dereverb_p3 = a_reverb_p3;
y_dereverbed_p3 = filter(b_dereverb_p3,a_dereverb_p3,y_reverb_p);
t_ydp3 = 0:dt_p:(length(y_dereverbed_p3)*dt_p)-dt_p;
figure(52);
plot(t_ydp3,y_dereverbed_p3);
xlabel('Time (in seconds)');
title('Dereverbed piano signal(50 samples off)');

%vectors a and b of total impulse response for P = 6615
a_total = conv(a_reverb_p,a_dereverb_p);
b_total = conv(b_reverb_p,b_reverb_p);
%vectors a and b of total impulse response for P=6620
a_total_1 = conv(a_reverb_p,a_dereverb_p1);%we use the reverberation filter for P=6615
b_total_1 = conv(b_dereverb_p1,b_reverb_p);
%vectors a and b of total impulse response for P=6625
a_total_2 = conv(a_reverb_p,a_dereverb_p2);%we use the reverberation filter for P=6615
b_total_2 = conv(b_dereverb_p2,b_reverb_p);
%vectors a and b of total impulse response for P=6665
a_total_3 = conv(a_reverb_p,a_dereverb_p3);%we use the reverberation filter for P=6615
b_total_3 = conv(b_dereverb_p3,b_reverb_p);

%Amplitude and phase response of reverberation/dereverberation systems
figure(53);
freqz(b_total,a_total);
title('Total system magnitude  response for P=6615');
figure(54);
freqz(b_total_1,a_total_1);
title('Total system magnitude  response for P=6620');
figure(55);
freqz(b_total_2,a_total_2);
title('Total system magnitude  response for P=6625');
figure(56);
freqz(b_total_3,a_total_3);
title('Total system magnitude  response  for P=6665');
