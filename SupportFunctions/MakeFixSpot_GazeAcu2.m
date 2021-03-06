function [fixTex,fixRect,winRect] = MakeFixSpot_GazeAcu2(S,P,A,colorIn,colorOut)

% Make a fixation point texture

% First get all necessary info, or use defaults
% MUST HAVE S.pixPerDeg, A.window, and P.bkgd
if ~isfield(P,'fixPointRadius');    P.fixPointRadius = 0.30;         end;
if nargin > 3;                      P.fixPointColorIn = colorIn;    end;
if ~isfield(P,'fixPointColorIn');   P.fixPointColorIn = 0;          end;
if nargin > 4;                      P.fixPointColorOut = colorOut;  end;
if ~isfield(P,'fixPointColorOut');  P.fixPointColorOut = 255;       end;
if ~isfield(P,'xFixDeg');           P.xFixDeg = 0;                  end;
if ~isfield(P,'yFixDeg');           P.yFixDeg = 0;                  end;
if ~isfield(S,'centerPix');         S.centerPix = [960 540];        end;

% Find radius of spot in pixels
outfixr = P.fixPointRadius*S.pixPerDeg;
% Make a texture that will fit this radius
texRad = round(outfixr)+2;   % Texture is slightly larger than specified radius so
                        % the point can be rapidly, smoothly, blended, into the
                        % background color, this allows sub-pixel precision
                        % when specifying fix point size, and a nicer, less
                        % pixelated point
                        
% Get a meshgrid for the texture
[x,y] = meshgrid(-texRad:texRad);
r = sqrt(x.^2 + y.^2);

% A gaussian should vary from bkgd to at the fixation point boundary, about
% 1.5 pixels the color will be half way, this is considered the outter edge
% of the fixation point, additional pixels in radius ensure the luminance
% will smoothly blend into the background
mu1 = outfixr/2 + 0.5; %outfixr-1.5;
sigma = 1; % A small sigma is for rapid blending
% exponential transition of outter boundary 
e1 = exp(-.5*(r-mu1).^2./(sigma^2));
% needs to be scaled between bkgd and outter fixation point colors
e1 = e1*(P.fixPointColorOut-P.bkgd) + P.bkgd;

% Now the same, but this time for the fixation contrast from outter color
% to inner color at the half radius
mu2 = outfixr/2 + 0.5;
e2 = exp(-.5*(r-mu2).^2./(sigma^2));
% needs to be scaled between outter and inner colors
e2 = e2*(P.fixPointColorOut-P.fixPointColorIn) + P.fixPointColorIn;

mu3 = outfixr/2 - 2.5;
e3 = exp(-.5*(r-mu3).^2./(sigma^2));
% needs to be scaled between outter and inner colors

% Put the transitions together to create the fixation point image
% e1 applies from radius mu1 to the edge of the texture
% e2 applies from radius mu2 to the center of the texture
% between mu1 and mu2 should be the outter fix point color
fixIm = zeros(size(r)) + P.fixPointColorOut;
fixIm(r >= mu1) = e1(r >= mu1);
fixIm(r <= mu2) = e2(r <= mu2);  %only show insize part of fixation point
fixIm(r <= mu3) = e1(r <= mu3); 
% Ensure the image is in display ready format
fixIm = uint8(fixIm);

% Create the fix spot texture
fixTex = Screen('MakeTexture',A.window,fixIm);

% Determine the loation to place the fixation spot
cx = S.centerPix(1) + round(P.xFixDeg * S.pixPerDeg);
cy = S.centerPix(2) - round(P.yFixDeg * S.pixPerDeg); % INVERT FOR SCREEN COMMANDS
dpix = size(fixIm,1);
rpix = (dpix-1)/2;
fixRect = [0 0 dpix dpix];
winRect = [cx-rpix cy-rpix cx+rpix cy+rpix];