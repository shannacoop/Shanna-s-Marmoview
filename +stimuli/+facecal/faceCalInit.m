function A = faceCalInit(S,A)

% function A = FaceCalInit(S,A)
%
% This function performs on-time needed steps to prepare the calibration
% protocol for running repeated trials of the task.

% START PSCH TOOLBOX
% Get rid of the Psychtoolbox welcome screen, Close any open windows
Screen('Preference','VisualDebuglevel',3); Screen('CloseAll');
% This is the first step in setting up the image processing properties of 
% a window for the psychophysics toolbox
PsychImaging('PrepareConfiguration');
% Uses 32 bit precision in displaying colors, if hardware can not handle
% this with alpha blending, consider dropping to 16 bit precision or using
% 'FloatingPoint32BitIfPossible', to drop precision while maintaining 
% alpha blending.
PsychImaging('AddTask','General','FloatingPoint32BitIfPossible');
% Applies a simple power-law gamma correction
% PsychImaging('AddTask','FinalFormatting','DisplayColorCorrection','SimpleGamma');
% Now the image processing properties are set, open the stimulus window
[A.window A.screenRect] = PsychImaging('OpenWindow',S.screenNumber,186,S.screenRect);
% Get the frame refresh rate of the stimulus window
A.frameRate = FrameRate(A.window);
% Set the the PTB motion server to maximum priority
A.priorityLevel = MaxPriority(A.window);
% Set alpha blending functions for antialiasing
Screen(A.window,'BlendFunction',GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

% CREATE FACE TEXTURES -- NOTE THAT THIS RELIES ON THE FACE DATA EXISTING
% IN THE MARMOVIEW SUPPORT DATA DIRECTORY!!

F = load('./SupportData/MarmosetFaceLibrary.mat');
faces = fields(F);
n = length(faces);
A.tex = nan(n,1);
A.texDim = nan(n,1);
for i = 1:n
    face = F.(faces{i});
    A.texDim(i) = length(face);
    [x,y] = meshgrid((1:A.texDim(i))-A.texDim(i)/2);
    g = exp(-(x.^2+y.^2)/(2*(A.texDim(i)/6)^2));
    %g = exp(-(x.^2+y.^2)/(2*(A.texDim(i)/5.0)^2));
    g = repmat(g,[1 1 3]);
    im = uint8((g.*double(face)) + 186*(1-g));  % Should be 127 if gamma, 186 if not
    A.tex(i) = Screen('MakeTexture',A.window,im);
end

% % Initialize the linking to the viewpoint library
% % NOTE THAT THE VIEWPOINT SOFTWARE MUST BE OPENED FIRST, OTHERWISE THE
% % DYNAMIC LINK LIBRARY WILL NOT BE READING OUT EYE POSITION
% vpx_Initialize;
% 
% % Set the TTL channels to 0, these will be used to align trials
% % These viewpoint outputs correspond to the --> Intan digital input
% vpx_SendCommandString('ttl_out -0');    % 0 --> 7
% vpx_SendCommandString('ttl_out -1');    % 1 --> 0
% vpx_SendCommandString('ttl_out -2');    % 2 --> 6
% vpx_SendCommandString('ttl_out -3');    % 3 --> 1
% vpx_SendCommandString('ttl_out -4');    % 4 --> 5
% vpx_SendCommandString('ttl_out -5');    % 5 --> 2
% vpx_SendCommandString('ttl_out -6');    % 6 --> 4
% vpx_SendCommandString('ttl_out -7');    % 7 --> 3
