This code has dependency upon software knitro.
http://www.artelys.com/en/optimization-tools/knitro
It is recommended not to use MCMC sampling in the first runs and simply try the knitro opimitizer for learning the parameters.

Look into runMain.m file and also the manual pdf file.

This code is an extension of the code used in the following published papers. The extensions are unpublished. For obtaining the version of the code that was used in the AAAI12 paper, one can try some specific parameters. I had revised this code about 3 years back, and then added MCMC algorithm case in 2014. Here are two quick ways of reducing computational cost to see preliminary results. First, set "options.numRuns = 1" (instead of 5) in the runMain.m file. You may also consider reducing "numTestSims". Second, try not using MCMC in the beginning. I don't remember if MCMC was working properly and if it need some tuning. There are standard matlab optimization functions (like using knitro interface or a standard Matlab optimizer) beings used in the code. Please look into file related to learning of the model and accordingly set the appropriate "optimization" (MCMC should be computationally more expensive but more accurate). Also, you can consider changing "trnSamplesRatio" and "lisalOptions.c". 

You can consider changing "CovStr.NGP". The provided code implements almost all Non-stationary GP models there exist. PCLSK (the one used in AAAI paper) is computationally more expensive because of more hyper-parameters (3 latent GPs are involved). Whereas models like Heteroscedastic GP has only one latent GP and hence takes less computational time to learn. Performance of these NGP models vary across datasets. So, I would suggest trying all NGPs starting with HGP, LEIS, BWGP etc (what these abbreviations refer to is in the documentation). Also, if you don't get good performance, you can consider increasing "lisalOptions.m1" (while you may decrease "lisalOptions.m2" to compensate for the computational cost). lisalOptions.m2=0 should correspond to AAAI case if the CovStr.NGP is PCLSK. Though, replicating exact results would be difficult because of the code configurations and the above mentioned implementation after 2012. 

Published Papers
Garg, Sahil, Amarjeet Singh, and Fabio Ramos. "Learning Non-Stationary Space-Time Models for Environmental Monitoring." Twenty-Sixth AAAI Conference on Artificial Intelligence. 2012.

Garg, Sahil, Amarjeet Singh, and Fabio Ramos. "Efficient space-time modeling for informative sensing." Proceedings of the Sixth International Workshop on Knowledge Discovery from Sensor Data. ACM, 2012.

Note: if the above code is useful, it is recommended to cite the above published papers.

Feel free to contact me.

Sahil Garg
sahilgar@usc.edu
www-scf.usc.edu/~sahilgar/
 
