function [A,P] = dotMotionNext(S,P,A)
% DOTMOTIONNEXT initialise the next trial of MarmoView's dot motion task.
%
% Returns structures A and P with fields:
%
%   A.rngSettings - the state of the random number generator on this trial
%   A.direction   - the direction of motion on this trial

% 14-06-2016 - Shaun L. Cloherty <s.cloherty@ieee.org>

% FIXME: marmoview needs (at minimum) a class system for tasks and stimuli!

% FIXME: most of this should be done in the xxxInit() function... but xxxInit()
%        doesn't get passed the S and P structures.. wtf?

% set gaze indicator color
A.hGaze.size = (2*P.gazeRadius)*S.pixPerDeg;
% A.hGaze.colour = uint8(repmat(A.bgColour,1,3) + P.gazeIntensity*S.gazeColorStep);
A.hGaze.colour = repmat(S.bgColour,1,3) + P.gazeIntensity*S.gazeColorStep;

% set fixation point properties
sz = P.fixPointRadius*S.pixPerDeg;
A.hFix(1).cSize = sz;
A.hFix(1).sSize = 2*sz;
A.hFix(1).cColour = ones(1,3); % black
A.hFix(1).sColour = repmat(255,1,3); % white
A.hFix(1).position = [0,0]*S.pixPerDeg + S.centerPix;

A.hFix(2).cSize = sz;
A.hFix(2).sSize = 2*sz;
A.hFix(2).cColour = repmat(S.bgColour-P.fixPointDim,1,3); % "black"
A.hFix(2).sColour = repmat(S.bgColour+P.fixPointDim,1,3); % "white"
A.hFix(2).position = [0,0]*S.pixPerDeg + S.centerPix;

% A.fixDuration = 0.2 + 0.3*rand(); % random duration 0.2-0.5s
rnd = rand();
A.fixDuration = (1-rnd)*P.minFixDuration + rnd*P.maxFixDuration; % random duration

% A.choiceTargetDelay = 0.1+0.3*rand(); % random delay 0.1-0.4s
rnd = rand();
A.cueDelay = (1-rnd)*P.minCueDelay + rnd*P.maxCueDelay; % random delay (was choiceTargetDelay)

% new bandwidth difficulty parameters
if ~isfield(P, 'numBandwidths')
  P.numBandwidths=1;
end

if ~isfield(P, 'minBandwidth')
  P.minBandwidth=P.bandwdth;
end

if ~isfield(P, 'maxBandwidth')
  P.maxBandwidth=P.bandwdth;
end

% sample bandwidth
if P.numBandwidths>1
    P.bandwdth=(P.maxBandwidth - P.minBandwidth) * ((randi(P.numBandwidths, 1)-1)/(P.numBandwidths-1)) + P.minBandwidth;
end



fprintf('Bandwidth = %d\n', P.bandwdth)
% set properties of the @dots object...
fnames = {'numDots','bandwdth'};
for f = fnames,
  A.hDots.(f{1}) = P.(f{1});
end

A.hDots.size = P.size*S.pixPerDeg; % pixels
A.hDots.speed = P.speed*S.pixPerDeg/A.frameRate; % pixels/frame

A.hDots.maxRadius = P.stimWinRadius*S.pixPerDeg; % pixels

A.hDots.mode = S.mode; % 0 = proportion of dots, 1 = sample from random dist.
A.hDots.dist = S.dist; % 0 = uniform, 1 = gaussian

A.hDots.lifetime = P.lifetime; % dot lifetime (in frames)

A.hDots.position = [P.xDeg,-1*P.yDeg]*S.pixPerDeg + S.centerPix;

A.hDots.colour = repmat(fix(S.bgColour*(P.contrast+1.0)),1,3);

%
% 1. uniformly distributed direction...
%
% A.direction = rand()*360.0;

%
% 2. n AFC
%
n = P.numDirs; % number of directions/choice targets
A.direction = mod(round((rand()*360)/(360/n))*(360/n),360);

A.hDots.direction = A.direction; 

% setup bonus reward for difficult trials
if P.bandwdth==P.maxBandwidth
%     P.bonusDirection=A.direction;
%     P.bonusWindow=P.rewardWindow;
%     P.bonusRewardCnt=2;
    P.maxRewardCnt=6; 
else
    P.maxRewardCnt=4;
end

% (re-)initialise dots
A.rngSettings = rng(); % save the state of the rng so we can exactly reconstruct our dot pattern
A.hDots.beforeTrial();

%
% choice targets
%
r = (P.stimWinRadius+P.cueApertureRadius)*S.pixPerDeg;
th = [0:n-1]*(2*pi/n);

[x,y] = pol2cart(th,r);

sz = P.choiceTargetRadius*S.pixPerDeg;
A.hChoice.size = repmat(2*sz,1,n);
A.hChoice.position = [x; -1*y]' + repmat(S.centerPix,n,1);
A.hChoice.colour = repmat(fix(S.bgColour*(P.choiceTargetContrast+1)),1,3);
A.hChoice.weight = -1; % weight < 0, filled circle(s)

%
% choice cue
%
r = (P.stimWinRadius+P.cueApertureRadius)*S.pixPerDeg;
th = A.direction*(pi/180);

[x,y] = pol2cart(th,r);

% the cue aperture...
% A.hCue.size = 2*P.cueApertureRadius*S.pixPerDeg;
% A.hCue.position = [x; -1*y]' + S.centerPix;
% A.hCue.colour = repmat(fix(S.bgColour*(P.cueApertureContrast+1)),1,3);
% A.hCue.weight = 2; % weight < 0, filled circle(s)

%% use a gabor patch instead... as per the spatial acuity task
rPix = round(P.cueApertureRadius*S.pixPerDeg);
cycles = 2 * 4 * P.cueApertureRadius; % fixed at 4 cyc./deg.
phase = 0;

% note: this is *NOT* SupportFunctions/MakeGabor.m... see below
img = MakeGabor(rPix,S.bgColour,cycles,phase,fix(S.bgColour*P.cueApertureContrast));

A.hCue.addTexture(1,img);
A.hCue.size = 2*P.cueApertureRadius*S.pixPerDeg;
A.hCue.position = [x; -1*y]' + S.centerPix;
A.hCue.id = 1;
%%


%
% feedback, for incorrect choices...
%
A.hFbk.size = 2*P.feedbackApertureRadius*S.pixPerDeg;
A.hFbk.position = [x; -1*y]' + S.centerPix;
A.hFbk.colour = repmat(fix(S.bgColour*(P.feedbackApertureContrast+1)),1,3);
A.hFbk.weight = 4;

% face, for additional reward (?)
A.hFace.size = 2.5*P.cueApertureRadius*S.pixPerDeg;
A.hFace.position = [x; -1*y]' + S.centerPix;

A.faceIndex = P.faceIndex(1);
if A.faceIndex <= 0,
  A.faceIndex = randi(A.hFace.numTex);
end
A.hFace.id = A.faceIndex;


function img = MakeGabor(rPix,bkgd,cycles,phase,range)
  % as much as it pains me, this code is cut and pasted from
  % SupportFunctions/MakeGabor.m...
  %
  % we don't use MakeGabor.m directly because it wants to create the
  % ptb texture but we just want an image that we can pass to the
  % @textures class

  % Find diameter
  dPix = 2*rPix+1;
  % Create a meshgrid
  [X,Y] = meshgrid(-rPix:rPix);

  % Standard deviation of gaussian (e1)
  sigma = dPix/8;
  % Create the gaussian (e1)
  e1 = exp(-.5*(X.^2 + Y.^2)/sigma^2);

  % Convert cycles to max radians (s1)
  maxRadians = pi*cycles;
  % Convert phase from degrees to radians (s1)
  phase = pi*phase/180;
  % Create the sinusoid (s1)
  s1 = sin(maxRadians*X/rPix + phase);

  % Create the gabor (g1)
%   g1 = s1.*e1;
  g1 = s1;
  
  % Convert to uint8
  g1 = uint8(bkgd + g1*range);
  
  % stick the gaussian envelope on the alpha channel...
  img = repmat(g1,1,1,3);
  img(:,:,4) = uint8(255.*e1);

