# Project Overview

## Lithium-Ion Battery Modelling and State-of-Charge Estimation

### 1. Introduction

This project explores the modelling and simulation of lithium-ion battery behaviour using MATLAB and Simulink. It brings together several battery equivalent-circuit models and preliminary approaches to State-of-Charge (SoC) estimation.

The project was independently developed, with AI tools used as supporting aids during parts of the development and documentation process.

### 2. Objectives

The main objectives are to:

- Study different mathematical representations of lithium-ion battery behaviour.
- Develop and simulate battery models using MATLAB/Simulink.
- Examine the relationship between battery current, terminal voltage, and SoC.
- Explore Coulomb Counting and Extended Kalman Filter (EKF)-based SoC estimation.
- Investigate a neural-network-based approach to battery-related estimation.
- Compare model behaviour and identify areas requiring further validation.

### 3. Repository Contents

| Directory | Contents |
|---|---|
| `models/` | MATLAB/Simulink battery models |
| `scripts/simulation/` | Simulation and automation scripts |
| `scripts/estimation/` | EKF-related analysis and metric scripts |
| `scripts/neural-network/` | Neural-network data preparation workflow |
| `data/` | MATLAB datasets and saved network artifacts |
| `results/figures/` | Simulation and analysis figures |
| `docs/` | Project documentation |

### 4. Models Explored

The repository contains implementations or explorations of:

- Rint equivalent-circuit model
- First-order RC equivalent-circuit model
- Second-order RC equivalent-circuit model
- Hysteresis battery model
- Shepherd battery model
- First-order model with an EKF estimation workflow

These models provide different levels of representation of battery dynamics and terminal-voltage behaviour.

### 5. Estimation Approaches

The project explores three approaches:

**Coulomb Counting:** Estimates SoC by integrating battery current over time, subject to assumptions about initial SoC and charge/discharge efficiency.

**Extended Kalman Filter:** Uses a battery model and measurements to estimate the internal battery state. The repository contains an EKF-oriented Simulink model and an associated analysis script.

**Neural Network:** Includes a preliminary data preparation and training workflow. The saved dataset and target-variable interpretation still require verification before the network can be considered a valid SoC estimator.

### 6. Current Project Status

The repository contains multiple Simulink models, MATLAB scripts, saved datasets, and generated figures. The work represents an ongoing modelling and estimation study rather than a fully validated battery-management system.

Further work is required to validate model parameters, confirm signal definitions, align logged signals in time, and establish reliable estimation performance.

### 7. Tools and Technologies

- MATLAB
- Simulink
- MATLAB scripts
- Battery equivalent-circuit modelling
- Coulomb Counting
- Extended Kalman Filtering
- Preliminary neural-network workflow

### 8. Scope and Disclaimer

This repository is intended for academic and experimental study. The models and estimation workflows should not be treated as production-ready battery-management software or used for safety-critical battery operation without further validation.