% lisalOptions is a structure with fields { 'm1', 'm2', 'c', 'infCriterion'
% , 'isExli', 'exliRatio' }
% 
% m1 - number of latent locations learned in the preliminary selection
% under LISAL by maximizing information on real dynamics instead of latent 
% dynamics.
% 
% m2- number of latent locations learned in each adaptive iteration of
% LISAL that are learned by maximization of information on latent dynamics.
% 
% c- number of adaptive iterations in LISAL. Each adaptive iteration learn
% a set of informative latent locations and then learns latent
% parameterization across the learned latent locations by maximizing
% marginal likelihood of real observed dynamics.
% 
% infCriterion- criterion to evaluate information on latent or real 
% dynamics. Valid options forthe field are : { 'E', 'MI' }. E represents 
% entropy and MI represents mutual information.
% 
% Also see documentation on lisal.