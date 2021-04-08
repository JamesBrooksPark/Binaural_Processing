function [Audio] = AmpDelay (Audio, Volume, Delay)
% Inputs: Audio,filename(for the outputted audio file), Volume( 1-100), Delay(Seconds)
% Outputs: Delayed and modfied Audio
Fs = 44100;

%% Time delay
samples = Fs * Delay;           % Connverting the delay time into samples
delay = zeros(samples,2);       % Creating an empty array of zeros the length of the delay
Audioout = [delay; Audio];      % Inserting the delay array before the audio

%% Volume control
Multiplier  = Volume/100;
Audio = Audioout * Multiplier;

end