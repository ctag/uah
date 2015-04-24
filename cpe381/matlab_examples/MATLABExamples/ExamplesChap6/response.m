 function response(N,D)
    sys=tf(N,D)
    poles=roots(D)
    zeros=roots(N)
    
    figure(1)
    pzmap(sys);grid
    figure(2)
    T=0:0.25:20;T1=0:0.25:40;
    for t=1:3,
    if t==3,
        D1=[D 0]; % for ramp response
    end
    
    if t==1,
        subplot(311)
        y=impulse(sys,T); 
        plot(y);title(' Impulse response');ylabel('h(t)');xlabel('t'); grid
        axis([0 80 1.1*min(y) 1.1*max(y)])
    elseif t==2,
        subplot(312)
        y=step(sys,T);
        plot(y);title(' Unit-step response');ylabel('s(t)');xlabel('t');grid
        axis([0 80 1.1*min(y) 1.1*max(y)])
    else
        subplot(313)
        sys=tf(N,D1); % ramp response
        y=step(sys,T1);
        plot(y); title(' Ramp response'); ylabel('q(t)'); xlabel('t');grid
        axis([0 160 1.1*min(y) 1.1*max(y)])
    end
    end