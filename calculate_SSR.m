%          SSR                               Assignment Week 6
%          Sander Martijn Kerkdijk               Max Turpijn
%          Course: Behaviour Dynamics in social Networks 
%               Vrije Universiteit Amsterdam 2015
%                    Copying will be punished


function ssr = calculate_SSR( para_values, actualFeelData )
cuurentFeelData = model_compilation(para_values);
residuals =  cuurentFeelData - actualFeelData;
ssr = sum(residuals(:).^2);
end