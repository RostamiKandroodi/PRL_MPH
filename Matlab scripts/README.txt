The  'Main_' scripts generate the results of the paper.
The rest of the scripts will be called inside the Main scripts. 

--------------------------------------------------------------------------------------------------------------------------
# Model fitting for base madels:
The Main_Fit_BaseModels script calls the following scripts for each model and fits the parameters to subjects' behaviour.

Model name     | Wrapper function             | Core function   
---------------|------------------------------|---------------
1) EWA:        | SimSamodel_EWA               | EWA_model
2) EWA+F:      | SimSamodel_EWA_F             | EWA_F_model
3) Hybrid:     | SimSamodel_Hybrid            | Hybrid_model
4) Hybrid+F:   | SimSamodel_Hybrid_F          | Hybrid_F_model

--------------------------------------------------------------------------------------------------------------------------
# Model fitting for MPH madels:
The Main_Fit_MPHModels script calls the following scripts for each model and fits the parameters to subjects' behaviour.

Model name                | Wrapper function           | Core function
--------------------------|----------------------------|----------------
1)EWA+F_Delta_Rho:        | Simmodel_EWA_F1	       | EWA_F_model
2)EWA+F_Delta_Phi:	  | Simmodel_EWA_F2	       | EWA_F_model
3)EWA+F_Delta_AlphaF:     | Simmodel_EWA_F3	       | EWA_F_model
4)EWA+F_Delta_Beta:       | Simmodel_EWA_F4	       | EWA_F_model


--------------------------------------------------------------------------------------------------------------------------
# Simulation of winning model:
The Main_PRL3Simulation generates the simulation data for the Model validation section. 

--------------------------------------------------------------------------------------------------------------------------
# Regenerate the Figures:
Main_FinalFigures
and 
Main_SimulationFigures

--------------------------------------------------------------------------------------------------------------------------
# Simulation of optimal performance:
3-option task: Main_PRL3SimulationOptimal
2-option task: Main_PRL2SimulationOptimal

--------------------------------------------------------------------------------------------------------------------------