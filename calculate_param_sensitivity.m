function sensitivity = calculate_param_sensitivity( para_values, index, parameter_step, actualFeelData, ssr_now )
switch index
    case {11, 12}
        para_values(index) = max(0, min(0.6, (para_values(index) + parameter_step)));
    case {13, 14}
        para_values(index) = max(3, min(9, (para_values(index) + parameter_step)));
    otherwise
        para_values(index) = max(0, min(1, (para_values(index) + parameter_step)));
end
ssr = calculate_SSR( para_values, actualFeelData );
 
sensitivity = (ssr - ssr_now) / parameter_step;
end