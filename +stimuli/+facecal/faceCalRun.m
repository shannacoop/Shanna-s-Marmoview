function [A,handles] = faceCalRun(S,P,A,hObject)

% [A,handles] = FaceCalRun(S,P,A,hObject)

viewpoint = true; % FIXME: for now, assume the ViewPoint eye tracker is present...
if isfield(S,'viewpoint'),
  viewpoint = S.viewpoint; % allows one to turn off the eye tracker in the rig settings
end

% Set up arrays to collect eye data for max trial duration
% Collecting at frame rate
maxDur = P.faceDur + P.iti;
eyeData = nan(5+round(1.1*maxDur*120),6);

% Update handles
pause(.01); handles = guidata(hObject);

% Setup first frame
Screen('FillRect',A.window,P.bkgd);
% when flipping, store time in eyeData
firstFlipTime = Screen('Flip',A.window,GetSecs);

% Setup the state
state = 0; % Showing the face
% trialOver checks for whether the ITI has begun. It's used to ensure the
% eye trace is plotted only once in the run loop at the start of the ITI.
trialOver = false;

% Grab start time and initial eye data
A.startTime = GetSecs;

% get gaze position
if viewpoint,
  [x,y] = vpx_GetGazePoint();
  [pw,ph] = vpx_GetPupilSize();
else,
  [x,y] = GetMouse(A.window); % "gaze space"
  x = min(x,S.screenRect(3));
  y = min(y,S.screenRect(4));

  pw = 0.0; ph = 0.0;
end

eyeData = repmat([A.startTime,x,y,pw,state,firstFlipTime],5,1);

eyeI = 5;

%%%%% Start trial loop %%%%%
while state < 2
    
    %%%%% GET ON-LINE VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GET CURRENT TIME
    currentTime = GetSecs;
    
    % GET EYE POSITION
    eyeI = eyeI+1;
%     eyeData(eyeI,1) = currentTime;
%     [eyeData(eyeI,2),eyeData(eyeI,3)] = vpx_GetGazePoint;
%     eyeData(eyeI,3) = 1 - eyeData(eyeI,3); % NEED TO INVERT SO ++ IS UP

    % get gaze position...
    if viewpoint,
      [x,y] = vpx_GetGazePoint();
      [pw,ph] = vpx_GetPupilSize();
    else,
      [x,y] = GetMouse(A.window); % "gaze space"
      x = min(x,S.screenRect(3));
      y = min(y,S.screenRect(4));

      pw = 0.0; ph = 0.0;
    end
    
    eyeData(eyeI,:) = [currentTime,x,y,pw,state,NaN];    

    % convert "gaze space" to deg. visual angle... relative to the
    % centre of the screen
    xDeg = (x - A.c(1))/A.dx;
    yDeg = (y - A.c(2))/A.dy;
    yDeg = -1*yDeg;
    
%     fprintf(1,'%.3f %.3f | %.3f %.3f %.3f %.3f | %.3f %.3f\n',x,y,A.c,A.dx,A.dy,xDeg,yDeg);
    
    if state == 0 && currentTime > A.startTime + P.faceDur
        state = 1; % Inter trial interval
        A.faceOff = GetSecs;
%         fprintf(handles.A.pump,'0 RUN'); % DELIVER REWARD
        handles.reward.deliver();
    end
    
    if state == 1 && currentTime > A.faceOff + P.iti
        state = 2; % Trial is over
        A.itiOver = GetSecs;
    end
    
    % Do anything that should be done once at trial end -- e.g. plotting
    % the eye trace. Then set trialOver to true.
    if state == 1 && ~trialOver,
      if viewpoint,
        % The TTL is removed when the faces are off
        vpx_SendCommandString(['ttl_out ' num2str(-P.vpxOutChannel)]);
 
        %%% SC: eye posn data
        vpx_SendCommandString(sprintf('dataFile_InsertString "TRIALEND:TRIALNO:%i"',handles.A.j));
        %%%
      end
      
      eval(handles.plotCmd);
      trialOver = true;
    end
    
    % GET THE DISPLAY READY FOR THE NEXT FLIP
    % STATE SPECIFIC DRAWS
    switch state
        case 0
            Screen('DrawTextures',A.window,A.texList,A.texRects,A.winRects)
    end
    % OTHER DRAWS
    % Show Eye Position
    if P.showEye
%         % Convert eye position from last 5 samples to pixel space
%         x = mean(eyeData(eyeI-4:eyeI,2)-A.c(1)) / A.dx;
%         y = mean(eyeData(eyeI-4:eyeI,3)-A.c(2)) / A.dy;        
%         cX = S.centerPix(1)+round(x);
%         cY = S.centerPix(2)-round(y);   % INVERT FOR SCREEN DRAWS!
      % convert eye position from deg. visual angle to pixel space
      cX = xDeg*S.pixPerDeg + S.centerPix(1);
      cY = -1*yDeg*S.pixPerDeg + S.centerPix(2);

      eR = round(P.eyeRadius*S.pixPerDeg);
      Screen('FrameOval',A.window,A.eyeColor,[cX-eR cY-eR cX+eR cY+eR],2);
    end
    % FLIP SCREEN NOW
    eyeData(eyeI,6) = Screen('Flip',A.window,GetSecs);
    if eyeI == 6 % First task frame flipped, drop TTL to Intan
      if viewpoint,
        vpx_SendCommandString(['ttl_out ' num2str(P.vpxOutChannel)]);

        %%% SC: eye posn data
        vpx_SendCommandString(sprintf('dataFile_InsertString "TRIALSTART:TRIALNO%i"',handles.A.j));
        %%%
      end
    end
    
    % Reset the screen
    Screen('FillRect',A.window,P.bkgd);
    
    % update handles
    drawnow; handles = guidata(hObject);
    % Update any changes made to the calibration
    A.c = handles.A.c;
    A.dx = handles.A.dx;
    A.dy = handles.A.dy;
    set(handles.CenterText,'String',sprintf('[%.2g %.2g]',A.c(1),A.c(2)));
%     set(handles.GainText,'String',sprintf('[%.2g %.2g]',10000*A.dx,10000*A.dy));
    set(handles.GainText,'String',sprintf('[%.2g %.2g]',A.dx,A.dy));
end

% CLEAR SCREEN
Screen('Flip',A.window);

% Trim eyeData from the start of the ITI, the ITI is collected just to keep
% plotting the smoothed eye position indicator on the visual display
itiState = 1;
n = find(eyeData(:,5) == itiState,1,'first');
if isempty(n)
    A.eyeData = eyeData;
else
    A.eyeData = eyeData(1:n,:);
end
