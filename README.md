# Li-Ion Battery Modelling and State-of-Charge Estimation

A MATLAB/Simulink-based project exploring lithium-ion battery equivalent-circuit modelling and battery State-of-Charge (SoC) estimation.

## Project Overview

Accurate SoC estimation is an important function of a Battery Management System (BMS). This project investigates battery modelling and estimation methods through simulation, MATLAB scripting and data analysis.

The repository contains multiple battery model structures, simulation scripts, data artifacts and preliminary estimation workflows.

## Objectives

- Study different lithium-ion battery equivalent-circuit models.
- Examine battery current, terminal voltage and SoC behaviour.
- Explore Coulomb Counting and Extended Kalman Filter (EKF) approaches.
- Investigate data-driven SoC estimation using neural networks.
- Evaluate estimation performance under different operating conditions.

## Battery Models

The repository includes MATLAB/Simulink models for:

- Rint battery model
- First-order RC equivalent-circuit model
- Second-order RC equivalent-circuit model
- Hysteresis battery model
- Shepherd battery model
- First-order model configured for EKF-based estimation

## Estimation Methods

### Coulomb Counting

A current-integration approach for tracking changes in battery SoC.

### Extended Kalman Filter

A model-based estimation workflow using a first-order battery model. Its implementation and performance are undergoing review.

### Neural Network

An initial feedforward neural network and its associated training artifacts are included.

**Important:** An audit of the archived neural-network dataset found that its target contains exactly three values: 0, 25 and 40. These match the temperature conditions in the original simulation script. The target signal and input-column ordering must therefore be verified before this network can be considered a valid SoC estimator. The original artifacts are retained for reference and are not presented as validated results.

## Repository Structure

``` text
li-ion-battery-soc-estimation/
|-- data/
|-- models/
|-- results/
|   |-- figures/
|-- scripts/
|   |-- estimation/
|   |-- neural-network/
|   |-- simulation/
|-- .gitignore
|-- README.md

```
## Tools and Technologies
- MATLAB
- Simulink
- Battery equivalent-circuit modelling
- MATLAB scripting and data analysis
- Neural Network Toolbox
Current Status
The repository contains battery simulation models, MATLAB scripts, archived data and selected figures.

The simulation and estimation workflows are undergoing code review and reproducibility checks. Signal definitions, dataset generation, estimator implementations and evaluation procedures will be verified before validated results are reported.
Planned Work
- Verify the signal definitions and output ordering in the Simulink models.
- Standardise simulation data generation and storage paths.
- Correct and document the neural-network data-preparation workflow.
- Separate training, validation and test data by simulation run.
- Review and validate the EKF implementation.
- Compare estimation methods using metrics such as RMSE and MAE.
- Document execution instructions, assumptions and limitations.

## Documentation

- [Project Overview](docs/PROJECT_OVERVIEW.md)
- [Battery Models](docs/BATTERY_MODELS.md)
- [Simulation Guide](docs/SIMULATION_GUIDE.md)
- [Known Limitations and Future Work](docs/KNOWN_LIMITATIONS.md)

Note
This is an academic engineering project for studying battery modelling and SoC estimation. The models and methods require independent validation before any real-world BMS application.
