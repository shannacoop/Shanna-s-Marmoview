function [tex,rect] = MakeDoubleGaussian(S,P,A,c)

% Make a double gaussian, light inside, dark out, or vice versa

% Get necessary info. If unavailable default values will be set.
% MUST HAVE A.window, S.pixPerDeg, S.centerPix NO DEFAULTS FOR THESE
if ~isfield(P,'stimRadius');        P.stimRadius = 1;               end;
if ~isfield(P,'bkgd');              P.bkgd = 127;                   end;
if ~isfield(P,'stimRange');             P.range = 127;                  end;

% Get radius of the stimulus in pixels
stimRad = round(P.stimRadius*S.pixPerDeg);

% Get a meshgrid for the texture, 0 at center
[x,y] = meshgrid(-stimRad:stimRad);
R = x.^2+y.^2;
% Define sigmas
s1 = stimRad/8; s2 = stimRad/5.657;
% Create gaussians
e1 = exp(-.5*R/s1^2);
e2 = .5*exp(-.5*R/s2^2);

% Default for bright inside
if ~exist('c','var'); c = 0; end;

% Is it bright in or out?
if c == 0
    e = e1-e2;
    m = max(e(:));
    e = P.stimRange*e/m + P.bkgd;
else
    e = e2-e1;
    m = min(e(:));
    e = -P.stimRange*e/m + P.bkgd;
end

% Convert to a 24-bit image
im = uint8(e);

% Create the texture and source rect
tex = Screen('MakeTexture',A.window,im);
rect = [0;0;size(im,1);size(im,1)];
