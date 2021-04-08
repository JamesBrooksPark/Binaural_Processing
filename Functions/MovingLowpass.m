function [FilterOut] = MovingLowpass (Audio)
%%
Audio = Audio(:,1);
seg = 2048;
overlap = seg/2;
blocks = floor((length(Audio)-seg)/overlap);
w = hann(seg, 'periodic');  % Generate the Hann function to window a frame

order = 10; %filter order
Wn = linspace(0.1,0.9,blocks); %normalised cutoff frequency in radians

y = zeros(length(Audio),1);
for n= 1 : blocks
    xseg = Audio(1+(n-1)*overlap:1+(n-1)*overlap+seg-1); % Create next segment of input signal
    xsegWin = xseg.*w;
    [b,a] = butter(order,Wn(n));    % designing the filter with a specified cut of frequency and filter order
    yseg = filter(b,a,xsegWin);     % applying the current filter to the section of audio
    y(1+(n-1)*overlap:1+(n-1)*overlap+seg-1) = y(1+(n-1)*overlap:1+(n-1)*overlap+seg-1)+ yseg; % adding the current
                                                                            % section of audio to the final audio output
end

FilterOut = 0.99.*y./(max(max(abs(y))));
end
