function [L_Best_Fitness, L_Best_Parameters, G_Best_Fitness, G_Best_Parameters  ] = BestParameters_PSO(Current_Fitness, ...
                                                                                    Parameters, L_Best_Fitness, ... 
                                                                                    L_Best_Parameters, G_Best_Fitness, ...
                                                                                    G_Best_Parameters)                                                                            
% Updates the Locally and Globally best fintess values and their parameters 
% 
% The input values are:
% -Current_Fitness: Current fitness for all the members
% -Parameters: Current parameters that have been evaluated
% -L_Best_Fitness: The best (Local) fitness achieved (so far) for each member 
% -L_Best_Parameters: The (Local) parameters that gave the best fitness for each member
% -G_Best_Fitness: The best (Global) fitness achieved (so far) out of all members 
% -G_Best_Parameters: The (Global) parameters that gave the best (Global) fitness
%
% The output values are:
% -L_Best_Fitness:     An updated local fitness for all members
% -L_Best_Parameters:  The parameters that gave the best Local fitness for each member
% -G_Best_Fitness:     An updated global fitness out of all members
% -G_Best_Parameters:  The parameters that gave the best Global fitness for each member

[No_of_Members, No_of_Parameters] = size(Parameters); 

    for i = 1:No_of_Members                                                            
        if Current_Fitness(i) <= L_Best_Fitness(i)
            L_Best_Parameters(i,:) = Parameters(i,:);  % Best (local) Parameters for the members  
            L_Best_Fitness(i) = Current_Fitness(i);    % Best (local) Fintess for the members  
            if L_Best_Fitness(i) <= G_Best_Fitness
                G_Best_Parameters = Parameters(i,:);   % The Best Parameters of all the members
                G_Best_Fitness = L_Best_Fitness(i);    % The Best Fitness of all the members   
            end    
        end      
    end                                                                      

end