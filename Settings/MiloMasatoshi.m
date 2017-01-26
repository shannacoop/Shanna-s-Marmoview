function [S,P] = MiloMasatoshi

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD THE RIG SETTINGS, THESE HOLD CRUCIAL VARIABLES SPECIFIC TO THE RIG,
% IF A CHANGE IS MADE TO THE RIG, CHANGE THE RIG SETTINGS FUNCTION IN
% SUPPORT FUNCTIONS
S = MarmoViewRigSettings;

% NOTE THE MARMOVIEW VERSION USED FOR THIS SETTINGS FILE, IF AN ERROR, IT
% MIGHT BE A VERSION PROBLEM
S.MarmoViewVersion = '1B';

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 56;

% PROTOCOL PREFIX
S.protocol = 'Masatoshi';
% DEFAULT SUBJECT
S.subject = 'Milo';

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'MasatoshiInit';
% "next trial" m-file
S.nextFunc = 'MasatoshiNext';
% "run trial" m-file
S.runFunc = 'MasatoshiRun';
% "finish trial" m-file
S.endFunc = 'MasatoshiEnd';
% "plot trial" m-file
S.plotFunc = 'MasatoshiPlot';

% Define Banner text to identify the experimental protocol
S.protocolTitle = 'Masatoshi Free View';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This settings is unnecessary because 'MarmoViewLastCalib.mat' is the GUI
% default to use, but because this is an exemplar protocol I decided to
% includee it if for some reason you don't want to use the last calibration
% values (e.g. subjects you are running have substantially different 
% horizontal or vertical gain). Place this calibration file in the
% 'SupportData' directory of MarmoView
S.calibFilename = 'MarmoViewLastCalib.mat';

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Stimulus settings
P.imageIndex = 1;
S.imageIndex = 'Index of image to show:';
P.eyeRadius = 1.5;
S.eyeRadius = 'Gaze indicator radius (degrees):';
P.eyeIntensity = 4;
S.eyeIntensity = 'Indicator intensity:';
S.eyeColorStep = [6 -4 12]; % Directions to step bkgd for a gaze indicator
P.showEye = 0;
S.showEye = 'Show the gaze indicator? (0 or 1):';
P.bkgd = 0;
S.bkgd = 'Choose the background color (0-255):';

% Trial timing
P.imageDur = 8;
S.imageDur = 'Duration to display faces (s):';
P.iti = 3;
S.iti = 'Duration of intertrial interval (s):';

% Viewpoint TTL control
P.vpxOutChannel = 4; % NOTE THAT THIS IS NOT THE INTAN INPUT, e.g. 4 --> 5
S.vpxOutChannel = 'Viewpoint TTL to use (0-7):';
             