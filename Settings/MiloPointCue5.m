
function [S,P] = MiloPointCue5

%%%% NECESSARY VARIABLES FOR GUI
%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOAD THE RIG SETTINGS, THESE HOLD CRUCIAL VARIABLES SPECIFIC TO THE RIG,
% IF A CHANGE IS MADE TO THE RIG, CHANGE THE RIG SETTINGS FUNCTION IN
% SUPPORT FUNCTIONS
S = MarmoViewRigSettings;

% NOTE THE MARMOVIEW VERSION USED FOR THIS SETTINGS FILE, IF AN ERROR, IT
% MIGHT BE A VERSION PROBLEM
S.MarmoViewVersion = '1B';

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 400;

% PROTOCOL PREFIX
S.protocol = 'PointCue';
% DEFAULT SUBJECT
S.subject = 'Milo';

%********* store the vpx file
S.EyeDump = 1;

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'PointCueInit5';
% "next trial" m-file
S.nextFunc = 'PointCueNext5';
% "run trial" m-file
S.runFunc = 'PointCueRun5';
% "finish trial" m-file
S.endFunc = 'PointCueEnd5';
% "plot trial" m-file
S.plotFunc = 'PointCuePlot5';

% Define Banner text to identify the experimental protocol
% recommend maximum of ~28 characters
S.protocolTitle = 'Symbolic Point Cue Task';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Reward setting
P.rewardNumber = 10;
S.rewardNumber = 'Number of juice pulses to deliver:';
P.rewardFarSaccade = 1;
S.rewardFarSaccade = 'Give more juice for larger saccade: ';
P.delayNumber = 1;  % default

% Stimulus settings
P.cpd = 2;
S.cpd = 'Cycles per degree:';
P.delay = 1.0;
S.delay = 'Delay(s):';
P.dotdelay = .30;
S.dotdelay = 'Extra dot time(s):';
P.apertures = 8;
S.apertures = 'Number of apertures:';
P.xDeg = 5.0; %6.0; %7.5;
S.xDeg = 'X center of stimulus (degrees):';
P.yDeg = 0;
S.yDeg = 'Y center of stimulus (degrees):';
P.radius = 3;
S.radius = 'Grating radius (degrees):';
P.apertureRadius =  1.4;
S.apertureRadius = 'Aperture radius (degrees):';
P.cueRadius = 2.0; 
S.cueRadius = 'Cue radius (degrees):';

P.apertureWidth = 4;
S.apertureWidth = 'Width of aperture line (pixels):';
%***********
P.apertureColor = 127+30; %127-5;
S.apertureColor = 'Aperture color (0-255):';
P.apertureFade = 0.7; %increment to increase lum per frame
S.apertureFade = 'Aperture fade in (0-5):';
%*******
P.dotColor = 127-30; %127-5;
S.dotColor = 'Dot color (0-255):';
P.dotFade = -0.7; %increment to increase lum per frame
S.dotFade = 'Dot fade in (0-5):';
P.dotSpeed = 5; 
S.dotSpeed = 'Dot Speed (Degree per sec):';
P.dotSize = 0.15; 
S.dotSize = 'Dot Size (Degree):';


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
P.cuetype = 0;
S.cuetype = '0 - solid line cue, 1 - dotted line cue';
P.cuecolor = 0;
S.cuecolor = '0 - black, 255 - white';
P.cueProb = 0.0;
S.cueProb = '(0.0 to 1.0) prob the cue will be black vs white';
P.width1 = 0.075;
S.width1 = 'Cue line width in degs';
P.sigma1 = 2.5;
S.sigma1 = 'Cue line width near fixation';
P.sigma2 = 0;
S.sigma2 = 'Cue line width near target';
P.amp1 = 1.0;
S.amp1 = 'Cue line amp near fixation';
P.amp2 = 0.75;
S.amp2 = 'Cue line amp near target';


% Gaze indicator
P.eyeRadius = 1.5; % 1.5;
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
P.initWinRadius = 1;
S.initWinRadius = 'Enter to initiate fixation (deg):';
P.fixWinRadius = 1.5;  %by JM 3/10/16
S.fixWinRadius = 'Fixation window radius (deg):';
P.stimWinMinRad = 3.0; % by JM
S.stimWinMinRad = 'Minumum saccade from fixation (deg):';
P.stimWinMaxRad = 10; %10; by JM
S.stimWinMaxRad = 'Maximum saccade from fixation (deg):';
P.stimWinTheta = pi/6; 
S.stimWinTheta = 'Angular leeway for saccade (radians):';

% Trial timing
P.startDur = 4;
S.startDur = 'Time to enter fixation (s):';
P.flashFrameLength = 32;   % make it slow, 250 ms
S.flashFrameLength = 'Length of fixation flash (frames):';
P.flashFrameLengthBreak = 8;   % make it slow, 250 ms
S.flashFrameLengthBreak = 'Length of fixation flash after breaks (frames):';
P.fixGrace = 0.05;   %50 ms, making sure not a saccade through fixation
S.fixGrace = 'Grace period to be inside fix window (s):';
P.fixMin = 0.10;  
S.fixMin = 'Minimum fixation (s):';
P.fixRan = 0.3;
S.fixRan = 'Random additional fixation (s):';
%P.faceShift = 1.0;  % cue direction this much before stim
%S.faceShift = 'Shift Face towards target (degs):';
P.stimForwardDur = 0.10;   % was 0.3!!! too long
S.stimForwardDur = 'Duration of fixation hold from line cue:';
P.stimGazeDur = 0.1;
S.stimGazeDur = 'Duration of gaze cue face:';

P.noresponseDur = 1.5;
S.noresponseDur = 'Duration to count error if no response(s):';
P.flightDur = 0.07;
S.flightDur = 'Time for saccade to finish (s):';
P.holdDur = 0.025;
S.holdDur = 'Duration at grating for reward (s):';
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
P.cueDelayMin = 0.6;
S.cueDelayMin = 'Min Delay (secs) on Cue:';
P.cueDelayMax = 0.8;
S.cueDelayMax = 'Max Delay (secs) on Cue:';
P.runType = 2;
S.runType = '0-User,1-Random,2-Trials List:';

%*********** Limit number of fixation trials ******** 
P.minCueCount = 2;  % min correct in cue task before allow a fixation trial
S.minCueCount = 'Min Cued Response before a fix trial: ';

% Viewpoint TTL control
P.vpxOutChannel = 7; % NOTE THAT THIS IS NOT THE INTAN INPUT, e.g. 7 --> 3
S.vpxOutChannel = 'TTL channels range 0-7:';

% % Delay time sampling 
%S.sf_sampling =    [ 5.0   4.0    2.5   1.8  1.2   0.1];  % original
%S.sf_sampling =     [  5.0   3.5   2.5    1.4   1.0  0.1];  %12/27 start
%S.sf_sampling =     [  5.0   3.0   2.0   1.2   0.8  0.1];  %12/28
%S.sf_sampling =     [  4.0   2.5   1.5   1.0   0.7  0.1];   %12/30
%S.sf_sampling =     [  3.5   2.5   1.2   0.9   0.7  0.1];  %1/3  %step back 1/16
%S.sf_sampling =     [  3.0   2.0   1.0   0.9   0.7  0.1];   %1/5
%S.sf_sampling =     [  2.5   1.4   0.9   0.8   0.7  0.1];
%S.sf_sampling =     [  1.8   1.5   1.2   1.0   0.8  0.1];
%S.sf_sampling =     [  1.4   1.2   1.1   1.0   0.8  0.1];
S.sf_sampling =     [  1.2   1.1   1.0   0.9   0.8  0.1];

%start from identical point in training
%P.dotColor = 127;  P.dotFade = -0.2; P.apertureWidth = 4;  P.apertureRadius =  1.4;   %1/16   
%P.dotColor = 124;  P.dotFade = -0.2; P.apertureWidth = 4;  P.apertureRadius =  1.4;   %   
%P.dotColor = 122;  P.dotFade = -0.3; P.apertureWidth = 3;  P.apertureRadius =  1.4;   %  end of 1/16 
%P.dotColor = 115;  P.dotFade = -0.5; P.apertureWidth = 3;  P.apertureRadius =  1.4;   %   
%P.dotColor = 107;  P.dotFade = -0.7; P.apertureWidth = 2;  P.apertureRadius =  1.4;   %   
%P.dotColor = 97;   P.dotFade = -1.0; P.apertureWidth = 2;  P.apertureRadius =  1.4;   %   
%P.dotColor = 87;   P.dotFade = -1.2; P.apertureWidth = 1;  P.apertureRadius =  1.4;   %   
%P.dotColor = 77;   P.dotFade = -1.3; P.apertureWidth = 1;  P.apertureRadius =  1.4;   %   
%P.dotColor = 67;   P.dotFade = -1.4; P.apertureWidth = 0;  P.apertureRadius =  1.5;   %   
%P.dotColor = 45;   P.dotFade = -1.6; P.apertureWidth = 0;  P.apertureRadius =  1.6;   %   
%P.dotColor = 30;   P.dotFade = -1.8; P.apertureWidth = 0;  P.apertureRadius =  1.8;   %   
P.dotColor = 0;    P.dotFade = -2.0; P.apertureWidth = 0;  P.apertureRadius =  2.0;   %   



% S.sf_sampling = P.sigma1;
S.delay_sampling =  [0.020 0.021 0.022 0.023 0.024  0.3]; %[0.05 0.08 0.12 0.20 .6]; %[0.03 0.05 0.08 0.12 0.20]; %[0.03 0.05 0.075 ];
P.delay_juice =     [  2     2    3   5    8    4];
P.delay_max = size(S.delay_sampling,2); % Cue length sampling
% Eccentricity sampling, currently only using the radius specified above
S.r_sampling = norm([P.xDeg P.yDeg],2);
% Generate trials list
S.trialsList = [];

for zzk = 1:size(S.delay_sampling,2)
      for k = 1:P.apertures  % do eight directions
           %for k = 2:2:P.apertures   % only diagonal locations for now
            ango = ((k-1) * 2 * pi)/P.apertures;  %/(P.apertures/2)) * 2 * pi;
            xpos = cos(ango) * S.r_sampling;
            ypos = sin(ango) * S.r_sampling;     
            % Trials list is comprised of [P.xDeg P.yDeg P.cpd P.phase P.angle zk]
            %mjuice = 5 - floor(S.sf_sampling(zk)*1.5);
            %mmjuice = [5 4 3 1 1];
            mmjuice = 1;
            mnjuice = P.delay_juice(zzk); 
            mjuice = mmjuice + mnjuice;
            if (mjuice > P.rewardNumber)
                mjuice = P.rewardNumber;
            end
            if (rand(1) < P.cueProb) 
                P.cuecolor = 0;
            else 
                P.cuecolor = 255;
            end 
            S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zzk) 1  0 zzk mjuice S.delay_sampling(zzk) zzk P.cuecolor]];
            S.trialsList = [S.trialsList ; [xpos ypos S.sf_sampling(zzk) -1  0 zzk mjuice S.delay_sampling(zzk) zzk P.cuecolor]];
      end
end
