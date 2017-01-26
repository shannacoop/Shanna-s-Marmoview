function [S,P] = MiloFaceMotion

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD THE RIG SETTINGS, THESE HOLD CRUCIAL VARIABLES SPECIFIC TO THE RIG,
% IF A CHANGE IS MADE TO THE RIG, CHANGE THE RIG SETTINGS FUNCTION IN
% SUPPORT FUNCTIONS
S = MarmoViewRigSettings;

% NOTE THE MARMOVIEW VERSION USED FOR THIS SETTINGS FILE, IF AN ERROR, IT
% MIGHT BE A VERSION PROBLEM
S.MarmoViewVersion = '1C';

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 500;
S.EyeDump = 1;   %IMPORTANT, tell it to dump eye data to file, 220 hz

% PROTOCOL PREFIX
S.protocol = 'FaceMotion';
% DEFAULT SUBJECT
S.subject = 'Milo';

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'FaceMotionInit';
% "next trial" m-file
S.nextFunc = 'FaceMotionNext'; 
% "run trial" m-file
S.runFunc = 'FaceMotionRun';
% "finish trial" m-file
S.endFunc = 'FaceMotionEnd';
% "plot trial" m-file
S.plotFunc = 'FaceMotionPlot';

% Define Banner text to identify the experimental protocol
% recommend maximum of ~28 characters
S.protocolTitle = 'Face motion selection task';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Reward volume
P.rewardVol = 15;
S.rewardVol = 'Reward volume (uL):';

% Stimulus settings
P.forageN = 5;
S.forageN = 'Number of faces to forage:';
P.faceRadius = 1;
S.faceRadius = 'Radius of faces (deg):';
P.winRadius = 2;
S.winRadius = 'Radius to forage (deg):';
P.forageFrames = 45;
S.forageFrames = 'Time to forage (frames):';
P.motionDir = 0;    % other face will be +180 deg (opposing)
S.motionDir = 'Angle of face1 motion (deg):';
P.motionSpeed = 10; % Rounded to whole number of pix per frame for H and V
S.motionSpeed = 'Face speed (deg/s):';

% Parameters for face seeding at gaze position
P.motionStep = 12;
S.motionStep = 'Step of faces (frames):';
P.motionDistance = 5;
S.motionDistance = 'Face onset distance (deg);';
P.motionSide = 0;
S.motionSide = '0 Random, 1 +ve, 2 -ve:';
P.onSameSide = 0;
S.onSameSide = '1 for faces on same side:';

% Field settings
P.bkgd = 127;
S.bkgd = 'Color outside of the field (0-255):';

% Gaze indicator
P.eyeRadius = 1;
S.eyeRadius = 'Gaze indicator radius (deg):';
P.eyeIntensity = 12;
S.eyeIntensity = 'Indicator intensity:';
S.eyeColorStep = [2 -2 5]; % Directions to step bkgd for a gaze indicator
P.showEye = 0;
S.showEye = 'Set to 1 for gaze indicator:';

% Trial settings
P.forageDur = 5;
S.forageDur = 'Duration to forage a face (s):';
P.motionDur = 0.8;
S.motionDur = 'Duration of moving faces (s):';
P.stopDur = 0.8;
S.stopDur = 'Duration to stop faces (s)';
P.iti = 1.5;
S.iti = 'Duration of intertrial interval (s):';

% Viewpoint TTL control
P.vpxOutChannel = 3; % NOTE THAT THIS IS NOT THE INTAN INPUT, e.g. 3 --> 1
S.vpxOutChannel = 'TTL channels range 0-7:';

% Photodiode mode flag -- will flicker a rectangle in top left corner from
% black to white to black aligned to frame flips
P.usePhotodiode = 1;
S.usePhotodiode = 'Set to 1 if using photodiode:';

% Trials list control
P.useTrialsList = 1;
S.useTrialsList = 'Set to 1 to use a trials list:';
% Generate trials list, col1 - speed, col2 - face1dir, col3 - Psameside
S.trialsList = [5   0   0;
                5   45  0;
                5   90  0;
                5   135 0;
                10  0   0;
                10  45  0;
                10  90  0;
                10  135 0;
                15  0   0;
                15  45  0;
                15  90  0;
                15  135 0;
                5   0   1;
                5   45  1;
                5   90  1;
                5   135 1;
                10  0   1;
                10  45  1;
                10  90  1;
                10  135 1;
                15  0   1;
                15  45  1;
                15  90  1;
                15  135 1];