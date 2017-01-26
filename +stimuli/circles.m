classdef circles < handle
  % Matlab class for drawing circles using the psych. toolbox.
  %
  % The class constructor can be called with a range of arguments:
  %
  %   size     - diameter (pixels)
  %   weight   - line weight (pixels)
  %   colour   - line colour (clut index or [r,g,b])
  %   position - center of aperture (x,y; pixels)
  
  % 14-06-2016 - Shaun L. Cloherty <s.cloherty@ieee.org>
  
  properties (Access = public),
    size@double = 0; % pixels
    weight@double = 2; % pixels
    colour@double = ones([1,3]); % clut index or [r,g,b]
    position@double = [0.0, 0.0]; % [x,y] (pixels)
  end
        
  properties (Access = private)
    winPtr; % ptb window
  end
  
  methods (Access = public)
    function o = circles(winPtr,varargin), % marmoview's initCmd?
      o.winPtr = winPtr;
      
      if nargin == 1,
        return
      end

      % initialise input parser
      args = varargin;
      p = inputParser;
%       p.KeepUnmatched = true;
      p.StructExpand = true;
      p.addParamValue('size',o.size,@isfloat); % pixels
      p.addParamValue('weight',o.weight,@isfloat); % pixels
      p.addParamValue('colour',o.colour,@isfloat); % clut index or [r,g,b]
      p.addParamValue('position',o.position,@isfloat); % [x,y] (pixels)
                  
      try
        p.parse(args{:});
      catch,
        warning('Failed to parse name-value arguments.');
        return;
      end
      
      args = p.Results;
    
      o.size = args.size;
      o.weight = args.weight;
      o.colour = args.colour;
      o.position = args.position;
    end
        
    function beforeTrial(o), % marmoview's nextCmd?
    end
    
    function beforeFrame(o) % Run?
      o.drawCircles();
    end
        
    function afterFrame(o) % Run?
    end
  end % methods
    
  methods (Access = public)        
    function drawCircles(o),
      r = floor(o.size./2); % radius in pixels
      
      rect = kron([1,1],o.position) + kron(r(:),[-1, -1, +1, +1]);
      if o.weight > 0,
        Screen('FrameOval',o.winPtr,o.colour,rect',o.weight);
      else,
        Screen('FillOval',o.winPtr,o.colour,rect');
      end
      
      if 0, % for debugging...
        th = [0:0.05:1]*2*pi;
%         r = ones(size(th))*r; % pixels
        [r,th] = meshgrid(r,th);      

        for ii = 1:size(r,2),
          [x,y] = pol2cart(th(:,ii),r(:,ii));
      
          hold on;
          plot(x+o.position(1),y+o.position(2),'-','Color',o.colour);
%           axis([-1, 1, -1, 1]*20);
%           axis equal;
          hold off
        end
      end % if 0|1
      
    end
  end % methods
  
end % classdef
