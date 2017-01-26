function [tex,texRect,winRect] = MakeFixSpot2(rPix,xPix,yPix,win,bkgd,cIn,cOut)

if nargin < 5
    error('Needs at least diameter, x and y centers, and the window for creatings the texture');
end
if ~exist('bkgd','var');    bkgd = 127; end;
if ~exist('cIn','var');     cIn = 0;    end;
if ~exist('cOut','var');    cOut = 255; end;

% Find diameter
dPix = 2*rPix + 1;
% Create a meshgrid
[X,Y] = meshgrid(-rPix:rPix);
R = sqrt(X.^2 + Y.^2);

% A gaussian should vary from bkgd to at the fixation point boundary, about
% 1.5 pixels the color will be half way, this is considered the outter edge
% of the fixation point, additional pixels in radius ensure the luminance
% will smoothly blend into the background
mu1 = rPix-1.5;
sigma = .75; % A small sigma is for rapid blending
% exponential transition of outter boundary 
e1 = exp(-.5*(R-mu1).^2./(sigma^2));
% needs to be scaled between bkgd and outter fixation point colors
e1 = e1*(cOut-bkgd) + bkgd;

% Now the same, but this time for the fixation contrast from outer color
% to inner color at the half radius
mu2 = rPix/2-.5;
e2 = exp(-.5*(R-mu2).^2./(sigma^2));
% needs to be scaled between outter and inner colors
e2 = e2*(cOut-cIn) + cIn;

% Put the transitions together to create the fixation point image
% e1 applies from radius mu1 to the edge of the texture
% e2 applies from radius mu2 to the center of the texture
% between mu1 and mu2 should be the outter fix point color
im = zeros(size(R)) + cOut;
im(R >= mu1) = e1(R >= mu1);
im(R <= mu2) = e2(R <= mu2);
% Ensure the image is in display ready format
im = uint8(im);

% Create the fix spot texture
tex = Screen('MakeTexture',win,im);

% Determine the texture placement
texRect = [0 0 dPix dPix];
winRect = [xPix-rPix yPix-rPix xPix+rPix yPix+rPix];