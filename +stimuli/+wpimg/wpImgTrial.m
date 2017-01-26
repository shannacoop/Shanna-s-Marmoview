classdef wpImgTrial < stimuli.trial
  properties
    trialNum@double = 0;
    
    done@logical = false; % true when trial is complete
        
    x; % gaze position (deg.)
    y;
      
    % stimulus objects
    hImg@handle;
    
    % trial objects
%     hEye@handle; % FIXME: eye tracker?
    viewpoint@logical = false;
%    hReward@handle;
        
    % task/trial parameters
    fadeDuration@double; % seconds    
    viewDuration@double; % seconds
  end
  
  methods (Access = public)
    function o = wpImgTrial(hImg,varargin),
      o.hImg = hImg;
      
%       o.hReward = hReward;
      
      % initialise the @state object pool
      o.addState(stimuli.wpimg.wpImgState0(o));
      o.addState(stimuli.wpimg.wpImgState1(o));

      % set intiial state
      o.setState(0);
      
      if nargin < 2,
        return
      end
      
      % initialise input parser
      args = varargin;
      p = inputParser;
%       p.KeepUnmatched = true;
      p.StructExpand = true;
      p.addParameter('fadeDuration',NaN,@double); % seconds
      p.addParameter('viewDuration',NaN,@double); % seconds
      p.addParameter('viewpoint',false,@islogical);
      
      try
        p.parse(args{:});
      catch,
        warning('Failed to parse name-value arguments.');
        return;
      end
      
      args = p.Results;
    
      o.fadeDuration = args.fadeDuration;
      o.viewDuration = args.viewDuration;
      o.viewpoint = args.viewpoint;
    end
    
  end % methods
  
end % classdef
