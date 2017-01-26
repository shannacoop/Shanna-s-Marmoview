function [A,handles] = spatialAcuRun(S,P,A,hObject)

% [A,handles] = spatialAcuRun(S,P,A,hObject)

viewpoint = true; % FIXME: for now, assume the ViewPoint eye tracker is present...
if isfield(S,'viewpoint'),
  viewpoint = S.viewpoint; % allows one to turn off the eye tracker in the rig settings
end

% Set up arrays to collect eye data for max trial duration
A.fixDur = P.fixMin + ceil(1000*P.fixRan*rand)/1000;  % randomized fix duration
% A.sf = P.type;
maxDur = P.startDur + A.fixDur + P.stimDur + P.flightDur + P.holdDur;
% Collecting at frame rate
eyeData = nan(round(1.1*maxDur*120),6);

% Update handles
pause(.01); handles = guidata(hObject);

% Setup first frame
Screen('FillRect',A.window,P.bkgd);
% Draw a full luminance fix point
Screen('DrawTexture',A.window,A.fixTex1,A.fixRect1,A.winRect1);
% when flipping, store time in eyeData
firstFlipTime = Screen('Flip',A.window,GetSecs);

% Flags that control transitions
% State is the main variable to control transitions. A protocol can be
% described by shifting through states. For this protocol:
% State 0 -- Fixation not yet initiated, flash the fixation spot
% State 1 -- Fixation entered, grace period
% State 2 -- Hold fixation before stimulus onset
% State 3 -- Stimulus is present, wait for saccade
% State 4 -- Stimulus off, dim fix to cue saccade
% State 5 -- Saccade initiated, flight time grace, fixation spot off
% State 6 -- Hold stimulus until reward
% State 7 -- Inter-trial Interval, just waiting, eye collection off
% State 8 -- end of the trial, blank frame ITI period
% State 9 -- end of trial
showFace = 0;  % prob to show face at start
state = 0;
% Errors describe why a trial was not completed
% Error 1 -- Failure to enter fixation window
% Error 2 -- Failure to hold fixation until stimulus onset
% Error 3 -- Failure to initiate a saccade to leave fixation window
% Error 4 -- Failure to saccade to the stimulus
% Error 5 -- Failure to hold the stimulus once selected
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
ShowApert = 0;  

%%%%% Start trial loop %%%%%
while state < 9
    
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

    % POLAR COORDINATES FOR PIE SLICE METHOD, note three values of polT to
    % ensure atan2 discontinuity does not wreck shit
%     polT = atan2(y,x)+[-2*pi 0 2*pi];
%     polR = norm([x y]);
    polT = atan2(yDeg,xDeg)+[-2*pi 0 2*pi];
    polR = norm([xDeg yDeg]);
    
    %%%%% STATE 0 -- GET INTO FIXATION WINDOW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % If eye travels within the fixation window, move to state 1
%     if state == 0 && norm([x y]) < P.initWinRadius
    if state == 0 && norm([xDeg yDeg]) < P.initWinRadius
        state = 1; % Move to fixation grace
        A.fix1Start = GetSecs;
    end
    
    % Trial expires if not started within the start duration
    if state == 0 && currentTime > A.startTime + P.startDur
        state = 8; % Move to iti -- inter-trial interval
        error = 1; % Error 1 is failure to initiate
        A.itiStart = GetSecs;
    end
    
    %%%%% STATE 1 -- GRACE PERIOD TO BE IN FIXATION WINDOW %%%%%%%%%%%%%%%%
    % A grace period is given before the eye must remain in fixation
    if state == 1 && currentTime > A.fix1Start + P.fixGrace
%         if norm([x y]) < P.initWinRadius
        if norm([xDeg yDeg]) < P.initWinRadius
            state = 2; % Move to hold fixation
        else
            state = 8;
            error = 1; % Error 1 is failure to initiate
            A.itiStart = GetSecs;
        end
    end
    
    %%%%% STATE 2 -- HOLD FIXATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % If fixation is held for the fixation duration, move to state 3
    if state == 2 && currentTime > A.fix1Start + A.fixDur
        state = 3; % Move to show stimulus
        %***** reward here for holding of fixation
%         fprintf(handles.A.pump,'0 RUN'); % DELIVER REWARD
        handles.reward.deliver();
        %************************
        A.stimStart = GetSecs;
    end
    % Eye must remain in the fixation window
%     if state == 2 && norm([x y]) > P.fixWinRadius
    if state == 2 && norm([xDeg yDeg]) > P.fixWinRadius
        state = 8; % Move to iti -- inter-trial interval
        error = 2; % Error 2 is failure to hold fixation
        A.itiStart = GetSecs;
    end
    
    %%%%% STATE 3+4 -- SHOW STIMULUS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Eye leaving fixation indicates a saccade, move to state 4
%     if ((state == 3) || (state == 4)) && norm([x y]) > P.fixWinRadius
    if ((state == 3) || (state == 4)) && norm([xDeg yDeg]) > P.fixWinRadius
        state = 5; % dim fixation if so, then move to saccade in flight
        A.responseStart = GetSecs;
    end
    
    %**** in this scenario, eye always leaves, only question if
    %**** it goes to the right location
    % Eye must leave fixation within stimulus duration or counted as no
    % response
    if state == 3 && currentTime > A.stimStart + P.dimHold   % P.stimDur
        state = 4; % remove stim and dim fixation to cue "Go"
        %***** reward here again for holding of fixation in case he
        %***** did not see the target and held longer
%         fprintf(handles.A.pump,'0 RUN'); % DELIVER REWARD   
        handles.reward.deliver();
        %************************
    end
    
    % Eye must leave fixation within stimulus duration or counted as no
    % response after some much longer interval
    if state == 4 && currentTime > A.stimStart + P.noresponseDur
        state = 7; % Move to iti -- inter-trial interval
        error = 3; % Error 3 is failure to make a saccade
        A.itiStart = GetSecs;
    end
     
    %%%%% STATE 5 -- IN FLIGHT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Give the saccade time to finish flight
    if state == 5 && currentTime > A.responseStart + P.flightDur
        % If the saccade shifted gaze to the stimulus, proceed to state 5
        if polR > P.stimWinMinRad && polR < P.stimWinMaxRad && min(abs(A.stimTheta-polT)) < P.stimWinTheta
            state = 6; % Move to hold stimulus
            A.responseEnd = GetSecs;
           % Otherwise the response failed to select the stimulus
        else
            state = 7; % Move to iti -- inter-trial interval
            error = 4; % Error 4 is failure to select the stimulus.
            A.itiStart = GetSecs;
        end
    end
    
    %%%%% STATE 6 -- HOLD STIMULUS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % If the eye does not leave the stimulus, then reward
    if state == 6 && currentTime > A.responseEnd + P.holdDur
        state = 7; % Move to iti -- trial is over
        A.itiStart = GetSecs;
    end
    % If the eye leaves before hold duration, no reward
    if state == 6 && ~(polR > P.stimWinMinRad && polR < P.stimWinMaxRad && min(abs(A.stimTheta-polT)) < P.stimWinTheta)
        state = 7; % Move to iti -- inter-trial interval
        error = 5; % Error 5 is failure to hold the stimulus
        A.itiStart = GetSecs;
    end
    
    %%%%% STATE 7 -- INTER-TRIAL INTERVAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deliver rewards
    if state == 7 && ~error && rewardCount < P.rewardNumber
        if currentTime > A.itiStart + 0.2*rewardCount % deliver in 200 ms increments
            rewardCount = rewardCount + 1;
%             fprintf(handles.A.pump,'0 RUN'); % DELIVER REWARD
            handles.reward.deliver();
        end
    end
    
    % Do anything that should be done once at trial end -- e.g. plotting
    % the eye trace. Then set trialOver to true
    if state >= 7 && ~trialOver
      if viewpoint,
        % The TTL is removed at the start of the ITI
        vpx_SendCommandString(['ttl_out ' num2str(-P.vpxOutChannel)]);
        
        %%% SC: eye posn data
        vpx_SendCommandString(sprintf('dataFile_InsertString "TRIALEND:TRIALNO:%i"',handles.A.j));
        %%%
      end
      
      % Plot the eye trace
      eval(handles.plotCmd);
      % Make sure this doesn't occur more than once
      trialOver = true;
    end
    % Check for inter-trial interval finished    
    if state == 7 && currentTime > A.itiStart + P.iti
        if error 
            state = 8; % Inter-trial interval complete,
                       % but also run Error ITI interval, then exit run loop
        end
        if ~error && rewardCount == P.rewardNumber   % once reward done, may continue
            state = 9; % Make sure not to leave the loop until all reward is delivered
        end
    end
    
    if state == 8 && currentTime > A.itiStart + P.iti + P.blank_iti
       state = 9; 
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
                if (showFace)
                    % face image, but shown at fixation
                    Screen('DrawTexture',A.window,A.faceTex(A.faceIndex),A.faceTexRect,A.faceFixRect); 
                else
                    % Screen('DrawTexture',A.window,A.faceTex(A.faceIndex),A.faceTexRect,A.winRect1);   % small face
                    Screen('DrawTexture',A.window,A.fixTex1,A.fixRect1,A.winRect1);  % original fixation point
                end
            end
            flashCounter = mod(flashCounter+1,P.flashFrameLength);
            if flashCounter == 0
                showFix = ~showFix;
                if (showFace == 0)
                    if (rand < P.probShowFace)  % 
                        showFace = 1;
                    end
                else
                    showFace = 0;
                end
            end
            % Aperture outlines
            % draw_apertures(P,S,A);
            
        case 1
            % Bright fixation spot, prior to stimulus onset
            
            Screen('DrawTexture',A.window,A.fixTex1,A.fixRect1,A.winRect1);
            
            % Screen('DrawTexture',A.window,A.faceTex(A.faceIndex),A.faceTexRect,A.faceFixRect); 
            
            % Aperture outlines
            % draw_apertures(P,S,A);
            
        case 2
        
            Screen('DrawTexture',A.window,A.fixTex1,A.fixRect1,A.winRect1);
            
            
            % Screen('DrawTexture',A.window,A.faceTex(A.faceIndex),A.faceTexRect,A.faceFixRect); 
            % Aperture outlines
            % draw_apertures(P,S,A);
                
        case 3    % show gaze cue
           
            %Screen('DrawTexture',A.window,A.fixTex1,A.fixRect1,A.winRect1);
            
            % Dim fix spot (fixation hold is accomplished and a drop
            % delivered)
            Screen('DrawTexture',A.window,A.fixTex2,A.fixRect2,A.winRect2);
            
            
            %********* show stimulus
            if ( currentTime < A.stimStart + P.stimDur )
               if ( P.cpd < P.cutfreq) 
                 Screen('DrawTexture',A.window,A.tex,A.texRect,A.winRect,P.angle);
               end
               % if P.distLum; draw_lum_distractors(P,S,A); end
            end
            %************   
            % draw_apertures(P,S,A);
            
        
        case 4    % disappear fixation and show apertures to go
            
            % Disapper the dimmed fix spot, another drop given
            % Screen('DrawTexture',A.window,A.fixTex2,A.fixRect2,A.winRect2);
            
            %********* show stimulus if still appropriate
            if ( currentTime < A.stimStart + P.stimDur )
               if ( P.cpd < P.cutfreq) 
                 Screen('DrawTexture',A.window,A.tex,A.texRect,A.winRect,P.angle);
               end
              % if P.distLum; draw_lum_distractors(P,S,A); end
            end
            
            % Aperture outlines
            ShowApert = 1;
            draw_apertures(P,S,A);
            %*************************************
            
        case 5    % saccade in flight, dim fixation, just in case not done before
            % Dim fix spot
            %Screen('DrawTexture',A.window,A.fixTex2,A.fixRect2,A.winRect2);
            
            % Screen('DrawTexture',A.window,A.gazeTex(A.gazeIndex),A.gazeTexRect,A.gazeFixRect); 
            
            % Grating
            %********* show stimulus if still appropriate
            if ( currentTime < A.stimStart + P.stimDur )
               if ( P.cpd < P.cutfreq) 
                 Screen('DrawTexture',A.window,A.tex,A.texRect,A.winRect,P.angle);
               end
               if P.distLum; draw_lum_distractors(P,S,A); end
            end
            
            % Draw luminance distractors if requested
            % if P.distLum; draw_lum_distractors(P,S,A); end
            % Aperture outlines
            if (ShowApert == 1)
              draw_apertures(P,S,A);
            end
            
        case {6 7} % once saccade landed, reappear stimulus,  show correct option
            % If error show what the boring grating looks like
            if error
                Screen('DrawTexture',A.window,A.tex,A.texRect,A.winRect,P.angle);
            end
            if P.distLum; draw_lum_distractors(P,S,A); end
            % Draw apertures before face reward, otherwise they will
            % occlude a large face
            if (ShowApert == 1)
              draw_apertures(P,S,A);
            end
            %****** also highlight aperture
            if (error == 3) | (error == 4)   % he did not go
                aR = round(P.apertureRadius*S.pixPerDeg);
                cX = S.centerPix(1)+round(P.xDeg * S.pixPerDeg);
                cY = S.centerPix(2)-round(P.yDeg * S.pixPerDeg);
                Screen('FrameOval',A.window,P.cueColor,[cX-aR cY-aR cX+aR cY+aR],P.apertureWidth);
            end
            % Face instead of grating if correct, as an extra reward
            if ~error
                Screen('DrawTexture',A.window,A.faceTex(A.faceIndex),A.faceTexRect,A.faceWinRect);
            end
            
        case 8
            % leave everything blank for a minimum ITI           
    end
    % disp(sprintf('State %d',state));  JFM used this for debugging
    
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
    set(handles.GainText,'String',sprintf('[%.2g %.2g]',10000*A.dx,10000*A.dy));
end

% CLEAR SCREEN
Screen('Flip',A.window);

% Trim eyeData from the start of the ITI, the ITI is collected just to keep
% plotting the smoothed eye position indicator on the visual display
itiStates = [7 8];
n = find(ismember(eyeData(:,5),itiStates),1,'first');
if isempty(n)
    A.eyeData = eyeData;
else
    A.eyeData = eyeData(1:n,:);
end

% GET ERROR FOR DATA PURPOSES
A.error = error;

return;


function draw_apertures(P,S,A)
            
    aR = round(P.apertureRadius*S.pixPerDeg);
    aC = S.pixPerDeg*norm([P.xDeg P.yDeg]);
    %for i = 1:P.apertures
    for i = P.startApert:2:P.apertures   % draw every other
       ango =  pi*(i-1)/(P.apertures/2);
       x = aC*cos(ango);
       y = aC*sin(ango);
       cX = S.centerPix(1)+round(x);
       cY = S.centerPix(2)-round(y);   % FOR SCREEN DRAWS, VERTICAL IS INVERTED
       Screen('FrameOval',A.window,P.apertureColor,[cX-aR cY-aR cX+aR cY+aR],P.apertureWidth);
    end
    if A.useContrastCue    % overwrites other aperture with higher contrast
       x = aC*cos(A.stimTheta); y = aC*sin(A.stimTheta);
       cX = S.centerPix(1)+round(x); cY = S.centerPix(2)-round(y);
       Screen('FrameOval',A.window,P.cueColor,[cX-aR cY-aR cX+aR cY+aR],P.apertureWidth);
    end
    
return;

function draw_lum_distractors(P,S,A)

for i = 1:(P.apertures-1)
    Screen('DrawTexture',A.window,A.distTex{i},A.distRect,A.distWin{i});
end

return;
    
