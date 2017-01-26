function [S,P] = MiloForage

% IT MAY BE USEFUL TO NOTE THE LAST COMPATIBLE VERSION OF MARMOVIEW HERE
S.MarmoViewVersion = '1A';

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 500;

% PROTOCOL PREFIX
S.protocol = 'Forage';
% DEFAULT SUBJECT
S.subject = 'Milo';

% DEFINE THE TASK FUNCTIONS 
% "initialization" m-file
S.initFunc = 'ForageInit';
% "next trial" m-file
S.nextFunc = 'ForageNext';
% "run trial" m-file
S.runFunc = 'ForageRun';
% "finish trial" m-file
S.endFunc = 'ForageEnd';
% "plot trial" m-file
S.plotFunc = 'ForagePlot';

% Define Banner text to identify the experimental protocol
% recommend maximum of ~28 characters
S.protocolTitle = 'Forage stimuli for juice rewards!';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DISPLAY/RIG SETTINGS -- VALUES THAT DO NOT CHANGE WHILE RUNNING
S.monitor = 'BenQ-XL2411Z';         % Monitor used
S.screenNumber = 1;                 % Designates the display for task stimuli
S.frameRate = 120;                  % Frame rate of screen in Hz
S.screenRect = [0 0 1920 1080];     % Screen dimensions in pixels
S.screenWidth = 53;                 % Width of screen (cm)
S.screenDistance = 171.0;           % Distance of eye to screen (cm)
ScreenDeg = 2*atan2(S.screenWidth/2,S.screenDistance)*(180/pi);
S.pixPerDeg = S.screenRect(3)/ScreenDeg;
S.centerPix = [940 540];            % Pixels of center of the screen
S.gamma = 2.2;                      % Single vlaue gamma correction
S.eyeColor = [167 95 207];         % Color of the gaze indicator
S.guiLocation = [800 -700 890 660]; % Allows changing the gui location at initialization
                                    % This is useful so the gui doesn't get
                                    % trapped on the PsychToolbox screen

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Stimulus settings
P.minStimN = 4;
S.minStimN = 'Minimum number of stimuli:';
P.ranStimN = 4;
S.ranStimN = 'Random additional stimuli:';
P.bkgd = 127;
S.bkgd = 'Choose a background color (0-255):';
% fixation points
P.stimRadius1 = .25;
S.stimRadius1 = 'Radius for points (degrees):';
P.fixWin1 = 1.5;
S.fixWin1 = 'Windowing for points (degrees):';
P.reward1 = 2;
S.reward1 = 'Reward number for points:';
P.forageDur1 = .6;
S.forageDur1 = 'Fixation time to reward 1(s):';
S.colors = {[255 0],[0 255]};
% gratings
P.stimRadius2 = 2;
S.stimRadius2 = 'Radius for gratings (degrees):';
P.fixWin2 = 1.5;
S.fixWin2 = 'Windowing for gratings (degrees):';
P.reward2 = 3;
S.reward2 = 'Reward number for gratings:';
P.forageDur2 = .6;
S.forageDur2 = 'Fixation time to reward 2(s):';
S.cpds = [6 9 12];
S.angles = [0 45 90 135];
S.phases = [0 180];
S.ranges = 127;
% faces
P.stimRadius3 = 1;
S.stimRadius3 = 'Radius for faces (degrees):';
P.fixWin3 = 1.5;
S.fixWin3 = 'Windowing for faces';
P.reward3 = 1;
S.reward3 = 'Reward number for faces:';
P.forageDur3 = 1;
S.forageDur3 = 'Fixation time to reward 3(s):';

% Gaze indicator
P.eyeRadius = 0.6;
S.eyeRadius = 'Gaze indicator radius (degrees):';
P.showEye = 1;
S.showEye = 'Show the gaze indicator? (0 or 1):';

% Trial timing
P.trialDur = 10;
S.trialDur = 'Duration of a trial (s):';
P.iti = 1;
S.iti = 'Duration of intertrial interval (s):';

% Forage grid
S.forageN = 15;
S.forageLocs =[-8 -4  0  4  8 -8 -4  0  4  8 -8 -4  0  4  8;
                4  4  4  4  4  0  0  0  0  0 -4 -4 -4 -4 -4];