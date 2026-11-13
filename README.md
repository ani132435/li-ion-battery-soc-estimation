# Lithium-Ion Battery Modelling and State-of-Charge Estimation

A MATLAB/Simulink-based study of lithium-ion battery modelling, simulation, and State-of-Charge (SoC) estimation techniques.

## Overview

This project explores different mathematical approaches to representing lithium-ion battery behaviour and investigates methods for estimating battery State of Charge.

The work includes equivalent-circuit battery models, simulation workflows, Coulomb Counting, an Extended Kalman Filter (EKF)-based estimation workflow, and a preliminary neural-network workflow.

The project was independently developed, with AI tools used as supporting aids during parts of the development process.

**Project status:** Ongoing academic and experimental work. Model behaviour and estimation workflows are still being validated.

## Objectives

- Explore different lithium-ion battery model structures.
- Implement and simulate battery models using MATLAB and Simulink.
- Study the relationship between battery current, terminal voltage, and SoC.
- Investigate Coulomb Counting and EKF-based SoC estimation.
- Explore neural-network-based estimation using simulation data.
- Identify modelling assumptions, implementation limitations, and areas for improvement.

## Battery Models

The repository includes the following MATLAB/Simulink models:

| Model | Description |
|---|---|
| `Battery_Model_Rint.slx` | Rint equivalent-circuit model |
| `Battery_Model_First_Order.slx` | First-order RC equivalent-circuit model |
| `Battery_Model_Order_first.slx` | Additional first-order model implementation |
| `Battery_Model_Second_Order.slx` | Second-order RC equivalent-circuit model |
| `Battery_model_Hysterisis.slx` | Hysteresis-oriented battery model |
| `Shepherd_Battery_Model.slx` | Shepherd battery model |
| `Battery_Model_First_Order_EKF.slx` | First-order model with an EKF-oriented estimation workflow |

These models provide different levels of representation of battery voltage characteristics and dynamic behaviour. Their parameterization and quantitative accuracy require further validation.

## SoC Estimation Approaches

### 1. Coulomb Counting

Coulomb Counting estimates SoC by integrating battery current over time, based on an initial SoC and assumptions about charge capacity and efficiency.

### 2. Extended Kalman Filter

An EKF-oriented workflow is included alongside the first-order battery model.

The associated analysis script is intended to examine estimated and reference SoC signals and calculate error metrics such as:

- Root Mean Square Error (RMSE)
- Mean Absolute Error (MAE)

The logged signals require time alignment before meaningful comparisons can be made because they are not all recorded at the same sample rate.

### 3. Neural-Network Exploration

The repository also contains a preliminary neural-network data preparation and training workflow.

The saved dataset and trained-network artifact are retained as part of the development work. However, the target variable has not yet been conclusively verified as SoC. The neural-network results should therefore not be interpreted as validated SoC-estimation performance.

## Repository Structure

```text
li-ion-battery-soc-estimation/
│
├── README.md
├── .gitignore
│
├── docs/
│   ├── PROJECT_OVERVIEW.md
│   ├── BATTERY_MODELS.md
│   ├── SIMULATION_GUIDE.md
│   └── KNOWN_LIMITATIONS.md
│
├── models/
│   ├── Battery_Model_Rint.slx
│   ├── Battery_Model_First_Order.slx
│   ├── Battery_Model_Order_first.slx
│   ├── Battery_Model_Second_Order.slx
│   ├── Battery_model_Hysterisis.slx
│   ├── Shepherd_Battery_Model.slx
│   └── Battery_Model_First_Order_EKF.slx
│
├── scripts/
│   ├── simulation/
│   │   ├── FirstAutomation.m
│   │   └── untitled.m
│   │
│   ├── estimation/
│   │   └── run_ekf_metrics.m
│   │
│   └── neural-network/
│       └── prepare_train_nn.m
│
├── data/
│   ├── matlab.mat
│   ├── merged_dataset.mat
│   ├── nn_scaling_settings.mat
│   └── trained_soc_nn.mat
│
└── results/
    └── figures/
```

## Tools and Technologies

- MATLAB
- Simulink
- MATLAB scripting
- Equivalent-circuit battery modelling
- Coulomb Counting
- Extended Kalman Filtering
- Neural-network experimentation

## Getting Started

### Requirements

- MATLAB
- Simulink
- Any additional MATLAB toolboxes required by the individual models

Toolbox requirements may vary depending on the model and blocks used.

### Opening a Model

1. Clone or download this repository.
2. Open MATLAB.
3. Set the MATLAB Current Folder to the repository root.
4. Navigate to the `models/` directory.
5. Open the required `.slx` model.
6. Review its input signals, parameters, initial conditions, and solver settings before running the simulation.

For example, to open the first-order model:

```matlab
modelName = 'Battery_Model_First_Order';

load_system(modelName);
open_system(modelName);
```

### Running the Scripts

The main simulation automation script is:

```text
scripts/simulation/FirstAutomation.m
```

The EKF analysis script is:

```text
scripts/estimation/run_ekf_metrics.m
```

The neural-network data preparation script is:

```text
scripts/neural-network/prepare_train_nn.m
```

**Note:** Some scripts use relative paths and specific working-directory assumptions. Review their data dependencies and output paths before execution. The repository is not yet configured as a fully automated, one-command simulation package.

For further instructions, see the [Simulation Guide](docs/SIMULATION_GUIDE.md).

## Documentation

| Document | Description |
|---|---|
| [Project Overview](docs/PROJECT_OVERVIEW.md) | Project objectives, scope, and contents |
| [Battery Models](docs/BATTERY_MODELS.md) | Overview of the battery model structures |
| [Simulation Guide](docs/SIMULATION_GUIDE.md) | Instructions and notes for working with the models and scripts |
| [Known Limitations](docs/KNOWN_LIMITATIONS.md) | Current issues and future development areas |

## Known Limitations

Some areas that require further investigation include:

- Validation of battery model parameters against experimental data.
- SoC behaviour and operating limits under different simulation conditions.
- Alignment of EKF and reference signals recorded at different sample rates.
- Verification of the neural-network dataset's target variable.
- Prevention of data leakage during neural-network training and evaluation.
- Reproducibility of simulation workflows and script dependencies.

These limitations are documented in greater detail in [KNOWN_LIMITATIONS.md](docs/KNOWN_LIMITATIONS.md).

## Future Work

- Validate equivalent-circuit models against experimental battery measurements.
- Improve SoC estimation and EKF implementation.
- Establish consistent signal logging and comparison time bases.
- Verify and rebuild the neural-network dataset and training workflow.
- Improve simulation automation and reproducibility.
- Document model parameters, assumptions, and evaluation results.

## Repository Status

This repository is a record of an ongoing academic engineering project. It contains developed models, simulation scripts, datasets, and analysis artifacts. The presence of a model or saved result does not imply that it has been experimentally validated.

The work is intended for educational and experimental study, not safety-critical battery control or production battery-management applications.
