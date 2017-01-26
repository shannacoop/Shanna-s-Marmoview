function [A,handles] = fixFlashRun(S,P,A,hObject)

% [A,handles] = fixFlashRun(S,P,A,hObject)

viewpoint = true; % FIXME: for now, assume the ViewPoint eye tracker is present...
if isfield(S,'viewpoint'),
  viewpoint = S.viewpoint; % allows one to turn off the eye tracker in the rig settings
end

maxDur = P.startDur + A.fixDur + P.iti + P.timeOut;
% Collecting at frame rate
eyeData = nan(round(1.1*maxDur*S.frameRate),6);

% Update handles
pause(.01); handles = guidata(hObject);

% Setup first frame
Screen('FillRect',A.window,P.bkgd);
Screen('DrawTexture',A.window,A.fixTex,A.fixRect,A.winRect);
% when flipping, store time in eyeData
firstFlipTime = Screen('Flip',A.window,GetSecs);

% Flags that control transitions
% State is the main variable to control transitions. A protocol can be
% described by shifting through states. For this protocol:
% State 0 -- Fixation not yet initiated, flash the fixation spot
% State 1 -- Fixation entered, grace period
% State 2 -- Hold fixation for reward
% State 3 -- ITI
% State 4 -- Time out for failure
% State 5 -- End of trial
state = 0;
% Errors describe why a trial was not completed
% Error 1 -- Failure to enter fixation window
% Error 2 -- Failure to hold fixation until reward
error = 0;
% showFix is a flag to check whether to show the fixation spot or not while
% it is flashing in state 0
showFix = true;
% flashCounter counts the frames to switch ShowFix off and on
flashCounter = 0;
% trialOver checks for whether the ITI has begun. It's used to ensure the
% eye trace is plotted only once in the run loop at the start of the ITI.
trialOver = false;
% rewardCount counts the number of juice pulses, 1 delivered per frame
% refresh
rewardCount = 0;

% Grab start time and initial eye data
% The reason 5 repeats are collected is for eye point smoothing
A.startTime = GetSecs;
A.responseEnd = A.startTime;   %over-written later, but crashes first trial if not

% eyeData(1:5,1) = A.startTime;
% [eyeData(1:5,2),eyeData(1:5,3)] = vpx_GetGazePoint;
% % eyeData(1:5,3) = 1 - eyeData(1:5,3); % NEED TO INVERT SO ++ IS UP
% eyeData(1:5,4) = vpx_GetPupilSize;
% eyeData(1:5,5) = state;
% eyeData(1:5,6) = firstFlipTime;

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
GABcounter = 1;

%%%%% Start trial loop %%%%%
while state < 5
    
    %%%%% GET ON-LINE VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GET CURRENT TIME
    currentTime = GetSecs;
    
    % GRAB EYE POSITON AND PUPIL SIZE
%     [x,y] = vpx_GetGazePoint; %y = 1-y; % NEED TO INVERT SO ++ IS UP
%     p = vpx_GetPupilSize;
    
    % GET EYE POSITION
    eyeI = eyeI+1;
%     eyeData(eyeI,1) = currentTime;
%     eyeData(eyeI,2) = x;
%     eyeData(eyeI,3) = y;
%     eyeData(eyeI,4) = p;
%     eyeData(eyeI,5) = state;
    
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

    %%%%% STATE 0 -- GET INTO FIXATION WINDOW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % If eye travels within the fixation window, move to state 1
%     if state == 0 && norm([x y]) < P.fixWinRadius
    if state == 0 && norm([xDeg yDeg]) < P.fixWinRadius
        state = 1; % Move to fixation grace
        A.fixStart = GetSecs;
    end
    % Trial expires if not started within the start duration
    if state == 0 && currentTime > A.startTime + P.startDur
        state = 3; % Move to iti -- inter-trial interval
        error = 1; % Error 1 is failure to initiate
        A.itiStart = GetSecs;
    end
    
    %%%%% STATE 1 -- GRACE PERIOD TO BE IN FIXATION WINDOW %%%%%%%%%%%%%%%%
    % A grace period is given before the eye must remain in fixation
    if state == 1 && currentTime > A.fixStart + P.fixGrace
        state = 2; % Move to hold fixation
    end
    
    %%%%% STATE 2 -- HOLD FIXATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if state == 2    % show flashing stimuli at random points each frame

  %$$$$$$$$$$$$$$$$$$$ JM 2/1/16 $$$$$$$$$$$$$      
        %******** first I would select a Gabor stimulus
         %******** then select a position on the screen at random, but not
         %******** avoiding hitting the fixation window
         %******** then figure out how to change winRect for that position
         %******** and then draw the Gabor on this video frame
         %******** we may need to erase the Gabor from previous frame
         % A grating that ramps on
%            Screen('DrawTexture',A.window,A.tex,A.texRect,A.winRect);
%
        %for k = 1:P.OriNum
        %    Screen('DrawTexture',A.window,A.GABtex{1},A.GABtexRect{1},A.GABwinRect{1});
        %end
        
        %********* pick a random screen location but not overlapping
        %fixation
        ampo = P.gabMinRadius + (P.gabMaxRadius-P.gabMinRadius)*rand;
        ango = rand*2*pi;
        dx = cos(ango)*ampo;
        dy = sin(ango)*ampo;
        cX = S.centerPix(1)+ round( S.pixPerDeg * dx);
        cY = S.centerPix(2)+ round( S.pixPerDeg * dy);   %
        %*************
        fr = (A.GABwinRect{GABcounter}(3)-A.GABwinRect{GABcounter}(1))/2;
        testWinRect = [cX-fr cY-fr cX+fr cY+fr];
        
        %******* update that Gabor location for items in GABcounter
        A.GABwinRect{GABcounter} = testWinRect;
        GABcounter = GABcounter + 1;
        if (GABcounter > P.OriNum)
            GABcounter = 1;
        end
        
        %***** then display all P.OriNum of the Gabors
        for k = 1:P.OriNum 
          %RG = 1+floor((P.OriNum-0.0001)*rand);  % pick a random Gabor
          %Screen('DrawTexture',A.window,A.GABtex{RG},A.GABtexRect{RG},testWinRect);
           Screen('DrawTexture',A.window,A.GABtex{k},A.GABtexRect{k},A.GABwinRect{k});
        end
        
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

    end
    
    % If fixation is held for the fixation duration, then reward
    if state == 2 && currentTime > A.fixStart + A.fixDur
        state = 3; % Move to iti -- inter-trial interval
        A.itiStart = GetSecs;
    end
    % Eye must remain in the fixation window
%     if state == 2 && norm([x y]) > P.fixWinRadius
    if state == 2 && norm([xDeg yDeg]) > P.fixWinRadius  
        state = 3; % Move to iti -- inter-trial interval
        error = 2; % Error 2 is failure to hold fixation
        A.itiStart = GetSecs;
    end
    
    %%%%% STATE 3 -- INTER-TRIAL INTERVAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deliver rewards
    if state == 3 && ~error && rewardCount < P.rewardNumber
        if currentTime > A.itiStart + 0.2*rewardCount % deliver in 200 ms increments
            rewardCount = rewardCount + 1;
%             fprintf(handles.A.pump,'0 RUN'); % DELIVER REWARD
            handles.reward.deliver();
        end
    end
    % Do anything that should be done once at trial end -- e.g. plotting
    % the eye trace. Then set trialOver to true.
    if state >= 3 && ~trialOver
      if viewpoint,
        vpx_SendCommandString(['ttl_out ' num2str(-P.vpxOutChannel)]);
        
        %%% SC: eye posn data
        vpx_SendCommandString(sprintf('dataFile_InsertString "TRIALEND:TRIALNO:%i"',handles.A.j));
        %%%
      end
      
      eval(handles.plotCmd);
      trialOver = true;
    end
    % Check for inter-trial interval finished    
    if state == 3 && currentTime > A.itiStart + P.iti
        if error 
            state = 4; % Inter-trial interval complete,
                       % but also run Error ITI interval, then exit run loop
        end
        if ~error && rewardCount == P.rewardNumber   % once reward done, may continue
            state = 5; % Make sure not to leave the loop until all reward is delivered
        end
    end
    
    %%%%% STATE 4 -- ADDITIONAL TIME OUT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if state == 4 && currentTime > A.itiStart + P.iti + P.timeOut
       state = 5; 
    end
    
    % GET THE DISPLAY READY FOR THE NEXT FLIP
    % DRAW GAZE POSITION FIRST SO IT DOESN'T OVERWRITE STIMULUS DRAWS
    if P.showEye
%         % Show Eye Position
%         % Convert eye position from last 5 samples to pixel space for
%         % screen plotting
%         x = mean(eyeData(eyeI-4:eyeI,2)-A.c(1)) / A.dx;
%         y = mean(eyeData(eyeI-4:eyeI,3)-A.c(2)) / A.dy;
%         cX = S.centerPix(1)+round(x);
%         cY = S.centerPix(2)-round(y);   % FOR SCREEN DRAWS, VERTICAL IS INVERTED
        % convert eye position from deg. visual angle to pixel space
        cX = xDeg*S.pixPerDeg + S.centerPix(1);
        cY = -1*yDeg*S.pixPerDeg + S.centerPix(2);

        eR = round(P.eyeRadius*S.pixPerDeg);
        Screen('FrameOval',A.window,A.eyeColor,[cX-eR cY-eR cX+eR cY+eR],2);
    end
    % STATE SPECIFIC DRAWS
    switch state
        case 0
            if showFix
                if ~A.faceTrial
                    Screen('DrawTexture',A.window,A.fixTex,A.fixRect,A.winRect);
                else
                    Screen('DrawTexture',A.window,A.faceTex,A.faceTexRect,A.faceWinRect);
                end
            end
            flashCounter = mod(flashCounter+1,P.flashFrameLength);
            if flashCounter == 0
                showFix = ~showFix;
                if showFix && A.faceTrial == 0
                    if rand < P.faceTrialFraction
                        A.faceTrial = 1;
                    end
                else
                    A.faceTrial = 0;
                end
            end
        case {1 2}
            Screen('DrawTexture',A.window,A.fixTex,A.fixRect,A.winRect);
        case 3
            if ~error
                Screen('DrawTexture',A.window,A.faceTex,A.faceTexRect,A.faceWinRect);
            end
    end
    
    % FLIP SCREEN NOW
    eyeData(eyeI,6) = Screen('Flip',A.window,GetSecs);
    if eyeI == 6 % First task frame flipped, drop TTL to Intan
      if viewpoint,
        vpx_SendCommandString(['ttl_out ' num2str(P.vpxOutChannel)]);

        %%% SC: eye posn data
        vpx_SendCommandString(sprintf('dataFile_InsertString "TRIALSTART:TRIALNO:%i"',handles.A.j));
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
itiState = 3;
n = find(eyeData(:,5) == itiState,1,'first');
if isempty(n)
    A.eyeData = eyeData(5:end,:); % First 5 entries are the same
else
    A.eyeData = eyeData(5:n,:);
end

% GET ERRORS FOR DATA PURPOSES
A.error = error;
