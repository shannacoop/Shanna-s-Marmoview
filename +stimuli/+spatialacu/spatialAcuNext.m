function [A,P] = spatialAcuNext(S,P,A)

% function [A,P] = spatialAcuNext(S,P,A)

% Trials list control
switch P.runType
    case 2  % trials list prep
        % if trials list hasn't been set up before
        if ~isfield(A,'trialN')
            A.trialN = size(S.trialsList,1);
            A.trialPerm = randperm(A.trialN);
            A.trialInd = 1;
            i = A.trialPerm(A.trialInd);
            P.xDeg = S.trialsList(i,1);
            P.yDeg = S.trialsList(i,2);
            P.cpd = S.trialsList(i,3);
            P.phase = rand*2*pi;  %S.trialsList(i,4);
            P.angle = S.trialsList(i,5);
            P.rewardNumber = S.trialsList(i,7);
            % P.type = S.trialsList(i,6);
        end
        % Trial index and further updates are performed in trial end.
        % However, scrambling of the next trials list occurs here if trial
        % index has reached the end of the trials list
        if A.trialInd >= A.trialN
            A.trialInd = 0;
            A.trialPerm = randperm(A.trialN);
        end
end

% See if a contrast cue will be used on this trial
A.useContrastCue = false;
if 100*rand < P.cueProbability
    if min(abs(P.cueDirection - (180*atan2(P.yDeg,P.xDeg)/pi+(-360:360:360)))) < 90
        A.useContrastCue = true;
    end
end

% Calculate this for pie slice windowing and contast cues
A.stimTheta = atan2(P.yDeg,P.xDeg);


% Make fixation spots, bright and dim
[fixTex,fixRect,winRect] = MakeFixSpot_GazeAcu(S,P,A,0,255);
A.fixTex1 = fixTex;
A.fixRect1 = fixRect;
A.winRect1 = winRect;
[fixTex,fixRect,winRect] = MakeFixSpot_GazeAcu(S,P,A,127-50,127+50);
A.fixTex2 = fixTex;
A.fixRect2 = fixRect;
A.winRect2 = winRect;


% Make gabor texture
rPix = round(P.radius*S.pixPerDeg);
xPix = S.centerPix(1) + round(P.xDeg*S.pixPerDeg);
yPix = S.centerPix(2) - round(P.yDeg*S.pixPerDeg); % Invert for screen placement
if ( P.cpd >= P.cutfreq)
    cycles = 2 * 8 * P.radius;   % draw 8 cyc/deg, but will not show stim
else
    cycles = 2*P.cpd*P.radius; % Get cycles in the gabor
end
% Square wave gabor option, backwards compatible in that if squareWave
% isn't a parameter, it will create a sinewave gabor
if isfield(P,'squareWave')
    if P.squareWave == 1
        [A.tex,A.texRect,A.winRect,dPix] = MakeSquareWaveGabor(...
            rPix,xPix,yPix,A.window,P.bkgd,cycles,P.phase,P.range);
        [gX,gY] = meshgrid(-rPix+.5:rPix-.5);
    else
        [A.tex,A.texRect,A.winRect,dPix] = MakeGabor(...
            rPix,xPix,yPix,A.window,P.bkgd,cycles,P.phase,P.range);
        [gX,gY] = meshgrid(rPix:rPix);
    end
else
    [A.tex,A.texRect,A.winRect,dPix] = MakeGabor(...
        rPix,xPix,yPix,A.window,P.bkgd,cycles,P.phase,P.range);
    [gX,gY] = meshgrid(rPix:rPix);
end


% Luminance distractors
roto = (2*pi/P.apertures);
xx = P.xDeg;
yy = P.yDeg;


if P.distLum
    vals = -P.distLum:((2*P.distLum)/(P.apertures-2)):P.distLum;
    A.distVals = vals(randperm(P.apertures-1));
    A.distTex = cell((P.apertures-1),1);
    A.distRect = [0 0 dPix dPix];
    A.distWin = cell((P.apertures-1),1);    % what is this used for ... is 5 related to 6?
    for i = 1:(P.apertures-1)
        %******* rotation of position for array
        axx = (cos(roto)*xx) + (sin(roto)*yy);
        ayy = (-sin(roto)*xx) + (cos(roto)*yy);
        xx = axx;
        yy = ayy;
        %******************
        e = uint8(127 + A.distVals(i)*exp(-.5*(gX.^2+gY.^2)/(dPix/8)^2));
        A.distTex{i} = Screen('MakeTexture',A.window,e);
        % Determine the location to place the gaussian
        cx = S.centerPix(1) + round(xx * S.pixPerDeg);
        cy = S.centerPix(2) - round(yy * S.pixPerDeg);   % INVERT FOR SCREEN COMMANDS
        if rem(dPix,2)
            A.distWin{i} = [cx-rPix cy-rPix cx+rPix cy+rPix];
        else
            A.distWin{i} = [cx-rPix+1 cy-rPix+1 cx+rPix cy+rPix];
        end
    end
end


% Face reward texture
% For face reward, pick at random 1 of the 9 faces to show after a correct
% trial
A.faceIndex = 1;  % always facing forward  %ceil(9*rand);

%******* how do you select the index based on target direction??
if (abs(P.xDeg) > 0.5)
   if ( P.xDeg > 0 ) 
      if (abs(P.yDeg) < 0.5)
          A.gazeIndex = 2;
      else
          if (P.yDeg > 0)
              A.gazeIndex = 9;
          else
              A.gazeIndex = 3;
          end
      end
   else
      if (abs(P.yDeg) < 0.5)
          A.gazeIndex = 6;
      else
          if (P.yDeg > 0)
             A.gazeIndex = 7;
          else
             A.gazeIndex = 5;
          end
      end
   end
else
   if (P.yDeg > 0)
       A.gazeIndex = 8;
   else
       A.gazeIndex = 4;
   end
end
P.startApert = 1 + mod( A.gazeIndex,2);   % 1 or 2

%[P.xDeg,P.yDeg,A.gazeIndex]
%****************************
% A.gazeIndex = floor(2 + rand*7.9999);  % random direction face



%***************************


% this box is at the target location, xx,yy  *** Big face for reward
xx = P.xDeg;
yy = P.yDeg;
cx = S.centerPix(1) + round(xx * S.pixPerDeg);
cy = S.centerPix(2) - round(yy * S.pixPerDeg);  % INVERT FOR SCREEN COMMANDS
dpix = ceil(2.5*S.pixPerDeg);
rpix = (dpix-1)/2;
BigFullRect = [cx-rpix cy-rpix cx+rpix cy+rpix];
% Rectangle of the source textures
cx = S.centerPix(1);   
cy = S.centerPix(2);   %
dpix = ceil(2.5*S.pixPerDeg); %ceil(2*P.radius*S.pixPerDeg);
rpix = (dpix-1)/2;
SmallFullRect = [cx-rpix cy-rpix cx+rpix cy+rpix];  % window at center
%*********
A.faceFixRect = SmallFullRect;
A.faceTexRect = zeros(4,1);
A.faceTexRect(3) = A.faceTexSizes(A.faceIndex,1);
A.faceTexRect(4) = A.faceTexSizes(A.faceIndex,2);
A.faceWinRect = BigFullRect;  %fullRect; % bigger face
%*********
%xx = P.xDeg;
%yy = P.yDeg;
%nomo = sqrt( xx^2 + yy^2 );
%nx = (xx/nomo) * P.faceShift;
%ny = (yy/nomo) * P.faceShift;
%cx2 = S.centerPix(1) + round(nx * S.pixPerDeg);
%cy2 = S.centerPix(2) - round(ny * S.pixPerDeg);
%GazeFullRect = [cx2-rpix cy2-rpix cx2+rpix cy2+rpix];
%********
%A.gazeFixRect = GazeFullRect;
%A.gazeTexRect = zeros(4,1);
%A.gazeTexRect(3) = A.gazeTexSizes(A.gazeIndex,1);
%A.gazeTexRect(4) = A.gazeTexSizes(A.gazeIndex,2);
%A.gazeWinRect = GazeFullRect;  %fullRect; % bigger face

% Color for gaze indicator color
A.eyeColor = uint8(repmat(P.bkgd,[1 3]) + P.eyeIntensity*S.eyeColorStep);
   