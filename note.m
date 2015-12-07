%This code implement algorithm LISAL for efficient learning of an NGP. 
%Algorithm LISAL is proposed in paper 'Most Likely Bayesian Nonstationary Models: Efficient Algorithms and Empirical Studies'.
%
%See script runMain that runs the function main with different
%parameterizations for learning and testing a nonstationary GP model.
%
%function main() is the function that performs all of the functionalities starting from data loading, parameters initialization, learning of parameters, test of model.
%
%function getData() obtains the data as per a given data source name.
%
%function initGPCov() initializes the hyperparameters of GP model as per given covariance structure specification using training data samples. 
%
%function lrnGPCov() learns the hyperparameters of GP model using the
%initialized hyperparameters with algorithm LISAL. This function can also
%be used for learning hyperparameters of a stationary GP model.
%
%function evalCov() evaluates covariance between two sets of input
%locations using a structure of hyperparameters with fields {'GPy', 'GPz'}.
%This function also evaluates stationary covariance. For stationary
%covariance case, there exists only field 'GPy'.
%
%For understanding of the code, it is advised to start from runMain or Main
%file. It is also advised to read the paper mentioned above for conceptual
%understanding and the short code manual (part of code
%repository) before going through the code documentation and logic.
%
