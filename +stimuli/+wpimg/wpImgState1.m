classdef wpImgState1 < stimuli.state
  % state 0 - show image
  
  properties
    tStart = NaN;
  end
  
  methods (Access = public)
    function s = wpImgState1(hTrial,varargin),
      fprintf(1,'wpImgState1()\n');
      
      s = s@stimuli.state(1,hTrial); % call the parent constructor
            
%       s.tStart = GetSecs(); % ptb system time (should this be passed in?)
    end
    
    function beforeFrame(s),
%       fprintf(1,'wpImgState1.beforeFrame()\n');
      
      hTrial = s.hTrial;

      hTrial.hImg.beforeFrame(); % draw the image
    end
    
    function afterFrame(s,t),
%       fprintf(1,'wpImgState1.afterFrame()\n');
      
%       t = GetSecs();
            
      hTrial = s.hTrial;
      
      if isnan(s.tStart), % <-- first frame
        s.tStart = t;
      end

      if t > (s.tStart + hTrial.viewDuration),
        % done...
        if hTrial.viewpoint,
          vpx_SendCommandString(sprintf('dataFile_InsertString "TRIALEND:TRIALNO:%i"',hTrial.trialNum));
        end
        
        hTrial.done = true;
        return;
      end      
    end
    
  end % methods
  
end % classdef