function [A,P] = fixFlashNext(S,P,A)

% function [A,P] = fixFlashNext(S,P,A)

% Set up fixation duration
A.fixDur = P.fixMin + ceil(1000*P.fixRan*rand)/1000;

% Reward schedule is automated based on fix duration for staircasing
if S.runType
    P.rewardNumber = find(A.fixDur > S.staircase.rewardSchedule,1,'last');
end

% Make a fixation point texture
outfixr = P.fixPointRadius*S.pixPerDeg;
texRad = round(outfixr)+3;   % Texture is slightly larger than specified radius so
                        % the point can be rapidly, smoothly, blended, into the
                        % background color, this allows sub-pixel precision
                        % when specifying fix point size, and a nicer, less
                        % pixelated point
                        
% Get a meshgrid for the texture
[x,y] = meshgrid(-texRad:texRad);
r = sqrt(x.^2 + y.^2);

% A gaussian should vary from bkgd to at the fixation point boundary, about
% 2 pixels the color will be half way, this is considered the outter edge
% of the fixation point, additional pixels in radius ensure the luminance
% will smoothly blend into the background
mu1 = outfixr-2;
sigma = 1; % A small sigma is for rapid blending
% exponential transition of outter boundary 
e1 = exp(-.5*(r-mu1).^2./(sigma^2));
% needs to be scaled between bkgd and outter fixation point colors
e1 = e1*(P.fixPointColorOut-P.bkgd) + P.bkgd;

% Now the same, but this time for the fixation contrast from outter color
% to inner color at the half radius
mu2 = outfixr/2+.5;
e2 = exp(-.5*(r-mu2).^2./(sigma^2));
% needs to be scaled between outter and inner colors
e2 = e2*(P.fixPointColorOut-P.fixPointColorIn) + P.fixPointColorIn;

% Put the transitions together to create the fixation point image
% e1 applies from radius mu1 to the edge of the texture
% e2 applies from radius mu2 to the center of the texture
% between mu1 and mu2 should be the outter fix point color
fixIm = zeros(size(r)) + P.fixPointColorOut;
fixIm(r >= mu1) = e1(r >= mu1);
fixIm(r <= mu2) = e2(r <= mu2);
% Ensure the image is in display ready format
fixIm = uint8(fixIm);

% Create the fix spot texture
A.fixTex = Screen('MakeTexture',A.window,fixIm);

% Determine the loation to place the fixation spot
cx = S.centerPix(1) + round(P.xDeg * S.pixPerDeg);
cy = S.centerPix(2) - round(P.yDeg * S.pixPerDeg); % INVERT FOR SCREEN COMMANDS
dpix = size(fixIm,1);
rpix = (dpix-1)/2;
A.fixRect = [0 0 dpix dpix];
A.winRect = [cx-rpix cy-rpix cx+rpix cy+rpix];

% Face trial control
% Face reward texture
if (1) % always draw face texture for reward
    % For face reward, pick at random 1 of the 9 faces to show after a correct
    % trial
    A.faceIndex = ceil(9*rand);
    A.faceTex = A.tex(A.faceIndex);
    % Rectangle of the source textures
    A.faceTexRect = zeros(4,1);
    A.faceTexRect(3) = A.texSizes(A.faceIndex,1);
    A.faceTexRect(4) = A.texSizes(A.faceIndex,2);
    fr = round(S.pixPerDeg);
    cp = round(S.centerPix);
    A.faceWinRect = [cp(1)-fr cp(2)-fr cp(1)+fr cp(2)+fr];
end
if rand < P.faceTrialFraction
    A.faceTrial = true;
else
    A.faceTrial = false;
end

%$$$$$$$$$$$$$$$$$$$$$$$$$$$ JM - 2/1/16
%********* I would need a cell array, like A.gabor_array where gabor_array
% is a cell
%******* I would to run a loop and create, say to start, 8 gabors of each
%orientation around a circle, and put into the cell array
%*******
%*** looking at the acuity task, then for each gabor I would need the following: 
%*** A.tex -- is the actual rgb image
%*** A.texRect -- is the size of image [0 0 dPix dPix] where dPix is size
%*** A.winRect -- is the exact window to place it on the screen (want it to
%be variable)
%********* I need a global variable for Gabor contrast, so in training
%********* I can start with really dim stimuli, and by hand, make brighter
%********************************************************


% Make a gabor texture using current parameters
A.GABtex = cell(1,P.OriNum);
A.GABtexRect = cell(1,P.OriNum);
A.GABwinRect = cell(1,P.OriNum);
%*******
for k = 1:P.OriNum    % make 8 different orientations
    
  dpix = ceil(2*P.gabRadius*S.pixPerDeg);
  if ~rem(dpix,2)   % forcing radius to be an odd number
    dpix = dpix-1;
  end
  maxRadians = 2*pi * (P.cpd*(2*P.gabRadius));

  [gX,gY] = meshgrid(1:dpix);
  sigma = dpix/8;   % default width of Gauss envelope is (1/8)
  mu = (dpix+1)/2;
  %***************
  p = pi * rand;  % random phase for oriout
  A.ango = ((k-1)*pi)/P.OriNum;
  ango = A.ango;
  %**********
  gZ = (sin(ango) .* (gX-1)) + (cos(ango) .* (gY-1));
  s1 = sin(maxRadians.* gZ ./(dpix-1) + p);
  %******************
  e1 = exp(-.5*((gX-mu).^2 + (gY-mu).^2)/sigma^2);
  g = s1.*e1;  % the actual gabor 0 to 1
  g = round(P.bkgd + g * ((255-P.bkgd)*(P.GaborContrast/100)));
  A.GABtex{k} = Screen('MakeTexture',A.window,g);   %8 textures instead of 1
  %*****************
  rpix = (dpix-1)/2;
  A.GABtexRect{k} = [0 0 dpix dpix];
  %***** initialize positions around a ring, even though it will change
  anga = ((k-1)*(2*pi))/P.OriNum;
  xx = cos(anga) * 5;  % show at 5 deg radius
  yy = sin(anga) * 5;
  cx = S.centerPix(1) + round(xx*S.pixPerDeg);
  cy = S.centerPix(2) - round(yy*S.pixPerDeg); % INVERT FOR SCREEN COMMANDS
  %***************
  ampo = P.gabMinRadius + (P.gabMaxRadius-P.gabMinRadius)*rand;
  ango = rand*2*pi;
  dx = cos(ango)*ampo;
  dy = sin(ango)*ampo;
  cX = S.centerPix(1)+ round( S.pixPerDeg * dx);
  cY = S.centerPix(2)+ round( S.pixPerDeg * dy);   % FOR SCREEN DRAWS, VERTICAL IS INVERTED
  A.GABwinRect{k} = [cx-rpix cy-rpix cx+rpix cy+rpix];
  %*****************
end

% Color for gaze indicator color
A.eyeColor = uint8(repmat(P.bkgd,[1 3]) + P.eyeIntensity*S.eyeColorStep);