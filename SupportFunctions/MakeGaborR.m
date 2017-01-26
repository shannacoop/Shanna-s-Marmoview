function [tex,rtex,texRect,winRect] = MakeGabor(rPix,xPix,yPix,win,bkgd,cycles,phase,range)

if nargin < 5
    error('Needs at least diameter, x and y centers, and the window for creating the texture');
end
if ~exist('bkgd','var');    bkgd = 127;     end;
if ~exist('cycles','var');  cycles = 2;     end;
if ~exist('phase','var');   phase = 0;      end;
if ~exist('range','var');   range = 127;    end;

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
g1 = s1.*e1;
% Convert the gabor (g1) to uint8
g1 = uint8(bkgd + g1*range);

% Create the gabor texture
tex = Screen('MakeTexture',win,g1);

rim = uint8( zeros(size(g1,1),size(g1,2),3) );
zw = find(g1 > (bkgd+20));
zb = find(g1 < (bkgd-20));
rim(:,:,3) = g1;
g1(zw) = 255;
g1(zb) = 0;
rim(:,:,1) = g1;
rim(:,:,2) = g1;
rtex = Screen('MakeTexture',win,rim);

% Determine the texture placement
texRect = [0 0 dPix dPix];
winRect = [xPix-rPix yPix-rPix xPix+rPix yPix+rPix];