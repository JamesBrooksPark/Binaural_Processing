function [Outputstatic] = StaticHRTF (Audio, Elev, Azim)
load IRC_1002_R_HRIR.mat;
Audio = Audio(:,1); %Split a stereo track to mono

%% Finding HRTF Index Value
if Elev> 0                  % As the HRIR data angles are reversed this section 
                            % flips the inputted angles round so they match the HRIR data
    Elev = 360 - Elev;
end
if Azim > 0
    Azim = 360 - Azim;
end

ElevIndex = [-45 -30 -15 0 15 30 45 60 75 90]';

 if Elev < 60           % This section takes the Elevation and Azimuth angles and finds the correct index value for the HRIR data
        index = round(((Azim)/15)+1)+((find(ElevIndex == Elev)-1)*25)-find(ElevIndex == Elev)+1; % up to 60 degrees elevation there
                                                                                                 % are 24 data points, this line finds the index for these angles.
    elseif Elev == 60
        index = 169 + (Azim/30);
    elseif Elev == 75
        index = 181 + (Azim/60);
    elseif Elev == 90
        index = 186;
 end
%% Applying the HRTF data to the audio file

L = conv(Audio, l_hrir_S.content_m(index));  % Convolving the HRIR with the mono audio to create the left channel
R = conv(Audio, r_hrir_S.content_m(index));  % Convolving the HRIR with the mono audio to create the Right channel


y = [L R];


Outputstatic = 0.99.*y./(max(max(abs(y))));     % Ensuring there is no clipping in the outputed audio
end

