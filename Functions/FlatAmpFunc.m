function [FlatAmpAudio] = FlatAmpFunc(Audio)
AudioSamples = length(Audio);
% As the HRIR data points are in a sphere around the subjects head to move
% a sound from one point to another making it appear like it is moving in a
% straight line this function creates a vector that modulates the amplitude
% to achieve this

AmpLine = horzcat(linspace(0.1, 1, AudioSamples/2),linspace(1, 0.1, AudioSamples/2+1)); 

FlatAmpAudio1 = Audio(:,1).*AmpLine';
FlatAmpAudio2 = Audio(:,2).*AmpLine';

FlatAmpAudio = [FlatAmpAudio1 FlatAmpAudio2];
end
