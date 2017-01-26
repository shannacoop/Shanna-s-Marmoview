function [A,handles] = wpImgRun(S,P,A,hObject),
% WPIMGRUN run a trial of MarmoView's wallpaper image task.
%
% Returns a structure A with fields:
%

% 26-06-2016 - Shaun L. Cloherty <s.cloherty@ieee.org>

% FIXME: marmoview needs (at minimum) a class system for tasks and stimuli!
%
% FIXME: marmoview is massively broken. Why is this function messing with
%        hObject and returning handles... wtf?

handles = guidata(hObject); % <-- not elegant

hGaze = A.hGaze;

% the @trial object (initially in state 0)
hTrial = stimuli.wpimg.wpImgTrial( ...
  A.hImg, ...
  'fadeDuration',P.fadeDuration, ...
  'viewDuration',P.viewDuration, ...
  'viewpoint',S.viewpoint);

% hTrial.beforeTrial();
hTrial.trialNum = A.j;

eyeData = {}; % empty cell array
plotFlag = false; % FIXME: this is kludgy... should be handled by the @trial object?

% clear the frame buffer...
Screen('FillRect',A.window,S.bgColour);

while ~hTrial.done, % this is the trial loop... one itertion per stimulus frame  
  % get gaze position...
  if S.viewpoint,
    [x,y] = vpx_GetGazePoint();
    [pw,ph] = vpx_GetPupilSize();
  else,
    [x,y] = GetMouse(A.window); % "gaze space"
    x = min(x,S.screenRect(3));
    y = min(y,S.screenRect(4));
    
    pw = 0.0; ph = 0.0;
  end
  
  % convert "gaze space" to deg. visual angle... relative to the
  % centre of the screen
  xDeg = (x - A.c(1))/A.dx;
  yDeg = (y - A.c(2))/A.dy;
  yDeg = -1*yDeg;
    
  hTrial.x = xDeg; hTrial.y = yDeg;

  hTrial.beforeFrame(); % renders stimulus components
  
  if P.showGaze,
    % convert eye position from deg. visual angle to pixel space
    xPix = xDeg*S.pixPerDeg + S.centerPix(1);
    yPix = -1*yDeg*S.pixPerDeg + S.centerPix(2);

    hGaze.position = [xPix,yPix];
    hGaze.beforeFrame(); % show gaze position...
    
%     fprintf(1,'%.3f %.3f | %.3f %.3f %.3f %.3f | %.3f %.3f | %.3f %.3f\n',x,y,A.c,A.dx,A.dy,xDeg,yDeg,xPix,yPix);
  end
       
  t = Screen('Flip',A.window);
  
  eyeData{end+1} = [t,x,y,pw,ph,hTrial.stateId];
  
  % clear the frame buffer before rendering next frame
%   Screen('FillRect',A.window,S.bgColour);
  
  hTrial.afterFrame(t); % control logic, state transitions etc.
    
  % update gui and retrieve any changes
  drawnow;
  handles = guidata(hObject);
  %
    
  % update any changes made to the calibration
  %
  % FIXME: do we really want to do this? should it wait until the next
  %        trial?
  A.c = handles.A.c;
  A.dx = handles.A.dx;
  A.dy = handles.A.dy;
%   set(handles.CenterText,'String',sprintf('[%.2g %.2g]',A.c(1),A.c(2)));
%   set(handles.GainText,'String',sprintf('[%.2g %.2g]',A.dx,A.dy));
end

% hTrial.afterTrial();

% *don't* clear the ptb window between trials
% Screen('Flip',A.window);

eyeData = cell2mat(eyeData(:));
eval(handles.plotCmd);

A.eyeData = eyeData;
