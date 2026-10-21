% Alternative pole-zero design used while experimenting with harmonic isolation.
% The main portfolio implementation is in ../src/signals_systems_project.m.

[note,fs_note] = audioread(fullfile('..','audio','input','viola_note.wav'));

P_bandpass12 = [0.9899+0.1009i  0.9899-0.1009i];
Z_bandpass12 = [0.7+0.35i  0.7-0.35i];
zplane(Z_bandpass12',P_bandpass12');

K_bandpass = 1; % consider the gain of the bandpass filter equal to 1
[b_bandpass12,a_bandpass12] = zp2tf(Z_bandpass12',P_bandpass12',K_bandpass);

figure(101);
freqz(b_bandpass12,a_bandpass12);

y12 = filter(b_bandpass12,a_bandpass12,note);
N_y12 = length(y12);
fax_y12_samples = 0:N_y12-1;
fax_y12_Hz = fax_y12_samples*fs_note/N_y12;
Y12 = fft(y12);

figure(150);
plot(fax_y12_Hz,abs(Y12));
xlim([0 20000]);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Spectrum of the output of the filter used to isolate the second harmonic');
