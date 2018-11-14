function [Parameters, Parameter_delta ] = initParameters_PSO(No_of_Members, No_of_Parameters, Bounds)
% Initializes the parameters for the members when using Particle Swarm
% Optimization (PSO)
% 
% The input values are:
% -No_of_Members: No. of members (Size of the particle swarm, i.e. number of particles) 
% -No_of_Parameters: No. of parameters (Dimension size)
% -Bounds: Upper (Bounds.Max) and lower (Bounds.Min) on the parameters
%
% The output values are:
% -Parameters:      Set of parameters
% -Parameter_delta: The initial step direction of the parameters

    format long
%% JPHMR - Is this 500 chosen? Is it 50*10, or is the latter just a coincidence    
    No_of_random_sets_to_evaluate = 500; %  No. of sets to evaluate (The function will generate 
                                         %  a number of sets and then choose the set that has the greatest "spread")

    for i =1:No_of_Members
        d(i) = (i-1)/(No_of_Members-1); 
    end
    Parameters = [];
    for i=1:No_of_Parameters
        Parameters = [ Parameters d'*0.9+0.05 ] ;
    end
  
    Minspread = Spread(Parameters);
    for i=1:No_of_random_sets_to_evaluate
        New_Parameters = Shuffle(Parameters);

        Newspread = Spread(New_Parameters);
        if Newspread < Minspread
            Parameters = New_Parameters;
            Minspread = Newspread;
        end    
    end    
    
    for p = 1:No_of_Members
        Parameter_delta(p,1:No_of_Parameters) = 0.01*(2*rand(1,No_of_Parameters)-1);     
    end
    % Parameter_delta bounds (to ensure parameters stays within their normailized bounds, 0-1)
    Parameter_delta = max( Parameter_delta,  -Parameters );
    Parameter_delta = min( Parameter_delta, 1-Parameters );
    
    max_delta = 0.2; % Maximum allowed step-size for Parmeter_delta 
    if norm(Parameter_delta,'fro') >= max_delta
        Parameter_delta = ( Parameter_delta* max_delta/(norm(Parameter_delta,'fro')) );  
    end    

    for p = 1:No_of_Parameters
        Parameters(1:end,p) = Parameters(1:end,p) .*Bounds.Max(p) - ... 
                   Parameters(1:end,p) .* Bounds.Min(p) + Bounds.Min(p); 
    end
   
%% JPHMR - Is the idea to minimize the spread to infer that the distributions are significantly diffirent    
function S = Spread(samples)
    % Function that measures the "spread" of the given samples
    n = length(samples);
    S = 0;
    for k = 1:n
        for j=k+1:n
            S = S+1/norm( samples(k,1:end) - samples(j,1:end), 'fro' );
        end    
    end
end    

function Y = Shuffle(X)
    % Function that randomly shuffles the given samples
    randomIdxsX = randperm(numel(X));
    Y = reshape(X(randomIdxsX),size(X));
end

end


