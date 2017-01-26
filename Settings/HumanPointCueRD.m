function [S,P] = HumanPointCueRD

%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD THE RIG SETTINGS, THESE HOLD CRUCIAL VARIABLES SPECIFIC TO THE RIG,
% IF A CHANGE IS MADE TO THE RIG, CHANGE THE RIG SETTINGS FUNCTION IN
% SUPPORT FUNCTIONS
S = MarmoViewRigSettings;

% NOTE THE MARMOVIEW VERSION USED FOR THIS SETTINGS FILE, IF AN ERROR, IT
% MIGHT BE A VERSION PROBLEM
S.MarmoViewVersion = '1B';

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.EyeDump = 1;   %IMPORTANT, tell it to dump eye data to file, 220 hz

% PROTOCOL PREFIX
S.protocol = 'PointCueAcuRD';
% DEFAULT SUBJECT
S.subject = 'Subject02Delay0.5Sec';

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'PointCueRDInit';
% "next trial" m-file
S.nextFunc = 'PointCueRDNext';
% "run trial" m-file
S.runFunc = 'PointCueRDRun';
% "finish trial" m-file
S.endFunc = 'PointCueRDEnd';
% "plot trial" m-file
S.plotFunc = 'PointCueRDPlot';

% Define Banner text to identify the experimental protocol
% recommend maximum of ~28 characters
S.protocolTitle = 'Symbolic Point Cue Task';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Reward setting
P.rewardNumber = 1;
S.rewardNumber = 'Number of juice pulses to deliver:';

% Stimulus settings
P.cpd = 2;
S.cpd = 'Cycles per degree:';
P.apertures = 8;
S.apertures = 'Number of apertures:';
P.xDeg = 6.0; %7.5;
S.xDeg = 'X center of stimulus (degrees):';
P.yDeg = 0;
S.yDeg = 'Y center of stimulus (degrees):';
P.radius = 3.5;
S.radius = 'Grating radius (degrees):';
P.apertureRadius = 3.0; %2.5;
S.apertureRadius = 'Aperture radius (degrees):';
P.cueRadius = 2.0; 
S.cueRadius = 'Cue radius (degrees):';
P.apertureWidth = 4;
S.apertureWidth = 'Width of aperture line (pixels):';
P.apertureColor = 127-20; %127-5;
S.apertureColor = 'Aperture color (0-255):';
P.correctColor = 0; %127-5;
S.correctColor = 'Correction cue color (0-255):';
P.angle = 0;
S.angle = 'Angle of grating (degrees):';
P.bkgd = 127;
S.bkgd = 'Choose a grating background color (0-255):';
P.range = 127;
S.range = 'Luminance range of grating (1-127):';
P.phase = -1;
S.phase = 'Grating phase (-1 or 1):';
P.squareWave = 0;
S.squareWave = '0 - sine wave, 1 - square wave';
P.sigma1 = 0.4;
S.sigma1 = 'Cue line width near fixation';
P.sigma2 = 0;
S.sigma2 = 'Cue line width near target';
P.amp1 = 1.0;
S.amp1 = 'Cue line amp near fixation';
P.amp2 = 0;
S.amp2 = 'Cue line amp near target';
P.linedots = 4000;
S.linedots = 'Number of dots for the line cue';
P.linewidth = 10;
S.linewidth = 'Width of the line cue';

% Gaze indicator
P.eyeRadius = 2.5; % 1.5;
S.eyeRadius = 'Gaze indicator radius (degrees):';
P.eyeIntensity = 5;
S.eyeIntensity = 'Indicator intensity:';
S.eyeColorStep = [2 -2 5]; % Directions to step bkgd for a gaze indicator
P.showEye = 0;
S.showEye = 'Show the gaze indicator? (0 or 1):';

%****** fixation properties
P.fixPointRadius = 0.3;  
S.fixPointRadius = 'Fix Point Radius (degs):';
P.probShowFace = 0;
S.probShowFace = 'Flash large face at fix to start (p=0.0):';

% Windows
P.initWinRadius = 2;
S.initWinRadius = 'Enter to initiate fixation (deg):';
P.fixWinRadius = 2.5; %2.0;  by JM 3/10/16
S.fixWinRadius = 'Fixation window radius (deg):';
P.stimWinMinRad = 3.0; %2.25; by JM
S.stimWinMinRad = 'Minumum saccade from fixation (deg):';
P.stimWinMaxRad = 12; %10; by JM
S.stimWinMaxRad = 'Maximum saccade from fixation (deg):';
P.stimWinTheta = pi/4; %pi/7; by JM 3/10/16
S.stimWinTheta = 'Angular leeway for saccade (radians):';

% Trial timing
P.startDur = 4;
S.startDur = 'Time to enter fixation (s):';
P.flashFrameLength = 32;   % make it slow, 250 ms
S.flashFrameLength = 'Length of fixation flash (frames):';
P.fixGrace = 0.05;   %50 ms, making sure not a saccade through fixation
S.fixGrace = 'Grace period to be inside fix window (s):';
P.fixMin = 0.2;
S.fixMin = 'Minimum fixation (s):';
P.fixRan = 0.3;
S.fixRan = 'Random additional fixation (s):';
%P.faceShift = 1.0;  % cue direction this much before stim
%S.faceShift = 'Shift Face towards target (degs):';
P.stimForwardDur = 0.10; % cuing duration
S.stimForwardDur = 'Duration of forward face:';
P.stimGazeDur = 0.10;
S.stimGazeDur = 'Duration of gaze cue face:';
P.delaytime = 0.5; % 500 ms
S.delaytime = 'Delay time of the fixation point';

P.noresponseDur = 1.5;
S.noresponseDur = 'Duration to count error if no response(s):';
P.flightDur = 0.075;
S.flightDur = 'Time for saccade to finish (s):';
P.holdDur = 0.020; % 200 ms hold after saccade
S.holdDur = 'Duration at grating for reward (s):';
P.trackDur = 0.250; % 200 ms hold after saccade
S.trackDur = 'Duration at grating for reward (s):';
P.iti = 1;
S.iti = 'Duration of intertrial interval (s):';
P.blank_iti = 1;
S.blank_iti = 'Duration of blank intertrial(s):';
P.timeOut = 0;
S.timeOut = 'Time out for error (s):';

% Trials list -- x, y, cycPerDeg, phase, angle
P.distLum = 4;
S.distLum = 'Max distractor luminance:';
P.cueColor = 20; % by JM 3/10/16   % 127 + 15;  % make it a pop-out by white/black 
S.cueColor = 'Contrast cue color (0-255):';
P.cueDelayMin = 0.4;
S.cueDelayMin = 'Min Delay (secs) on Cue:';
P.cueDelayMax = 0.7;
S.cueDelayMax = 'Max Delay (secs) on Cue:';
P.runType = 2;
S.runType = '0-User,1-Random,2-Trials List:';

P.RandReplacement = 0;
S.RandReplacement = '0-Repeat All Conds, 1-RandReplacement:';

% Viewpoint TTL control
P.vpxOutChannel = 7; % NOTE THAT THIS IS NOT THE INTAN INPUT, e.g. 7 --> 3
S.vpxOutChannel = 'TTL channels range 0-7:';

% Spatial frequency sampling
%S.sf_sampling = [1 2 3.3 4 5 6.7 10 20];
P.cutfreq = 20;   % max freq, and if this large then do not even show it

S.sf_sampling = [0]; % [0 0.25 0.5 1 1.5 2]; %[1 2 3.5 5 P.cutfreq];
% Eccentricity sampling, currently only using the radius specified above
S.r_sampling = norm([P.xDeg P.yDeg],2);
% Generate trials list
S.trialsList = [];
ApertCorrect = 0;
for zk = 1:size(S.sf_sampling,2)
    
    %for k = 1:1   % only do one direction, while we are testing
        
    for k = 1:P.apertures   % do eight directions
    
        ango = ((k-1) * 2 * pi)/P.apertures;  %/(P.apertures/2)) * 2 * pi;
        xpos = cos(ango) * S.r_sampling;
        ypos = sin(ango) * S.r_sampling;
        
        % Trials list is comprised of [P.xDeg P.yDeg P.cpd P.phase P.angle zk]
        mjuice = 2 + floor(S.sf_sampling(zk)/2);
        if (mjuice > P.rewardNumber)
            mjuice = P.rewardNumber;
        end
        ApertCorrect = ApertCorrect+1;
        
        for i = 1:2
            S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk) zk mjuice ApertCorrect]];
            S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk) zk mjuice ApertCorrect]];
            S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk) zk mjuice ApertCorrect]];
            S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk) zk mjuice ApertCorrect]];
            S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk) zk mjuice ApertCorrect]];
            S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk) zk mjuice ApertCorrect]];
            S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk) zk mjuice ApertCorrect]];
            S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk) zk mjuice ApertCorrect]];
        end
    end
end
SN = size(S.trialsList,1);    % pull out number of conditions
S.finish = SN; 

apertcombo = [ 1 1 1; 2 1 1; 1 2 1; 1 1 2;
               2 2 1; 2 1 2; 1 2 2; 
               2 2 2];
apertcombo_num = size(apertcombo,1); % which is 8

apertcondition = 2;
%apertnumb = 1;
apertnumb = 8;
apertmotion = [];
for k = 1:apertnumb
    for i = 1:apertcondition
        for j = 1:apertcombo_num,
            apertselect = i;
            apertmotion = [apertmotion;
                i apertcombo(j,:)];
        end
    end
end

% 256 trials (128 trials x 2)
% S.trialsList = repmat(S.trialsList,2,1);
% apertmotion  = repmat(apertmotion,2,1);

% Add delays to the S.trialsList
Delay   = P.delaytime;

% AddDelay = [repmat(Nodelay,128,1); repmat(Delay,128,1)];
AddDelay = [repmat(Delay,SN,1)];
Completed = zeros(SN,1);   % track if the trial is completed

% Replace the first 4 apertures with the opposite values
apertmotionrest = apertmotion;
apertmotionrest(find(apertmotionrest ==1))=0;
apertmotionrest(find(apertmotionrest ==2))=3;

apertmotionrest(find(apertmotionrest ==0))=2;
apertmotionrest(find(apertmotionrest ==3))=1;


% size(S.trialsList)
% size(Completed)
% size(AddDelay)
% size(apertmotion)
S.trialsList = [S.trialsList apertmotion apertmotionrest AddDelay Completed];


% size(S.trialsList) = 16 x 11
% Counting unique values in the array
% count = hist(apertmotion,unique(apertmotion))
