function [y] = Behindreverb2 (Audio,Volume)
Audio = Audio(:,1);

[IR, ~] = audioread('LARGE DAMPING CAVE.wav'); % Load the room impulse response

load IRC_1002_R_HRIR.mat;
%%
Audio = conv(Audio,IR);


Audio1l = conv(Audio,l_hrir_S.content_m(84,:));
Audio1r = conv(Audio,r_hrir_S.content_m(84,:));

Audio1 = [Audio1l Audio1r];

Audio2l = conv(Audio,l_hrir_S.content_m(85,:));
Audio2r = conv(Audio,r_hrir_S.content_m(85,:));

Audio2 = [Audio2l Audio2r];

Audio3l = conv(Audio,l_hrir_S.content_m(86,:));
Audio3r = conv(Audio,r_hrir_S.content_m(86,:));

Audio3 = [Audio3l Audio3r];

Audio = Audio1 + Audio2 + Audio3;
y = 0.99.*Audio./(max(max(abs(Audio))));

y = y*Volume;
