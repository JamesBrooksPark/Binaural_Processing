clear 

%% Bringing in all audio files and setting parameters
[Waves, Fs_waves] = audioread('Waves.wav');
WavesAmp = 30;
WavesDelay = 0;
WavesReverbWetDry = 0.5;
Waves = Waves(:,1);         % Converting a stereo track into mono

[BoatHorn, Fs_Horn] = audioread('Horn.wav');
HornAmp = 80;
HornDelay = 3;
HornReverbWetDry = 0.7;
BoatHorn = BoatHorn(:,1);   % Converting a stereo track into mono

[Seagull, Fs_Seagull] = audioread('Seagull.wav');
SeagullAmp = 50;
SeagullDelay = 10;
Seagull = Seagull(:,1);     % Converting a stereo track into mono

[plane,Fs_Plane] = audioread('Plane.wav');
PlaneAmp = 75;
PlaneDelay = 10;
plane = plane(:,1);         % Converting a stereo track into mono
%% Waves Processing 
Waves = Fade_In_Out(Waves,2,3);               % This function fades the audio in and out to stop and abrupt starts/ ends
WavesHRTF = StaticHRTF(Waves,0,0);      % Passing the waves audio file through the static HRTF function

WavesReverb = Behindreverb2(Waves,WavesReverbWetDry);    % Passing the waves audio file through the Behindreverb function


if length(WavesHRTF) > length(WavesReverb)      % As the two audio files are difffernet lengths a empty array is created
                                                % that is the length of the longer audio file
    Waves = zeros(length(WavesHRTF),2);
else
    Waves = zeros(length(WavesReverb),2);
    
end

Waves((1:length(WavesHRTF)),1) = WavesHRTF(:,1);        % Both the audio files are a added to the empty array
Waves((1:length(WavesHRTF)),2) = WavesHRTF(:,2);

Waves((1:length(WavesReverb)),1) = Waves((1:length(WavesReverb)),1) + WavesReverb(:,1);
Waves((1:length(WavesReverb)),2) = Waves((1:length(WavesReverb)),2) + WavesReverb(:,2);

Waves = AmpDelay(Waves,WavesAmp,WavesDelay);  % passing the audio file through the 'AmpDelay' function to set the amplitude 
                                              % of the channel as well as determin when the file starts playing in the mix

%% Boat Horn Processing

HornMove = Movement(BoatHorn,2,0,0,90,270);  % Moving the boat horn sound source across the front of the listener

HornMove = FlatAmpFunc(HornMove);                                % Ensuring the source moves in a flat straight line

HornReverb = Behindreverb2(BoatHorn,HornReverbWetDry);           % creating a reverb file that simulates the boat echoing off the back of the cave

if length(HornReverb) > length(HornMove)                         % Adding the sound files together, similat to how the waves files are added together
    Horn = zeros(length(HornReverb),2);
else
    Horn = zeros(length(HornMove),2);
    
end

Horn((1:length(HornMove)),1) = HornMove(:,1);
Horn((1:length(HornMove)),2) = HornMove(:,2);

Horn((1:length(HornReverb)),1) = Horn((1:length(HornReverb)),1) + HornReverb(:,1);
Horn((1:length(HornReverb)),2) = Horn((1:length(HornReverb)),2) + HornReverb(:,2);

Horn = AmpDelay(Horn, HornAmp, HornDelay);      % delaying and setting the volume for the Horn sound effect

%% Seagull Processing
Seagull = SeagullFunc(Seagull);             % applying the specialy created seagull function that applies spatial reverb and echo in the cave

Seagull = AmpDelay(Seagull, SeagullAmp, SeagullDelay);      % delaying and setting the volume for the seagull sound effect

%% Plane Processing
plane = MovingLowpass(plane);           % applying a moving low pass filter to the plane sound file

plane = Movement(plane,3,0,0,180,0);         % moving the filtered plane file above the listeners head

plane = FlatAmpFunc(plane);             % ensuring the file moves in a straight flat line

Plane = AmpDelay(plane, PlaneAmp, PlaneDelay);      % delaying and setting the volume for the plane sound effect

%% Summing all together
% As the sound files are different lengths this section adds them together
% by creating a vector long enough for all the sound files to be added to 
Output  = Waves;
if length(Plane) > length(Output)
    Output  = [Output ; zeros(length(Plane)-length(Output),2)] + Plane;
else
   Output = Output + [Plane ; zeros(length(Output) - length(Plane),2)];
end

if length(Seagull) > length(Output)
    Output  = [Output ; zeros(length(Seagull)-length(Output),2)] + Seagull;
else
    Output = Output + [Seagull ; zeros(length(Output) - length(Seagull),2)];
end

if length(Horn) > length(Output)
    Output  = [Output ; zeros(length(Horn)-length(Output),2)] + Horn;
else
    Output = Output + [Horn ; zeros(length(Output) - length(Horn),2)];
end
Output = 0.99.*Output./(max(max(abs(Output)))); 
audiowrite('Brooks-Park_Spatial_Demo.wav',Output,Fs_Horn);      % outputting the audio as a .wav file to the project folder
