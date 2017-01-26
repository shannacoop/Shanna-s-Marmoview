function [S,P] = RDPop

%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD THE RIG SETTINGS, THESE HOLD CRUCIAL VARIABLES SPECIFIC TO THE RIG,
% IF A CHANGE IS MADE TO THE RIG, CHANGE THE RIG SETTINGS FUNCTION IN
% SUPPORT FUNCTIONS
S = MarmoViewRigSettings;

% NOTE THE MARMOVIEW VERSION USED FOR THIS SETTINGS FILE, IF AN ERROR, IT
% MIGHT BE A VERSION PROBLEM
S.MarmoViewVersion = '1B';

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 500;

% PROTOCOL PREFIX
S.protocol = 'RDPop';
% DEFAULT SUBJECT
S.subject = 'Sunwoo';

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'RDPopInit';
% "next trial" m-file
S.nextFunc = 'RDPopNext';
% "run trial" m-file
S.runFunc = 'RDPopRun';
% "finish trial" m-file
S.endFunc = 'RDPopEnd';
% "plot trial" m-file
S.plotFunc = 'RDPopPlot';

% Define Banner text to identify the experimental protocol
% recommend maximum of ~28 characters
S.protocolTitle = 'Gaze Cue Task with Random Dots';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Reward setting
P.rewardNumber = 2;
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
P.radius = 2;
S.radius = 'Grating radius (degrees):';
P.apertureRadius = 2.0; %2.5;
S.apertureRadius = 'Aperture radius (degrees):';
P.apertureWidth = 4.0; %6;
S.apertureWidth = 'Width of aperture line (pixels):';
P.apertureColor = 127-12; %127-5;
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
S.eyeColorStep = [20 -20 50]; % Directions to step bkgd for a gaze indicator
P.showEye = 0;
S.showEye = 'Show the gaze indicator? (0 or 1):';

%****** fixation properties
P.fixPointRadius = 0.50;  %for small cross
S.fixPointRadius = 'Fix Point Radius (degs):';
P.probShowFace = 0;
S.probShowFace = 'Flash large face at fix to start (p=0.0):';

% Windows
P.initWinRadius = 1;
S.initWinRadius = 'Enter to initiate fixation (deg):';
P.fixWinRadius = 3.0; %2.0;  by JM 3/10/16
S.fixWinRadius = 'Fixation window radius (deg):';
P.stimWinMinRad = 3.5; %2.25; by JM
S.stimWinMinRad = 'Minumum saccade from fixation (deg):';
P.stimWinMaxRad = 12; %10; by JM
S.stimWinMaxRad = 'Maximum saccade from fixation (deg):';
P.stimWinTheta = pi/6; %pi/7; by JM 3/10/16
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
P.fixRan = 0.1;
S.fixRan = 'Random additional fixation (s):';
P.faceShift = 1.0;  % cue direction this much before stim
S.faceShift = 'Shift Face towards target (degs):';
P.stimDur = 0.30;
S.stimDur = 'Duration of grating presentation (s):';
P.noresponseDur = 1.5;
S.noresponseDur = 'Duration to count error if no response(s):';
P.flightDur = 0.075;
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
P.cueColor = 75; % by JM 3/10/16   % 127 + 15;  % make it a pop-out by white/black 
S.cueColor = 'Contrast cue color (0-255):';
P.cueProbability = 0;
S.cueProbability = '% chance for conrast cue:';
P.cueDirection = 180;
S.cueDirection = 'Give contrast cues within +/-90 deg (0-360):';
P.runType = 2;
S.runType = '0-User,1-Random,2-Trials List:';

% Viewpoint TTL control
P.vpxOutChannel = 7; % NOTE THAT THIS IS NOT THE INTAN INPUT, e.g. 7 --> 3
S.vpxOutChannel = 'TTL channels range 0-7:';

% Spatial frequency sampling
%S.sf_sampling = [1 2 3.3 4 5 6.7 10 20];
P.cutfreq = 20;   % max freq, and if this large then do not even show it

S.sf_sampling = [1 1.5 2 2.5]; % [0 0.25 0.5 1 1.5 2]; %[1 2 3.5 5 P.cutfreq];
% Eccentricity sampling, currently only using the radius specified above
S.r_sampling = norm([P.xDeg P.yDeg],2);
% Generate trials list
S.trialsList = [];
motion_angle = 0;
P.initial    = 0;
for zk = 1:size(S.sf_sampling,2)
    for k = 1:P.apertures   % do eight directions
%     for k = 2:2:P.apertures   % only diagonal locations for now
        ango = ((k-1) * 2 * pi)/P.apertures;  %/(P.apertures/2)) * 2 * pi;
        xpos = cos(ango) * S.r_sampling;
        ypos = sin(ango) * S.r_sampling;
        motion_angle = motion_angle+1;
        
        if motion_angle>8,
            motion_angle = 1;
        end
        
        % Trials list is comprised of [P.xDeg P.yDeg P.cpd P.phase P.angle zk]
        mjuice = 2 + floor(S.sf_sampling(zk)/2);
        if (mjuice > P.rewardNumber)
            mjuice = P.rewardNumber;
        end
        S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk)  1 0 zk mjuice ango motion_angle]];
        S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zk) -1 0 zk mjuice ango motion_angle]];
        
    end
end
