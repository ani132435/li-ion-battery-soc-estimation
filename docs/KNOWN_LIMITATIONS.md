# Known Limitations and Future Work

## 1. Overview

This repository documents an ongoing study of lithium-ion battery modelling and SoC estimation. The models and scripts are useful for exploration, but several aspects require additional verification before the results can be treated as validated.

## 2. Battery Model Validation

The repository contains multiple battery model structures, but the presence of a working simulation does not establish that the model accurately represents a physical battery.

Further work is required to:

- Verify the parameter values used in each model.
- Establish the source and validity of OCV and resistance data.
- Compare simulated terminal voltage against experimental measurements.
- Evaluate model performance under different current profiles.
- Check the effect of initial conditions and solver settings.

## 3. SoC Behaviour

The first-order model's logged reference SoC has been observed to fall below zero under the default simulation conditions.

This indicates that the model's operating limits and SoC update logic require further examination.

The value should not be silently clipped to zero merely to make the output appear physically plausible. The underlying cause should be identified and documented.

## 4. EKF Signal Logging

The EKF-oriented simulation logs signals at different sample rates.

In the inspected simulation:

- EKF SoC was logged at approximately 1 Hz.
- Reference SoC, current, and voltage were logged at approximately 100 Hz.

These signals cannot be compared sample-by-sample without first aligning their timestamps.

Future work should establish a consistent comparison time base and verify the EKF implementation, noise assumptions, model parameters, and initial covariance settings.

## 5. Neural-Network Workflow

The current neural-network dataset and training workflow require significant verification.

The saved target variable contains only three unique values: 0, 25, and 40. These values appear consistent with the temperature conditions used in the simulation workflow rather than a continuous SoC target.

This raises the possibility that the network was trained to predict temperature instead of SoC.

The input-variable definitions and target-variable meaning must therefore be verified before interpreting the saved network as an SoC estimator.

Additional concerns include:

- The data preparation script's expected file locations may not match the automation script's output directories.
- Data scaling is performed before the train/validation/test split in the existing workflow.
- Randomly splitting individual samples may place samples from the same simulation run in multiple subsets.
- The saved network's performance metrics do not independently establish SoC-estimation accuracy.

The neural-network workflow should be rebuilt and evaluated after the dataset structure and target variable are confirmed.

## 6. Script and Reproducibility Limitations

Some scripts depend on specific working directories, model names, or block paths.

A fresh user may need to review these dependencies before running the scripts.

The repository should not yet be considered a fully automated, one-command simulation package.

## 7. Future Work

Potential next steps include:

1. Validate the equivalent-circuit models against experimental battery data.
2. Verify the current and SoC sign conventions.
3. Correct and document the SoC operating limits.
4. Align EKF and reference signals using timestamps.
5. Revisit EKF noise covariance and parameter selection.
6. Rebuild the neural-network dataset with verified labels.
7. Split training and evaluation data by simulation run or operating condition.
8. Add reproducible scripts for generating figures and metrics.
9. Record software versions and model configurations.

## 8. Disclaimer

The repository is intended for educational and experimental purposes. Its models, datasets, and estimation workflows should not be used for safety-critical battery control or commercial battery-management applications without independent validation.