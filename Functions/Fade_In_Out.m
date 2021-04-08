function [outputaudio] = Fade_In_Out (audio,in,out)
%this function will dace in the audio by the set amount of seconds and then
%fade out by the set amount of seconds.

Fs = 44100;

in = in*Fs; %Fade in time in samples
out = out*Fs; %Fade out time in samples

audio(1:in) = audio(1:in).*linspace(0,1,in)';       %creating a volume vector to fade in the audio and applying it to the start of the audio


audio(((length(audio)+1)-out):length(audio)) = audio(((length(audio)+1)-out):length(audio)).*linspace(1,0,out)';  % creating and applying a fade out volume vector

outputaudio = audio;