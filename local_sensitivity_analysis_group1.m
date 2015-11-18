%          Local Sensitivity Analysis         Assignment Week 6
%          Sander Martijn Kerkdijk               Max Turpijn
%          Course: Behaviour Dynamics in social Networks 
%               Vrije Universiteit Amsterdam 2015
%                    Copying will be punished

filename = 'referenceDataset.xlsx';
actualFeelData = xlsread(filename);

% Actual output values of feeling on step size = 0.25

% Pre identified stopping critera: lets say SSRstop
parameter_step = 0.05;
ssr_stop = 0.5;
% progress of error to plot
epochs = 1000;
error = zeros(1, epochs);

% Parameter initialization: weights (10), thresholdPA, thresholdSR,
% steepnessPA, steepnessSR

%para_values = [0.9, 0.8, 0.9, 0.9, 0.8, 0.9, 0.9, 1, 0.9, 0.65, 0.3, 0.01, 8, 5];
para_values = [0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.5, 0.01, 0.01, 5, 5];
%para_values = [0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.1, 0.1, 5, 5];
%para_values = [0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.5, 0.5, 5, 5];
%para_values = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.1, 0.1, 6, 5];
latest_pointer = 0;
count = 1;
while (count ~= epochs)
    % Current value of the sum of squared of residuals: SSRnow
    ssr_now = calculate_SSR( para_values, actualFeelData );
    disp(ssr_now);
    error(count) = ssr_now;
    if ssr_now >= ssr_stop
        sensitivity_values = zeros(1,length(para_values));
        for i = 1 : length(para_values)
            sensitivity_values(i) = calculate_param_sensitivity( para_values, i, parameter_step, actualFeelData, ssr_now );
        end
        absolute_sensitivity_values = abs(sensitivity_values);
        highest_pointers = find(absolute_sensitivity_values == max(absolute_sensitivity_values) );
        pointer = highest_pointers(1);
       
        disp(pointer);
        latest_pointer = pointer;
        if sensitivity_values(pointer) >= 0,
            switch pointer
                case {11, 12}
                    para_values(pointer) = max(0, min(0.6, (para_values(pointer) - (0.1* parameter_step))));
                case {13, 14}
                    para_values(pointer) = max(3, min(9, (para_values(pointer) - (0.5* parameter_step))));
                otherwise
                    para_values(pointer) = max(0, min(1, (para_values(pointer) - (0.01* parameter_step))));
            end
        else
            switch pointer
                case {11, 12}
                    para_values(pointer) = max(0, min(0.6, (para_values(pointer) + (0.1* parameter_step))));
                case {13, 14}
                    para_values(pointer) = max(3, min(9, (para_values(pointer) + (0.5* parameter_step))));
                otherwise
                    para_values(pointer) = max(0, min(1, (para_values(pointer) + (0.1* parameter_step))));
            end           
        end
    else
        break,
    end
    count = count + 1;
    
end

x = (1: 1: epochs);
plot(x, error);
xlabel('epochs');
ylabel('SSR');
str = sprintf('WS(s) --> SS(s) = %f , EA(a) --> WS(b) = %f',para_values(1),para_values(2));
str2 = sprintf('WS(b) --> SS(b) = %f , SS(s) --> SR(s) = %f',para_values(3),para_values(4));
str3 = sprintf('SR(s) --> PA(a) = %f , F(b)  --> PA(a) = %f',para_values(5),para_values(6));
str4 = sprintf('SS(b) --> SR(b) = %f , PA(a) --> SR(b) = %f',para_values(7),para_values(8));
str5 = sprintf('SR(b) --> F(b) = %f , PA(a) --> EA(a) = %f',para_values(9),para_values(10));
str6 = sprintf('thr_PA = %f , thr_SR = %f',para_values(11),para_values(12));
str7 = sprintf('ste_PA = %f , steSR = %f',para_values(13),para_values(14));

title({'Plot of Error within update', 'Lowest Error: ',num2str(error(count-1)),'',str,str2,str3,str4,str5,str6,str7});
disp(para_values);