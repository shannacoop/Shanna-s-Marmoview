sca;

win = Screen('OpenWindow',1,128);

pause(1);

x = (0:15:255)';

y = nan(18,1);

for i = 1:18
    Screen('FillRect',win,x(i));
    Screen('Flip',win);
    
    y(i) = input(sprintf('Lum for %d: ',x(i)));
end

sca;
