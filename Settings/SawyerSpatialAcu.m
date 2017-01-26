function [S,P] = SawyerSpatialAcu

%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD THE RIG SETTINGS, THESE HOLD CRUCIAL VARIABLES SPECIFIC TO THE RIG,
% IF A CHANGE IS MADE TO THE RIG, CHANGE THE RIG SETTINGS FUNCTION IN
% SUPPORT FUNCTIONS
S = MarmoViewRigSettings;

% NOTE THE MARMOVIEW VERSION USED FOR THIS SETTINGS FILE, IF AN ERROR, IT
% MIGHT BE A VERSION PROBLEM
S.MarmoViewVersion = '1B';

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 300;

% PROTOCOL PREFIX
S.protocol = 'SpatialAcu';
% DEFAULT SUBJECT
S.subject = 'Sawyer';

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'SpatialAcuInit';
% "next trial" m-file
S.nextFunc = 'SpatialAcuNext';
% "run trial" m-file
S.runFunc = 'SpatialAcuRun';
% "finish trial" m-file
S.endFunc = 'SpatialAcuEnd';
% "plot trial" m-file
S.plotFunc = 'SpatialAcuPlot';

% Define Banner text to identify the experimental protocol
% recommend maximum of ~28 characters
S.protocolTitle = 'Spatial Acuity Task';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Reward setting
P.rewardNumber = 5;
S.rewardNumber = 'Number of juice pulses to deliver:';

% Stimulus settings

%************
%*********** a
%***** Day One
%P.acuScale = -0.4;  P.sampling_mid = 12.5; %11.5;   % 3 deg ecc .. change to 11
%P.acuScale = 0.4;   P.sampling_mid = 10; %8.5;    % 7 deg ecc ... change to 7.0
%*****Day Two
%P.acuScale = 0.6;   P.sampling_mid = 9; %7.5;   % 8 deg ecc
%P.acuScale = -0.2;  P.sampling_mid = 12.5;   % 4 deg ecc
%**** Day Three
P.acuScale = -0.6;  P.sampling_mid = 13.5;   % 2 deg ecc
%P.acuScale = 0.2;   P.sampling_mid = 10.5; %9.00;    % 6 deg ecc
%*** Day Four
%P.acuScale = 0.0;   P.sampling_mid = 12.5;    % 5 deg ecc
%P.acuScale = 0.6;   P.sampling_mid = 13.0;    % 1.5 deg ecc  %% HARD 
                                              %% drop 1.5 on Sawyer if need to
%********* Saturday with Jude, 7/23                                            
%P.acuScale = 0.4;   P.sampling_mid = 9.5;    % 7 deg ecc ... change to 7.0
%P.acuScale = -0.2;  P.sampling_mid = 12;   % 4 deg ecc

%****** Change monitor distance to 49cm for Day Five
%P.acuScale = 1.0;   P.sampling_mid = 9.5; %8; %6.5;   % 10 deg ecc
%P.acuScale = 1.2;  P.sampling_mid = 9; % 7; %5.5;    % 12 deg ecc .. 

% if a second repeat, we would invert the order each day

%******* IMPORTANT PARAMETER
%P.scale_size = 0; % don't scale 
P.scale_size = 1; % do scale
%*****************************

%P.acuScale = -0.7;  P.sampling_mid = 13.0; %10.5 %11.5; %13.0;  % 1.5 deg ecc

S.acuScale = '0 - 5 deg, 1 - 10 deg';
S.sampling_mid = 'Middle of SF Curve (at least 5):';
%************
P.cpd = 2;
S.cpd = 'Cycles per degree:';
P.apertures = 8;
S.apertures = 'Number of apertures:';
P.xDeg = 5.0 + (5.0 * P.acuScale); 
S.xDeg = 'X center of stimulus (degrees):';
P.yDeg = 0;
S.yDeg = 'Y center of stimulus (degrees):';
%*************
if (P.scale_size == 1)
  P.radius = 1.25 + (1.25 * P.acuScale);   % modify this down to a constant
else
  %P.radius = 1.0;   % go to 0.75 next time
  P.radius = 1.5;   % for distance testing
end
S.radius = 'Grating radius (degrees):';
P.apertureRadius = 2.0 + (2.0 * P.acuScale); %2.5;
S.apertureRadius = 'Aperture radius (degrees):';
P.apertureWidth = 5.0 + (5.0 * P.acuScale); %6;
S.apertureWidth = 'Width of aperture line (pixels):';
P.apertureColor = 127-5;   % was 127-5
S.apertureColor = 'Aperture color (0-255):';
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


% Gaze indicator
P.eyeRadius = 2.5; % 1.5;
S.eyeRadius = 'Gaze indicator radius (degrees):';
P.eyeIntensity = 5;
S.eyeIntensity = 'Indicator intensity:';
S.eyeColorStep = [2 -2 5]; % Directions to step bkgd for a gaze indicator
P.showEye = 0;
S.showEye = 'Show the gaze indicator? (0 or 1):';

%****** fixation properties
P.fixPointRadius = 0.3; % 0.75;  %for small face
S.fixPointRadius = 'Fix Point Radius (degs):';
P.probShowFace = 0;
S.probShowFace = 'Flash large face at fix to start (p=0.0):';

% Windows
P.initWinRadius = 1;
S.initWinRadius = 'Enter to initiate fixation (deg):';
P.fixWinRadius = 1.7; %1.5; %  by JM 3/10/16
S.fixWinRadius = 'Fixation window radius (deg):';
P.stimWinMinRad = 1.8; %1.75;  % by JM
S.stimWinMinRad = 'Minumum saccade from fixation (deg):';
P.stimWinMaxRad = 10 + (8*P.acuScale); %12; %10; by JM
S.stimWinMaxRad = 'Maximum saccade from fixation (deg):';
P.stimWinTheta = pi/5; %pi/7; by JM 3/10/16
S.stimWinTheta = 'Angular leeway for saccade (radians):';

% Trial timing
P.startDur = 4;
S.startDur = 'Time to enter fixation (s):';
P.flashFrameLength = 32;   % make it slow, 250 ms
S.flashFrameLength = 'Length of fixation flash (frames):';
P.fixGrace = 0.05;
S.fixGrace = 'Grace period to be inside fix window (s):';
P.fixMin = 0.2;
S.fixMin = 'Minimum fixation (s):';
P.fixRan = 0.3; 
S.fixRan = 'Random additional fixation (s):';
P.dimHold = 0.3;  % added time after fixation dimming
S.dimHold = 'Hold period with dim fixation(s):';
P.stimDur = 0.25;
S.stimDur = 'Duration of grating presentation (s):';
P.noresponseDur = 1.5;
S.noresponseDur = 'Duration to count error if no response(s):';
P.flightDur = 0.15;
S.flightDur = 'Time for saccade to finish (s):';
P.holdDur = 0.025;
S.holdDur = 'Duration at grating for reward (s):';
P.iti = 1;
S.iti = 'Duration of intertrial interval (s):';
P.blank_iti = 2;
S.blank_iti = 'Duration of blank intertrial(s):';
P.timeOut = 0;
S.timeOut = 'Time out for error (s):';

% Trials list -- x, y, cycPerDeg, phase, angle
P.distLum = 4;
S.distLum = 'Max distractor luminance:';
P.cueColor = 50; %75; % by JM 3/10/16   % 127 + 15;  % make it a pop-out by white/black 
S.cueColor = 'Contrast cue color (0-255):';
P.cueProbability = 0;
S.cueProbability = '% chance for conrast cue:';
P.cueDirection = 120; %180;
S.cueDirection = 'Give contrast cues within +/-90 deg (0-360):';
P.runType = 2;
S.runType = '0-User,1-Random,2-Trials List:';

% Viewpoint TTL control
P.vpxOutChannel = 7; % NOTE THAT THIS IS NOT THE INTAN INPUT, e.g. 7 --> 3
S.vpxOutChannel = 'TTL channels range 0-7:';

% Spatial frequency sampling
%S.sf_sampling = [1 2 3.3 4 5 6.7 10 20];
P.cutfreq = 20;   % max freq, and if this large then do not even show it

%S.sf_sampling = [2 3 4 5 6 7 8 9]; %[1 2 3.5 5 P.cutfreq];
%S.sf_sampling = [3 3.75 4.50 5.25 6.0 6.75 7.5 8.25 9]; 

S.sf_sampling = [3 4.50 5.5 6.25 6.75 7.25 7.75 8.25 9 10]; 
%S.sf_sampling = [4.50 5.5 6.25 6.75 7.25];
S.sf_sampling = S.sf_sampling - 7.0 + P.sampling_mid;  % no smaller than 5


%*******
% if (P.acuScale > 0)
%     S.sf_sampling = (S.sf_sampling / (1 + (0.5 * P.acuScale)));    
% end

% Eccentricity sampling, currently only using the radius specified above
S.r_sampling = norm([P.xDeg P.yDeg],2);
% Generate trials list
S.trialsList = [];
for zk = 1:size(S.sf_sampling,2)
    for k = 1:P.apertures   % do eight directions
    %for k = 2:2:P.apertures   % only diagonal locations for now
        ango = ((k-1) * 2 * pi)/P.apertures;  %/(P.apertures/2)) * 2 * pi;
        xpos = cos(ango) * S.r_sampling;
        ypos = sin(ango) * S.r_sampling;
        % Trials list is comprised of [P.xDeg P.yDeg P.cpd P.phase P.angle zk]
        mjuice = 2 + floor(S.sf_sampling(zk)/2);
        if (mjuice > P.rewardNumber)
            mjuice = P.rewardNumber;
        end
        S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk) 1  0 zk mjuice]];
        S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk) -1 0 zk mjuice]];
    end
end
