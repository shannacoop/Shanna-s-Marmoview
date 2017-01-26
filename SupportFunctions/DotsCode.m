%%
ptr=Screen('OpenWindow', 0, [], [0 0 640 400]);

%%
nDots=50;
for k=1:nDots
    d(k)=stimuli.dots(ptr, 'size', 1, 'speed', 10, 'numDots', 50, 'maxRadius', 100);
end

%%
for k=1:nDots
    d(k).mode=1; % gaussian
    d(k).numDots=100;
    d(k).position=[rand*640 rand*400];
    d(k).direction=rand*360;
    d(k).bandwdth=1; %rand*60;
    d(k).lifetime=inf;
    d(k).maxRadius=40;
    d(k).speed=rand*3;
    d(k).beforeTrial;
    d(k).colour=[0 0 0];%(rand(1,3)<.1)*255;
end


for i= 1:500

    for k=1:nDots
%         d(k).direction=d(k).direction+randn*5;
        d(k).beforeFrame;
    end
    
    Screen('Flip', ptr, 0);
    if rand<.05
        r=randi(nDots);
        d(r).colour=[255 0 0];
    end
    for k=1:nDots
        d(k).afterFrame;
        if r~=k
            d(k).colour=[0 0 0];
        end
    end
    
    
end