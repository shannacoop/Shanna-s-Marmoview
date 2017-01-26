function A = spatialAcuInit(S,A)

% function A = spatialAcuInit(S,A)
%
% This function performs on-time needed steps to prepare the calibration
% protocol for running repeated trials of the task.

viewpoint = true; % FIXME: for now, assume the ViewPoint eye tracker is present...
if isfield(S,'viewpoint'),
  viewpoint = S.viewpoint; % allows one to turn off the eye tracker in the rig settings
end

% START PSYCH TOOLBOX
% Get rid of the Psychtoolbox welcome screen, Close any open windows
Screen('Preference','VisualDebuglevel',3); Screen('CloseAll');
% These commands ready the PTB motion server for the VIEWPixx 2-CLUT system
% This is the first step in setting up the image processing properties of 
% a window for the psychophysics toolbox
PsychImaging('PrepareConfiguration');
% Uses 32 bit precision in displaying colors, if hardware can not handle
% this with alpha blending, consider dropping to 16 bit precision or using
% 'FloatingPoint32BitIfPossible', to drop precision while maintaining 
% alpha blending.
PsychImaging('AddTask','General','FloatingPoint32BitIfPossible');
% Applies a simple power-law gamma correction
PsychImaging('AddTask','FinalFormatting','DisplayColorCorrection','SimpleGamma');
% Now the image processing properties are set, open the stimulus window
[A.window A.screenRect] = PsychImaging('OpenWindow',S.screenNumber,127,S.screenRect);
% Add gamma correction
PsychColorCorrection('SetEncodingGamma',A.window,1/S.gamma);
% Get the frame refresh rate of the stimulus window
A.frameRate = FrameRate(A.window);
% Set the the PTB motion server to maximum priority
A.priorityLevel = MaxPriority(A.window);
% Set alpha blending functions for antialiasing
Screen(A.window,'BlendFunction',GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

if viewpoint,
  % Initialize the linking to the viewpoint library
  % NOTE THAT THE VIEWPOINT SOFTWARE MUST BE OPENED FIRST, OTHERWISE THE
  % DYNAMIC LINK LIBRARY WILL NOT BE READING OUT EYE POSITION
% vpx_Initialize;

  % Set the TTL channels to 0, these will be used to align trials
  % These viewpoint outputs correspond to the --> Intan digital input
  vpx_SendCommandString('ttl_out -0');    % 0 --> 7
  vpx_SendCommandString('ttl_out -1');    % 1 --> 0
  vpx_SendCommandString('ttl_out -2');    % 2 --> 6
  vpx_SendCommandString('ttl_out -3');    % 3 --> 1
  vpx_SendCommandString('ttl_out -4');    % 4 --> 5
  vpx_SendCommandString('ttl_out -5');    % 5 --> 2
  vpx_SendCommandString('ttl_out -6');    % 6 --> 4
  vpx_SendCommandString('ttl_out -7');    % 7 --> 3
end

% CREATE FACE TEXTURES -- NOTE THAT THIS RELIES ON THE FACE DATA EXISTING
% IN THE MARMOVIEW SUPPORT DATA DIRECTORY!!
%load ./SupportData/FaceCalMarmosetFaces.mat;
%M = {m1 m2 m3 m4 m5 m6 m7 m8 m9};
%********
%load ./SupportData/Gazestimuli/hillbase.mat;
load ./SupportData/Gazestimuli/ellbase.mat;
M = cell(1,9);
for i = 1:9
    M{i} = ellbase{1,i};  %hillbase.mat
end
%********
A.gazeTex = nan(9,1);
A.gazeTexSizes = nan(9,2);
for i = 1:9
     %********** apply a Gaussian aperture as well ***********
    if (1) 
      M1 = size(M{i},1);
      M2 = size(M{i},2);
      SIG = (M1/5)^2;
      for zi = 1:M1
        for zj = 1:M2
             mval = double( M{i}(zi,zj,:) );
             bval = ones(size(mval))*186; %127;
             dist = ((zi-(M1/2))^2 + (zj-(M2/2))^2);
             if (dist > (M1/2)^2)
               M{i}(zi,zj,:) = bval;
             else
               wval = exp(-0.5*(dist/SIG));
               M{i}(zi,zj,:) = uint8( double(wval .* mval) + double((1-wval) .* bval) );
             end
        end
      end
    end
    %*********************************************
    m = uint8(((double(M{i})./255).^S.gamma).*255); %  undo the gamma correction
    A.gazeTex(i) = Screen('MakeTexture',A.window,m);
    A.gazeTexSizes(i,1) = size(m,2);
    A.gazeTexSizes(i,2) = size(m,1);
    %***************
    A.faceTex(i) = Screen('MakeTexture',A.window,m);
    A.faceTexSizes(i,1) = size(m,2);
    A.faceTexSizes(i,2) = size(m,1);
end
