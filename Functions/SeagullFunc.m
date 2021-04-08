function [outputseagull] = SeagullFunc (audio)

[IR, ~] = audioread('LARGE DAMPING CAVE.wav'); % Load the room impulse response
x  = audio; 
Fs = 44100;
load IRC_1002_R_HRIR.mat

x = x(:, 1); % (If necessary) this reduces a stereo input to mono
Ninput = length(x); % The number of samples in the input signal
NIR = length(IR); % The number of samples in the impulse response
y_length = Ninput+NIR-1;% The number of samples created by convolving x and IR

frame_size = 1024; % The number of samples in a frame
reverb_frame_conv_len = frame_size+NIR-1; %  The number of samples created by convolving a frame of x and IR
step_size = frame_size/2; % Step size for 50% overlap-add
w = hann(frame_size, 'periodic');  % Generate the Hann function to window a frame
Nframes = floor((Ninput-frame_size) / step_size); 
y = zeros(y_length,1); % Initialise the output vector y to zero

% Convolve each frame of the input vector with the impulse response
frame_start = 1;
for n = 1 : Nframes
    % Apply the window to the current frame of the input vector x
    windowed = w.*x(frame_start:frame_start+frame_size-1);
    % Convolve the impulse response with this frame
    convwindow = conv(windowed,IR);
    % Add the convolution result for this frame into the output vector y
    y(frame_start:frame_start+reverb_frame_conv_len-1) = y(frame_start:frame_start+reverb_frame_conv_len-1)+convwindow;
    % Advance to the start of the next frame
    frame_start = frame_start+step_size;
end

%% 
% This section applies all the spatial HRIR data to the sound file, the
% 'conv' function is used to achieve this 

yLO = conv(x,l_hrir_S.content_m(89,:));
yLOLength = length(yLO);

yRO = conv(x,r_hrir_S.content_m(89,:));
yROLength = length(yRO);

yL11 = [zeros(round(Fs*0.4),1); conv(y,l_hrir_S.content_m(81,:))];
yR11 = [zeros(round(Fs*0.4),1); conv(y,r_hrir_S.content_m(81,:))];

yL1 = [zeros(round(Fs*0.1),1); conv(y,l_hrir_S.content_m(91,:))];
yL1 = [yL1; zeros(length(yL11)-length(yL1),1)];
yR1 = [zeros(round(Fs*0.1),1); conv(y,r_hrir_S.content_m(91,:))];
yR1 = [yR1; zeros(length(yR11)-length(yR1),1)];


yL2 = [zeros(round(Fs*0.05),1); conv(y,l_hrir_S.content_m(90,:))];
yL2 = [yL2; zeros(length(yL11)-length(yL2),1)];
yR2 = [zeros(round(Fs*0.05),1); conv(y,r_hrir_S.content_m(90,:))];
yR2 = [yR2; zeros(length(yR11)-length(yR2),1)];

yL4 = [zeros(round(Fs*0.05),1); conv(y,l_hrir_S.content_m(89,:))];
yL4 = [yL4; zeros(length(yL11)-length(yL4),1)];
yR4 = [zeros(round(Fs*0.05),1); conv(y,r_hrir_S.content_m(89,:))];
yR4 = [yR4; zeros(length(yR11)-length(yR4),1)];

yL5 = [zeros(round(Fs*0.1),1); conv(y,l_hrir_S.content_m(87,:))];
yL5 = [yL5; zeros(length(yL11)-length(yL5),1)];
yR5 = [zeros(round(Fs*0.1),1); conv(y,r_hrir_S.content_m(87,:))];
yR5 = [yR5; zeros(length(yR11)-length(yR5),1)];

yL6 = [zeros(round(Fs*0.15),1); conv(y,l_hrir_S.content_m(86,:))];
yL6 = [yL6; zeros(length(yL11)-length(yL6),1)];
yR6 = [zeros(round(Fs*0.15),1); conv(y,r_hrir_S.content_m(86,:))];
yR6 = [yR6; zeros(length(yR11)-length(yR6),1)];

yL7 = [zeros(round(Fs*0.2),1); conv(y,l_hrir_S.content_m(85,:))];
yL7 = [yL7; zeros(length(yL11)-length(yL7),1)];
yR7 = [zeros(round(Fs*0.2),1); conv(y,r_hrir_S.content_m(85,:))];
yR7 = [yR7; zeros(length(yR11)-length(yR7),1)];

yL8 = [zeros(round(Fs*0.25),1); conv(y,l_hrir_S.content_m(84,:))];
yL8 = [yL8; zeros(length(yL11)-length(yL8),1)];
yR8 = [zeros(round(Fs*0.25),1); conv(y,r_hrir_S.content_m(44,:))];
yR8 = [yR8; zeros(length(yR11)-length(yR8),1)];

yL9 = [zeros(round(Fs*0.3),1); conv(y,l_hrir_S.content_m(83,:))];
yL9 = [yL9; zeros(length(yL11)-length(yL9),1)];
yR9 = [zeros(round(Fs*0.3),1); conv(y,r_hrir_S.content_m(83,:))];
yR9 = [yR9; zeros(length(yR11)-length(yR9),1)];

yL10 = [zeros(round(Fs*0.3),1); conv(y,l_hrir_S.content_m(82,:))];
yL10 = [yL10; zeros(length(yL11)-length(yL10),1)];
yR10 = [zeros(round(Fs*0.3),1); conv(y,r_hrir_S.content_m(82,:))];
yR10 = [yR10; zeros(length(yR11)-length(yR10),1)];

yL1Length = length(yL1);
yR1Length = length(yR1);



pad = zeros((yR1Length - yROLength),1);

yROpad = [yRO; pad];
yLOpad = [yLO; pad];

yLR = yL1 + yL2 + yL4 + yL5 + yL6 + yL7 + yL8 + yL9 + yL10 + yL11;
yRR = yR1 + yR2 + yR4 + yR5 + yR6 + yR7 + yR8 + yR9 + yR10 + yR11;

A = 0.2;

yL = (yLR.*A) + yLOpad;
yR = (yRR.*A) + yROpad;


y=[yL yR];
outputseagull = 0.99.*y./(max(max(abs(y))));
end