function [tex,texRect,winRect,dPix] = MakeSquareWaveGabor(rPix,xPix,yPix,win,bkgd,cycles,phase,range)

% Note that this function is somewhat unusual in that the point of doing
% this is to make 1 pixel square waves requiring precise distances to put
% those square waves at some cycle per degree value. This means that poor
% choices of cycles per degree could be substantially off as I will not be
% anti-aliasing the square waves.
%
% Also, phase will just be -1 for black then white at center, or 1 for 
% white then black
% 
% Also, when drawing these squarewaves, preferably only use angles of 0 or
% 90.

if nargin < 5
    error('Needs at least diameter, x and y centers, and the window for creating the texture');
end
if ~exist('bkgd','var');    bkgd = 127;     end;
if ~exist('cycles','var');  cycles = 2;     end;
if ~exist('phase','var');   phase = -1;     end;
if ~exist('range','var');   range = 127;    end;

% Find diameter
dPix = 2*rPix;
% Create a meshgrid
[X,Y] = meshgrid(-rPix+.5:rPix-.5);

% Standard deviation of gaussian (e1)
sigma = dPix/8;
% Create the gaussian (e1)
e1 = exp(-.5*(X.^2 + Y.^2)/sigma^2);

% Convert cycles to the number of pixels in each square wave -- note this
% will be rounded so for accuracy a good monitor distance should be chosen,
% really the important value is the pixPerDeg (having a fractional number
% of cycles is no problem, that just depends on the grating size).
pixPerHalfCycle = round(rPix/cycles)
pixPerHalfCycle = max(1,pixPerHalfCycle); % Just make sure it's > 0
% Create the square wave
swCycle = phase*[ones(1,pixPerHalfCycle) -ones(1,pixPerHalfCycle)];
s1Half = repmat(swCycle,dPix,ceil(0.5*rPix/pixPerHalfCycle));
pixDif = ceil(0.5*rPix/pixPerHalfCycle)*pixPerHalfCycle*2-rPix;
s1 = [s1Half(:,pixDif+1:end) s1Half(:,1:end-pixDif)];

% Create the gabor (g1)
g1 = s1.*e1;
% Convert the gabor (g1) to uint8
g1 = uint8(bkgd + g1*range);

% Create the gabor texture
tex = Screen('MakeTexture',win,g1);

% Determine the texture placement
texRect = [0 0 dPix dPix];
winRect = [xPix-rPix+1 yPix-rPix+1 xPix+rPix yPix+rPix];