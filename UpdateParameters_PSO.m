function [ Parameters, Parameter_delta ] = UpdateParameters_PSO( Bounds,G_Best_Parameters,L_Best_Parameters, ...
                                                                 Parameters, Parameter_delta )
% Updates the parameters and step direction for the members 
% when using Particle Swarm Optimization (PSO)
% 
% The input values are:
% -Bounds: Upper (Bounds.Max) and lower (Bounds.Min) on the parameters
% -G_Best_Parameters: The (Globally) best parameters of all the members
% -L_Best_Parameters: The (Locally)  best parameters for each of the members
% -Parameters: The current parameters 
% -Parameter_delta: The current step direction for the parameters
%
% The output values are:
% -Parameters:      An updated set of parameters
% -Parameter_delta: An updated step direction for the parameters                                                             

[No_of_Members, No_of_Parameters] = size(Parameters);                                                                     
w = 0.9;%0.7; % Inertia
C1 = 2.;%1.4; % Cognition Coefficient
C2 = 2.;%1.4; % Social Coefficient

% Scaling parameters within the range 0-1
for p = 1:No_of_Parameters
    Scaled_Parameters(:,p)        = ( Parameters(:,p) - Bounds.Min(p) ) / ( Bounds.Max(p) - Bounds.Min(p) );  
    Scaled_G_Best_Parameters(:,p) = ( G_Best_Parameters(:,p) - Bounds.Min(p) ) / ( Bounds.Max(p) - Bounds.Min(p) ); 
    Scaled_L_Best_Parameters(:,p) = ( L_Best_Parameters(:,p) - Bounds.Min(p) ) / ( Bounds.Max(p) - Bounds.Min(p) ); 
end

for p = 1:No_of_Members
    r1 = rand(1,No_of_Parameters); 
    r2 = rand(1,No_of_Parameters);    
    % Update Parameter delta
    Parameter_delta(p,:) = w * Parameter_delta(p,:) + C1 * r1 .* (Scaled_L_Best_Parameters(p,:) - Scaled_Parameters(p,:) ) ... 
                                                    + C2 * r2 .* (Scaled_G_Best_Parameters      - Scaled_Parameters(p,:) );
    
    % Parameter_delta bounds (to ensure parameters stays within their scaled bounds, 0-1)
    Parameter_delta(p,:) = max(Parameter_delta(p,:),  -Scaled_Parameters(p,:) );
    Parameter_delta(p,:) = min(Parameter_delta(p,:), 1-Scaled_Parameters(p,:) );
    
    max_delta = 0.2; % Maximum allowed step-size for Parmeter_delta 
    if norm(Parameter_delta,'fro') >= max_delta
        Parameter_delta = ( Parameter_delta* max_delta/(norm(Parameter_delta,'fro')) );  
    end       

    % Update Parameters
    Scaled_Parameters(p,:) = Scaled_Parameters(p,:) + Parameter_delta(p,:);
end

    % Unscale Parameters
    for k = 1:No_of_Parameters
        Parameters(1:end,k) = Scaled_Parameters(1:end,k) .*Bounds.Max(k) - ... 
               Scaled_Parameters(1:end,k) .* Bounds.Min(k) + Bounds.Min(k); 
    end    

end