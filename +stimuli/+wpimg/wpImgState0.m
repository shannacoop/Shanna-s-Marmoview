classdef wpImgState0 < stimuli.state
  % state 0 - cross-fade image(s)
  
  properties
    tStart = NaN;
    
    % properties for image transitions...
    frameCnt = 0; % frame counter
    
%     trialStart = false;
  end
  
  methods (Access = public)
    function s = wpImgState0(hTrial,varargin),
      fprintf(1,'wpImgState0()\n');
      
      s = s@stimuli.state(0,hTrial); % call the parent constructor
            
%       s.tStart = GetSecs(); % ptb system time (should this be passed in?)
    end
    
    function beforeFrame(s),
%       fprintf(1,'wpImgState0.beforeFrame()\n');
      
      hTrial = s.hTrial;

      hTrial.hImg.beforeFrame(); % draw the image
    end
    
    function afterFrame(s,t),
%       fprintf(1,'wpImgState0.afterFrame()\n');
      
%       t = GetSecs();
            
      hTrial = s.hTrial;
      
      if isnan(s.tStart), % <-- first frame
        s.tStart = t;
        
        if hTrial.viewpoint,
          vpx_SendCommandString(sprintf('dataFile_InsertString "TRIALSTART:TRIALNO:%i"',hTrial.trialNum));
        end
      end
      
      if t > (s.tStart + hTrial.fadeDuration),
        % done with the cross-fade... move to state 1 - show image
%         hTrial.currentState = stimuli.wpimg.wpImgState1(hTrial);
        hTrial.setState(1);
        return;
      end
      
      alpha = min((t - s.tStart)./hTrial.fadeDuration,1.0); % ramp up opacity
      hTrial.hImg.alpha(2) = alpha;      
    end
    
  end % methods
  
end % classdef