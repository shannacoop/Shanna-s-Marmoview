function [S,P] = MiloFaceForage

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD THE RIG SETTINGS, THESE HOLD CRUCIAL VARIABLES SPECIFIC TO THE RIG,
% IF A CHANGE IS MADE TO THE RIG, CHANGE THE RIG SETTINGS FUNCTION IN
% SUPPORT FUNCTIONS
% addpath(genpath('SupportFunctions'))
S = MarmoViewRigSettings;

% NOTE THE MARMOVIEW VERSION USED FOR THIS SETTINGS FILE, IF AN ERROR, IT
% MIGHT BE A VERSION PROBLEM
S.MarmoViewVersion = '1B';

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 500;

% PROTOCOL PREFIX
S.protocol = 'FaceForage';
% DEFAULT SUBJECT
S.subject = 'Milo';

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'FaceForageInit';
% "next trial" m-file
S.nextFunc = 'FaceForageNext'; 
% "run trial" m-file
S.runFunc = 'FaceForageRun';
% "finish trial" m-file
S.endFunc = 'FaceForageEnd';
% "plot trial" m-file
S.plotFunc = 'FaceForagePlot';

% Define Banner text to identify the experimental protocol
% recommend maximum of ~28 characters
S.protocolTitle = 'Forage stimuli for juice rewards!';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Stimulus settings
P.minStimN = 2;
S.minStimN = 'Minimum number of stimuli:';
P.ranStimN = 3;
S.ranStimN = 'Random additional stimuli:';
P.bkgd = 127;
S.bkgd = 'Choose a background color (0-255):';
% replace fix points with low pref faces
P.stimRadius1 = 1.5;
S.stimRadius1 = 'Radius for low faces (degrees):';
P.fixWin1 = 1.5;
S.fixWin1 = 'Windowing for low faces (degrees):';
P.reward1 = 1;
S.reward1 = 'Reward number for points:';
P.forageDur1 = .5;
S.forageDur1 = 'Fixation time to reward 1(s):';
% replace gratings with medium pref faces
P.stimRadius2 = 1.5;
S.stimRadius2 = 'Radius for medium faces (degrees):';
P.fixWin2 = 1.55;
S.fixWin2 = 'Windowing for medium faces (degrees):';
P.reward2 = 2;
S.reward2 = 'Reward number medium faces:';
P.forageDur2 = .5;
S.forageDur2 = 'Fixation time to reward 2(s):';
% faces of highest pref
P.stimRadius3 = 1.5;
S.stimRadius3 = 'Radius for high faces (degrees):';
P.fixWin3 = 1.5;
S.fixWin3 = 'Windowing for high faces';
P.reward3 = 4;
S.reward3 = 'Reward number for high faces:';
P.forageDur3 = .5;
S.forageDur3 = 'Fixation time to reward 3(s):';

% Gaze indicator
P.eyeRadius = 0.75;
S.eyeRadius = 'Gaze indicator radius (degrees):';
P.eyeIntensity = 4;
S.eyeIntensity = 'Indicator intensity:';
S.eyeColorStep = [2 -2 5]; % Directions to step bkgd for a gaze indicator
P.showEye = 0;
S.showEye = 'Show the gaze indicator? (0 or 1):';

% Trial timing
P.trialDur = 6;
S.trialDur = 'Duration of a trial (s):';
P.iti = 1;
S.iti = 'Duration of intertrial interval (s):';

% Viewpoint TTL control
P.vpxOutChannel = 3; % NOTE THAT THIS IS NOT THE INTAN INPUT, e.g. 3 --> 1
S.vpxOutChannel = 'TTL channels range 0-7:';

% Forage grid
S.forageNx = 5;
S.forageRNGx = 4;
S.forageNy = 5;
S.forageRNGy = 4;
%************
S.forageN = (S.forageNx*S.forageNy);
locos = [];
mx = floor((S.forageNx+1)/2);
my = floor((S.forageNy+1)/2);
mx2 = S.forageNx-mx;
my2 = S.forageNy-my;
%************      
for i = 1:S.forageNx
   sx = ((i-mx)/mx2) * S.forageRNGx;
   for j = 1:S.forageNy
      sy = ((j-my)/my2) * S.forageRNGy;
      locos = [locos ; [sx sy]];
   end
end
S.forageLocs = locos';
