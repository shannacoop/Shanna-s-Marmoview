
function S = MarmoViewRigSettings

% For use with MarmoView version 1C
%
% This function contains all settings for a particular rig, this way, when
% a change is made to the rig, all settings files do not need to be
% updated. This function MUST be located in a directory set in the MATLAB
% path so that it can both be called by MarmoView (in MarmoView directory)
% and by settings functions (in the MarmoView/Settings directory). I
% suggest SupportFunctions.
%
% For example, if you change the monitor set up, you only change those
% monitor related variables here.

S.pumpCom = 'COM3';                 % Comport the juicer pump is attached to
S.pumpDiameter = '20';              % Diameter of the juice syringe (mm)
S.pumpRate = '20 MM';               % Rate to deliver juice (set to max for quick pulses) (MM is mL per minute)
S.pumpDefVol = .01;                 % Default juice to deliver (mL)
S.monitor = 'BenQ-XL2411Z';         % Monitor used for display window

S.screenNumber = 2;                 % Designates the display for task stimuli
S.frameRate = 120;                  % Frame rate of screen in Hz
S.screenRect = [0 0 1920 1080];     % Screen dimensions in pixels
S.screenWidth = 53;                 % Width of screen (cm)
S.centerPix =  [960 540];           % Pixels of center of the screen
S.guiLocation = [800 300 890 660]; % Allows changing the gui location at initialization [x y width height]
                                    % This is useful so the gui doesn't get
                                    % trapped on the PsychToolbox screen

% S.screenNumber = 2;
% S.frameRate = 60;  % for IPAD
% S.screenRect = [0 0 1024 768];  % for IPAD    
% S.screenWidth = 19.75; %for IPAD
% S.centerPix = [512 384];  % for IPAD 
% S.guiLocation = [300 300 890 600];  %for IPAD

S.screenDistance = 57; %14; %29.2; %67.2; %36.8; %49.5; % measured in middle rig;   47.0;              % Distance of eye to screen (cm)
% S.screenDistance = 124.7;
% S.screenDistance = 140.7;         % For 15 cycles per degree with 6 pixels per cycle
S.pixPerDeg = PixPerDeg(S.screenDistance,S.screenWidth,S.screenRect(3));

%S.pixPerDeg
%input('wait');

S.gamma = 2.2;                      % Single value gamma correction, this
                                    % works for BenQ, others might need a
                                    % table based correction
S.pdRect = [0 1015 65 1080];        % Screen location of photodiode
