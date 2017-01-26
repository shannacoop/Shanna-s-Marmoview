function [fixTex,fixRect,fixWinRect] = MakeFixSpot(S,P,A)

% Make a fixation point texture using task settings (S), parameters (P),
%  and current variables (A)

% Get necessary info. If unavailable default values will be set.
% MUST HAVE A.window, S.pixPerDeg, S.centerPix NO DEFAULTS FOR THESE
if ~isfield(P,'fixPointRadius');    P.fixPointRadius = 0.25;        end;
if ~isfield(P,'fixPointColorIn');   P.fixPointColorIn = 0;          end;
if ~isfield(P,'fixPointColorOut');  P.fixPointColorOut = 255;       end;
if ~isfield(P,'xFixDeg');           P.xFixDeg = 0;                  end;
if ~isfield(P,'yFixDeg');           P.yFixDeg = 0;                  end;
if ~isfield(P,'bkgd');              P.bkgd = 127;                   end;

% Get pixel deviation from screen center
xPix = S.pixPerDeg*P.xFixDeg;
yPix = S.pixPerDeg*P.yFixDeg;

% Get radius of the fixation spot in pixels
fixRad = P.fixPointRadius*S.pixPerDeg;
% Extend the texture beyond this radius for two reasons.
%   1 - Allows room to blend the fixation point into the background
%   2 - Allows sub-pixel resolution of fixation point center
texRad = ceil(fixRad)+2;

% Get a meshgrid for the texture, 0 at center
[x,y] = meshgrid(-texRad:texRad);
% Offset meshgrid center by fraction xPix and yPix centering
x = x + (xPix-round(xPix)); y = y + (yPix-round(yPix));
% Now round xPix and yPix for the texture placement
%  subpixel correction is in the texture meshgrid
xPix = round(xPix); yPix = round(yPix);
% In the fix point texture, find distance from fix point center
r = sqrt(x.^2 + y.^2);

% First gaussian will blend the fixation point boundary into the background
% the edge of the fixation point will be considered the half way blending,
% which will be at 1.5 pixels with a sigma of 1
mu1 = fixRad-1.5;
sigma = 1; % A small sigma is for rapid blending
% Gaussian blending of fixation point edge with background 
e1 = exp(-.5*(r-mu1).^2./(sigma^2));
% Scale between bkgd and outer fixation point colors
e1 = e1*(P.fixPointColorOut-P.bkgd) + P.bkgd;

% Now blend the outer fixation color to the inner fixation color
mu2 = fixRad/2+.75;
e2 = exp(-.5*(r-mu2).^2./(sigma^2));
% Scale between inner and outer fixation colors
e2 = e2*(P.fixPointColorOut-P.fixPointColorIn) + P.fixPointColorIn;

% Put the transitions together to create the fixation point image
% e1 applies from radius mu1 to the edge of the texture
% e2 applies from radius mu2 to the center of the texture
% between mu1 and mu2 should be the outer fix point color
fixIm = zeros(size(r)) + P.fixPointColorOut;
fixIm(r >= mu1) = e1(r >= mu1);
fixIm(r <= mu2) = e2(r <= mu2);
% Ensure the image is in 8 bit integers
fixIm = uint8(fixIm);

% Create the fix spot texture
fixTex = Screen('MakeTexture',A.window,fixIm);

% Determine the loation to place the fixation spot
cx = S.centerPix(1) + xPix;
cy = S.centerPix(2) - yPix; % INVERT FOR SCREEN COMMANDS
dpix = size(fixIm,1); rpix = (dpix-1)/2;
fixRect = [0;0;dpix;dpix];
fixWinRect = [cx-rpix-1;cy-rpix-1;cx+rpix;cy+rpix];