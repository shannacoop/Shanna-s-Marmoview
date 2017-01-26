function A = wpImgInit(S,A)
% WPIMGINIT initialize the psych. toolbox for the wallpaper image task.
%
% Returns a struct A with fields:
%
%   A.window     - pointer to the ptb window pointer
%   A.screenRect - dimensions of the ptb window
%   A.bgColour   - clut index for ptb window background
%   A.frameRate  - ptb window refresh rate
%   A.hImg       - handle to an @textures object containing the wallpaper
%                  images

% 26-06-2016 - Shaun L. Cloherty <s.cloherty@ieee.org>

% FIXME: marmoview needs (at minimum) a class system for tasks and stimuli!

% disable ptb welcome screen
Screen('Preference','VisualDebuglevel',3);

% close any open windows
Screen('CloseAll');

% setup the image processing pipeline for ptb
PsychImaging('PrepareConfiguration');

PsychImaging('AddTask','General','FloatingPoint32BitIfPossible');

% create the ptb window...
% A.bgColour = 186; % should be 127 if gamma corrected, 186 if not

[A.window A.screenRect] = PsychImaging('OpenWindow',S.screenNumber,S.bgColour,S.screenRect);

A.frameRate = FrameRate(A.window);

% bump ptb to maximum priority
A.priorityLevel = MaxPriority(A.window);

% set alpha blending/antialiasing etc.
Screen(A.window,'BlendFunction',GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

% create a circle to show gaze position
A.hGaze = stimuli.circles(A.window);

% create wallpaper image textures...
A.hImg = stimuli.textures(A.window);

d = dir(fullfile('.','SupportData','pexels.com'));
d = d(randperm(length(d)));
for ii = 1:length(d),
  [~,fname,fext] = fileparts(d(ii).name);

  if d(ii).isdir,
    continue
  end
  
  if ~any(strcmp(fext,{'.jpg'})), % we only want the .jpg files...
    continue
  end
  
  try,
    img = imread(fullfile('.','SupportData','pexels.com',d(ii).name));
  catch,
    % whoops, something bad happened reading the file... skip it!
    continue
  end

  wdth = A.screenRect(3); % screen wdth
  hght = A.screenRect(4); % screen hght
  
  sz = size(img);

  if sz(1) > hght,
    % trim image height
    img = permute(img,[2,1,3]);
    img = reshape(img,[],1,sz(3));
    
    row0 = round((sz(1)-hght)/2);
    row1 = row0 + hght;

    img = img([row0*sz(2):row1*sz(2)-1],1,:);
    img = reshape(img,sz(2),hght,sz(3));
    img = permute(img,[2,1,3]);
  end
  
  sz = size(img);
  
  if sz(2) > wdth,
    % trim image width
    img = reshape(img,[],1,sz(3));

    col0 = round((sz(2)-wdth)/2);
    col1 = col0 + wdth;

    img = img([col0*sz(1):col1*sz(1)-1],1,:);
    img = reshape(img,hght,wdth,sz(3));
  end

  A.hImg.addTexture(d(ii).name,img);
end

A.hImg.size = A.screenRect(3:4);
A.hImg.position = S.centerPix;

A.hImg.id = A.hImg.texIds(1); % placeholder...
