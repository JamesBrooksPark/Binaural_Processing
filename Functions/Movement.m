function [out] = Movement(Audio, Option,Elevstart, Elevend, Azimstart ,Azimend)
% Audio  = Audio inputted for processing
% Option  = 1 = Movement, 2 = Movement through 360 degrees Azimuth, 3 = movement
% through 90 degrees elevation
% Elevstart = starting elevation angle 
% Elevend  = end elevation angle 
% Azimstart = starting Azimuth angle 
% Azimend  = end Azimuth angle 
%%
load IRC_1002_R_HRIR.mat    % loading in the HRIR Data into matlab
x = Audio;

%% Error Checking
if Elevstart > 90
    print(" Start elevation Angle is too high")
elseif Elevstart < -45
        print("Start elevation angle is too low")
elseif Azimstart > 360
        print("Start azimuth angle is too high")
elseif Azimstart < 0
        print("Start aziumuth angle is too low")
elseif Elevend > 90
    print("Elevation Angle is too high")
elseif Elevend < -45
        print("Elevation angle is too low")
elseif Azimend > 360
        print("Azimuth angle is too high")
elseif Azimend < 0
        print("Aziumuth angle is too low")
end
%% Pre Working

    
frame_size = 1024; % The number of samples in a frame
Ninput = length(x); % The number of sam ples in the input signal
[~,NIR] = size( l_hrir_S.content_m); % The number of samples in the HRTF impulse response
y_length = Ninput + NIR -1;
y = zeros(y_length,2);

frame_conv_len = NIR + frame_size - 1; %  The number of samples created by convolving a frame of x and IR
step_size = frame_size/2; % Step size for 50% overlap-add
w = hann(frame_size, 'periodic');  % Generate the Hann function to window a frame
Nframes = floor((length(x)-frame_size) / step_size); % calculate the number of frames

IRPad = zeros(frame_conv_len,2); % create empty vector for zero-padded IR
currentFrame = zeros(frame_conv_len,1); % create empty vector for zero padded current frame - we can do this here as we will only ever replace the first frame_size samples


ElevIndex = [-45 -30 -15 0 15 30 45 60 75 90]';  % An array of all the elevation angles in the HRIR Data
%% Azmline creation


if Option == 1
    
    if Azimstart < Azimend
        Azimlineorig = Azimstart : 15 : Azimend;  %Using the colon operator an array can be made going from 'Azimstart' to 'Azimend' with a spacing of 15 degrees
    elseif Azimstart > Azimend
        Azimlineorig = linspace(Azimstart, Azimend,((Azimstart-Azimend)/15)+1);    % The colon operator cannot be used when going from a larger number to a smaller 
                                                                               % number so a 'linspace' function must be used creating an array starting at the start
                                                                               % angle and ending at the end angle generating a specified number of points
    elseif Azimstart == Azimend
        Azimlineorig = Azimstart;           % Ensuring all situations are satisfied if the start and end angle are the same the start angle is used 
    end

    if Elevstart < Elevend
        Elevlineorig = Elevstart : 15 : Elevend;
    elseif Elevstart > Elevend
        Elevlineorig = linspace(Elevstart, Elevend,((Elevstart-Elevend)/15)+1);
    elseif Elevstart == Elevend
        Elevlineorig = Elevstart;
    end
    
elseif Option == 2
    
    if Azimstart < Azimend
        Azimlineorig = horzcat(linspace(Azimstart, 0, (Azimstart/15)+1),linspace(345, Azimend, ((360-Azimend)/15)));  %Using the colon operator an array can be made 
                                                                                                                        %going from 'Azimstart' to 'Azimend' with a spacing
                                                                                                                        %of 15 degrees
    elseif Azimstart > Azimend
        Azimlineorig = horzcat((Azimstart : 15: 345), (0 : 15 : Azimend));    % The colon operator cannot be used when going from a larger number to a smaller 
                                                                               % number so a 'linspace' function must be used creating an array starting at the start
                                                                               % angle and ending at the end angle generating a specified number of points
    elseif Azimstart == Azimend
        Azimlineorig = Azimstart;           % Ensuring all situations are satisfied if the start and end angle are the same the start angle is used 
    end

    if Elevstart < Elevend
        Elevlineorig = Elevstart : 15 : Elevend;
    elseif Elevstart > Elevend
        Elevlineorig = linspace(Elevstart, Elevend,((Elevstart-Elevend)/15)+1);
    elseif Elevstart == Elevend
        Elevlineorig = Elevstart;
    end
        
elseif Option == 3
    
    if Azimstart ~= Azimend
        Azimlineorig = horzcat(Azimstart, Azimend);  %Using the colon operator an array can be made going from 'Azimstart' to 'Azimend' with a spacing of 15 degrees
    elseif Azimstart == Azimend
        Azimlineorig = Azimstart;           % Ensuring all situations are satisfied if the start and end angle are the same the start angle is used 
    end

    if Elevstart == 0 && Elevend == 0
        Elevlineorig = horzcat(0: 15 :75,linspace(90,0,(90/15)+1));
    else
        Elevlineorig = horzcat(Elevstart: 15 :75,linspace(90,Elevend,((90-Elevend)/15)+1));
    end
        
else
    error('Option is not valid')
    
end
    
for n = 1: length(Azimlineorig)
    if Azimlineorig(n) ~= 0
    Azimlineorig(n) = 360 - Azimlineorig(n);    % The HRIR Database used in this code moves in an anti clockwise movement, to normalise this to clockwise this line switches 
                                                % the angles around
    end
end

Azimlinelength = length(Azimlineorig);
Elevlinelength = length(Elevlineorig);

Azimline = zeros(Nframes+6,1);  % pre allocating an empty array for the final Azimuth angle array
Elevline = zeros(Nframes+6,1);
point = 1;
%% Index Array creation
% creating an array that defines an angle for every sample in the audio
% file
for n = 1 : Azimlinelength
     Azimlinetemp = Azimlineorig(n).*ones(round(Nframes/Azimlinelength),1);
     Azimline(point : point + round((Nframes/Azimlinelength)-1)) = Azimline(point : point + round((Nframes/Azimlinelength)-1)) + Azimlinetemp;
     point = point + round(Nframes/Azimlinelength);
     
end
point = 1;
for n = 1 : Elevlinelength
     Elevlinetemp = Elevlineorig(n).*ones(round(Nframes/Elevlinelength),1);
     Elevline(point : point + round((Nframes/Elevlinelength)-1)) = Elevline(point : point + round((Nframes/Elevlinelength)-1)) + Elevlinetemp;
     point = point + round(Nframes/Elevlinelength);
     
end
%% Processing
for n = 1 : Nframes
                        % This section uses the Azim and Elev lines to find
                        % the index number for the required impulse
                        % response, As the number of azimuth responses
                        % changes with different elevation angles a
                        % different method is needed for several of the
                        % higher elevation angles
    if Elevline(n) < 60
        index = round(((Azimline(n)/15)+1)+((find(ElevIndex == Elevline(n)))*25))-find(ElevIndex == Elevline(n))+1;
    elseif Elevline(n) == 60
        index = 169 + (Azimline(n)/30);
    elseif Elevline(n) == 75
        index = 181 + (Azimline(n)/60);
    elseif Elevline(n) == 90
        index = 186;
    end
    
    currentFrame(1:frame_size) = x(1+(n-1)*step_size:1+(n-1)*step_size+frame_size-1).*w; % window the current frame
    
    
    IRPad(1:NIR,1) = l_hrir_S.content_m(index,:);  % allocates the impulse response to a variable 
    IRPad(1:NIR,2) = r_hrir_S.content_m(index,:); 
    
    convResL = ifft(fft(currentFrame).*fft(IRPad(:,1)));     % Convolve the impulse response with this frame
    convResR = ifft(fft(currentFrame).*fft(IRPad(:,2)));     % Convolve the impulse response with this frame
    
    
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,1) = ...     % Add the convolution result for this frame into the output vector y
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,1) + convResL;
    
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,2) = ...     % Add the convolution result for this frame into the output vector y
    y(1+(n-1)*step_size:1+(n-1)*step_size + frame_conv_len -1,2) + convResR;
    
end
   
    

out = 0.99.*y./(max(max(abs(y))));

end
