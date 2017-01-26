function [S,P] = MiloFaceCal

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD THE RIG SETTINGS, THESE HOLD CRUCIAL VARIABLES SPECIFIC TO THE RIG,
% IF A CHANGE IS MADE TO THE RIG, CHANGE THE RIG SETTINGS FUNCTION IN
% SUPPORT FUNCTIONS
S = MarmoViewRigSettings;

% NOTE THE MARMOVIEW VERSION USED FOR THIS SETTINGS FILE, IF AN ERROR, IT
% MIGHT BE A VERSION PROBLEM
S.MarmoViewVersion = '1B';

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 100;

% PROTOCOL PREFIX
S.protocol = 'FaceCal';
% DEFAULT SUBJECT
S.subject = 'Milo';

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'FaceCalInit';
% "next trial" m-file
S.nextFunc = 'FaceCalNext';
% "run trial" m-file
S.runFunc = 'FaceCalRun';
% "finish trial" m-file
S.endFunc = 'FaceCalEnd';
% "plot trial" m-file
S.plotFunc = 'FaceCalPlot';

% Define Banner text to identify the experimental protocol
S.protocolTitle = 'Face Eye Calibration';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This settings is unnecessary because 'MarmoViewLastCalib.mat' is the GUI
% default to use, but because this is an exemplar protocol I decided to
% includee it if for some reason you don't want to use the last calibration
% values (e.g. subjects you are running have substantially different 
% horizontal or vertical gain). Place this calibration file in the
% 'SupportData' directory of MarmoView
S.calibFilename = 'MarmoViewLastCalib.mat';

% If using the gaze indicator, this sets a step value, intensity should be
% between 1 and 5, this is taking advantage of male color blindness to make
% it less obvious to the marmoset than us, but it will still be obvious if
% overwriting textures

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Stimulus settings
P.faceConfig = 1;
S.faceConfig = 'Index of face configuration (1-14):';
P.faceRadius = 1.5;
S.faceRadius = 'Aperture radius (degrees):';
P.eyeRadius = 1.5;
S.eyeRadius = 'Gaze indicator radius (degrees):';
P.eyeIntensity = 4;
S.eyeIntensity = 'Indicator intensity:';
S.eyeColorStep = [6 -4 12]; % Directions to step bkgd for a gaze indicator
P.showEye = 1;
S.showEye = 'Show the gaze indicator? (0 or 1):';
P.bkgd = 186;
S.bkgd = 'Choose the background color (0-255):';

% Trial timing
P.faceDur = 2;
S.faceDur = 'Duration to display faces (s):';
P.iti = 3;
S.iti = 'Duration of intertrial interval (s):';

% Viewpoint TTL control
P.vpxOutChannel = 1; % NOTE THAT THIS IS NOT THE INTAN INPUT, e.g. 1 --> 0
S.vpxOutChannel = 'Viewpoint TTL to use (0-7):';

% Configuration possibilities for faces (x deg, y deg, face (1-30))
d = 5;  % indicates a degree step size to change expanse of the calibration
S.faceConfigs = {[0 0 1];
                 [0 0 2]
                 [0 0 3]
                 [0 0 4]
                 [0 0 5]
                 [0 0 6]
                 [0 0 7; -1*d 0 8]  % horizontals
                 [0 0 8; 1*d 0 9]
                 [0 0 9; -1*d 0 10; 1*d 0 11]
                 [0 0 11; 0 -1*d 12]  % verticals
                 [0 0 12; 0 1*d 13]
                 [0 0 13; 0 -1*d 14; 0 +1*d 15]
                 [-1*d 0 1; 1*d 0 30; 0 -1*d 11; 0 1*d 23] % cross
                 [-1*d -1*d 24; -1*d 1*d 3; 1*d 1*d 7; 1*d -1*d 27]  % corners
                 [-2*d 0 22; -1*d 0 1; 0 0 16; 1*d 0 30; 2*d 0 9; 0 -1*d 11; ...
                 0 -2*d 14; 0 1*d 23; 0 2*d 25] % doble cross hairs
                 [-1*d 0 1; 1*d 0 30; 0 -1*d 11; 0 1*d 23; ... % cross and corners
                 -1*d -1*d 24; -1*d 1*d 3; 1*d 1*d 7; 1*d -1*d 27]  % corners
                 [-2*d 0 22; 0 0 16; 2*d 0 9; 0 -2*d 14; 0 2*d 25] % far cross hairs
                 [-1*d -1*d 24; -1*d -2*d 3; -2*d -1*d 7] % far single corners
                 [1*d 1*d 10; 1*d 2*d 4; 2*d 1*d 9]
                 [-1*d 1*d 11; -1*d 2*d 12; -2*d 1*d 13]
                 [1*d -1*d 14; 1*d -2*d 15; 2*d -1*d 16]
                 [-2*d -2*d 24; -2*d 2*d 3; 2*d 2*d 7; 2*d -2*d 27]  %far four corners
                 };
%S.faceConfigs = {[0 0 2];
%                 [0 0 6];
%                 [0 0 8];
%                 [0 0 15; -1*d 0 13]
%                 [0 0 20; 1*d 0 9]
%                 [0 0 26; 0 -1*d 10; 0 1*d 18]
%                 [-1*d -1*d 24; -1*d 1*d 3; 1*d 1*d 7; 1*d -1*d 27]
%                 [-2*d 0 22; -1*d 0 1; 0 0 16; 1*d 0 30; 2*d 0 9; 0 -1*d 11; ...
%                 0 -2*d 14; 0 1*d 23; 0 2*d 25]
%                 [-1*d -1*d 24; -1*d -2*d 3; -2*d -1*d 7]
%                 [1*d 1*d 10; 1*d 2*d 4; 2*d 1*d 9]
%                 [-1*d 1*d 11; -1*d 2*d 12; -2*d 1*d 13]
%                 [1*d -1*d 14; 1*d -2*d 15; 2*d -1*d 16]
%                 [-2*d -2*d 24; -2*d 2*d 3; 2*d 2*d 7; 2*d -2*d 27]
%                 [-3*d 0 24; 0 2*d 3; 0 -2*d 7; 3*d 0 27]
%                 [0 0 4; 0 1*d 20]};
             