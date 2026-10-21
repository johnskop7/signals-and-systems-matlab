# Project Results Summary

This document summarizes the main observations from the original Signals and Systems MATLAB report.

## Echo and reverberation filters

The project models echo with the discrete-time system:

y[n] = c x[n] + (1-c)x[n-P]

For c = 0.55, changing the delay from P = 2 to P = 5 changes the locations of the frequency-response minima and the pole-zero pattern. A third-order reverberation filter is formed by cascading three echo filters.

An inverse filter is then derived and applied after the reverberation filter. In the matched-delay experiment, the final signal reproduces the original test signal.

## Band-pass filters and stability

A band-pass filter is constructed from prescribed poles and zeros, and its pole-zero, magnitude, phase, impulse, and step responses are studied.

Moving the poles illustrates the standard stability behavior:

- poles inside the unit circle produce a decaying impulse response;
- poles near the unit circle give a long-lived oscillatory response and greater frequency selectivity;
- poles outside the unit circle produce an unstable, growing response.

The experiments also show how changing the pole angle shifts the passband and how moving zeros closer to the poles attenuates frequencies in the passband.

## Musical-signal analysis

The viola recordings are sampled at **44.1 kHz**. The implementation:

- computes short-time energy using a 1000-sample Hamming window;
- calculates spectra with the FFT;
- isolates a single note for period analysis;
- compares the measured period with the fundamental frequency;
- examines higher-order harmonics.

For the isolated viola note used in the report, the estimated fundamental frequency is approximately **258.9 Hz**, consistent with a period of roughly **3.9 ms**.

## Harmonic isolation

A separate viola note is filtered to isolate selected spectral components. The report identifies:

- second harmonic: approximately **648.3 Hz**, isolated with a 600-700 Hz band;
- fourth harmonic: approximately **1302 Hz**, isolated with a 1200-1400 Hz band.

After filtering, the time-domain signals become more sinusoidal because most other spectral components are removed.

## Echo and reverb on a piano note

For a sampling rate of 44.1 kHz and a desired delay of 0.15 s, the implementation uses:

P = 0.15 × 44100 = 6615 samples.

The project compares the original, echoed, and reverberated signals in both the time and frequency domains. It also experimentally reduces the echo delay and reports that the echo ceases to be clearly distinguishable at about **0.03 s** (P = 1321 samples).

Finally, the dereverberation experiment demonstrates that small errors in the assumed delay (5, 10, or 50 samples) prevent exact cancellation and substantially alter the resulting signal.
