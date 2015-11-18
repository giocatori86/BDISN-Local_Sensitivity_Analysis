%          Model Compilation                     Assignment Week 6
%          Sander Martijn Kerkdijk               Max Turpijn
%          Course: Behaviour Dynamics in social Networks 
%               Vrije Universiteit Amsterdam 2015
%                    Copying will be punished


function Temporarly_model = model_compilation( parameters )
% The usage of this function is to compile the model that explained in the
% reader for 'Parameter Estimation': To simulate the behaviour of human
% feeling of emotions from the insight of Damasio’s as-if body loop.
%
% Here the input variable 'parameters' consists of:
%   10 weight values (w1 to w10 in Table 2: refer the reader),
%       w1:  WS(s) --> SS(s)
%       w2:  EA(a) --> WS(b)
%       w3:  WS(b) --> SS(b)
%       w4:  SS(s) --> SR(s)
%       w5:  SR(s) --> PA(a)
%       w6:  F(b)  --> PA(a)
%       w7:  SS(b) --> SR(b)
%       w8:  PA(a) --> SR(b)
%       w9:  SR(b) --> F(b)
%       w10: PA(a) --> EA(a)
%   2 threshold values (thr_PA, and thr_SR),
%   2 steepness values (ste_PA, and steSR).
%   Further this returns a vector of feelings on time points:
%       T1 (0s), T3 (0.5s), T6 (1.25s), T8 (1.75s), T11 (2.5s),
%       T14 (3.25s), T16 (3.75s), T19 (4.5s), T22 (5.25s),
%       T24 (5.75s), T27 (6.5s), T29 (7s), T32 (7.75s),
%       T35 (8.5s), T37 (9s), T40 (9.75s)
%
% Also note that the order of the elements in the 'parameters' vector
% follows the same patern as above: weights follows thresholds follows
% steepnesses.
%
% $Author: Dilhan J. Thilakarathne $
% $Date: 2013/10/10 04:12:52 $
% $Version: 0.1 $

% Followings are the assumed constents in the model for slow speed factor,
% fast speed factor, and step size for the time: refer the reader for more
% Infomation.
speed_factor_slow = 0.5;
speed_factor_fast = 0.9;
time_step = 0.25;

% According to the given LPs it is required to know the activation strength
% of each state in the previous time instance relative to the current. This
% variable holds the values of each state:
%       1) WS(s)
%       2) EA(a)
%       3) WS(b)
%       4) SS(s)
%       5) SR(s)
%       6) F(b)
%       7) SS(b)
%       8) PA(a)
%       9) SR(b)
%   NOTE: the same order follows in bellow.
previous_instance_state_values = zeros(1,9);

% We assumed that the strength of WS(s) is always 1 (because of the
% stimulus s % is 1 and we have assumed that the stimulus s has completly
% activated the WS(s)).
previous_instance_state_values(1) = 1;

% This is used to track the progress of feeling over the step size for the
% time (i.e. time_step = 0.25).
feel_count = 1;
Temporarly_model = zeros(42,10);

% This is to find the activation of the each state over the time based on
% the causality and the strenths of the relavent states in the previous
% moment.
% NOTE: in the loop i starts with time 0.25 because of at time 0 only the
% state WS(s) is activated (all the others states wholes 0).
Temporarly_model(1,1) = 0;
Temporarly_model(1,2) = 1;

for i = 0.25: time_step: 10.25
    Temporarly_model(((i*4)+1),1) = i;
    current_instance_state_values = zeros(1,9);
    
    % WS(s)
    current_instance_state_values(1) = 1;
    Temporarly_model(((i*4)+1),2) = current_instance_state_values(1);
    % EA(a)
    x = parameters(10) * previous_instance_state_values(8);
    current_instance_state_values(2) = identity_function(...
        speed_factor_fast, x, previous_instance_state_values(2));
    Temporarly_model(((i*4)+1),10) = current_instance_state_values(2);
    
    % WS(b)
    x = parameters(2) * previous_instance_state_values(2);
    current_instance_state_values(3) = identity_function(...
        speed_factor_slow, x, previous_instance_state_values(3));
    Temporarly_model(((i*4)+1),3) = current_instance_state_values(3);
    
    
    % SS(s)
    x = parameters(1) * previous_instance_state_values(1);
    current_instance_state_values(4) = identity_function(...
        speed_factor_slow, x, previous_instance_state_values(4));
    Temporarly_model(((i*4)+1),4) = current_instance_state_values(4);
    
    % SR(s)
    x = parameters(4) * previous_instance_state_values(4);
    current_instance_state_values(5) = identity_function(...
        speed_factor_fast, x, previous_instance_state_values(5));
    Temporarly_model(((i*4)+1),6) = current_instance_state_values(5);
    
    % F(b)
    x = parameters(9) * previous_instance_state_values(9);
    current_instance_state_values(6) = identity_function(...
        speed_factor_fast, x, previous_instance_state_values(6));
    feel_count = feel_count + 1;
    Temporarly_model(((i*4)+1),8) = current_instance_state_values(6);
    
    % SS(b)
    x = parameters(3) * previous_instance_state_values(3);
    current_instance_state_values(7) = identity_function(...
        speed_factor_slow, x, previous_instance_state_values(7));
    Temporarly_model(((i*4)+1),5) = current_instance_state_values(7);
    
    % PA(a)
    x = ( parameters(5) * previous_instance_state_values(5) ) + ...
        ( parameters(6) * previous_instance_state_values(6) );
    current_instance_state_values(8) = combination_function( ...
        speed_factor_fast, parameters(11), parameters(13), x, ...
        previous_instance_state_values(8) );
    Temporarly_model(((i*4)+1),9) = current_instance_state_values(8);
    
    % SR(b)
    x = ( parameters(7) * previous_instance_state_values(7) ) + ...
        ( parameters(8) * previous_instance_state_values(8) );
    current_instance_state_values(9) = combination_function( ...
        speed_factor_fast, parameters(12), parameters(14), x, ...
        previous_instance_state_values(9) );
    Temporarly_model(((i*4)+1),7) = current_instance_state_values(9);
    previous_instance_state_values = current_instance_state_values; 
    
end
    % Following function works as the identity function: f(X,W) = X.W
    function strength = identity_function( speed_factor, ...
            x, current_value )
        strength = current_value + ( time_step * ... 
            ( x - current_value) * speed_factor );
    end

    % Following function works as the identity function:
    %   f(X) = th(?,?,X)= 
    %       (1/(1+ e^(-?(X-?) ) )- 1/(1+ e^?? ))(1+ e^(-??))    when  X > 0
    %   and f(X) = 0                                            when X  ? 0
    function strength = combination_function( speed_factor, ...
            threshold, steepness, x, current_value )
        out_logistic_combination_function = ( (1 / (1 + ... 
            exp ( -steepness * ( x - threshold)))) - ... 
            (1 / (1 + exp (steepness * threshold))) ) * ... 
            (1 + exp (-steepness * threshold) );
        strength = current_value + (time_step * ... 
            ((out_logistic_combination_function) - current_value) * ...
            speed_factor );
    end

% End of the function
end