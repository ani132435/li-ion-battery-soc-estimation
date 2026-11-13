# Simulation Guide

## 1. Requirements

The project uses MATLAB and Simulink.

Required toolboxes and products depend on the specific model and blocks used. Open the models in MATLAB to identify any missing dependencies.

## 2. Repository Structure

The main working directories are:

- `models/` — Simulink models.
- `scripts/simulation/` — simulation automation scripts.
- `scripts/estimation/` — estimation analysis scripts.
- `scripts/neural-network/` — neural-network data preparation.
- `data/` — saved MATLAB data and network artifacts.
- `results/figures/` — generated figures.

## 3. Opening a Simulink Model

1. Open MATLAB.
2. Set the MATLAB Current Folder to the repository root.
3. Navigate to the `models/` directory.
4. Open the required `.slx` file.
5. Review the model parameters, input signals, initial conditions, and solver configuration.
6. Run the simulation.

For example, to open the first-order model:

```matlab
modelName = 'Battery_Model_First_Order';

load_system(modelName);
open_system(modelName);
```

The model must be accessible from the MATLAB path or current directory.

## 4. Running the Simulation Automation Script

The main automation script is:

```text
scripts/simulation/FirstAutomation.m
```

This script explores multiple combinations of operating temperatures, initial SoC values, and current profiles.

Before running it:

1. Inspect the script and confirm its input data dependencies.
2. Check the output directory paths.
3. Confirm that the required Simulink models and supporting files are available.
4. Run the script from the working directory expected by the script.

The script uses relative paths, so the working directory matters. Before running the script, check your current folder in MATLAB using `pwd`, and set it to the expected directory with `cd('path/to/working/directory')` if needed. Do not assume that running it from the repository root will work without checking its path handling.

## 5. EKF Analysis

The EKF analysis script is located at:

```text
scripts/estimation/run_ekf_metrics.m
```

The script is intended to run the EKF-oriented model, collect simulation signals, and calculate estimation error metrics such as:

- Root Mean Square Error (RMSE)
- Mean Absolute Error (MAE)

Before relying on its output, verify that:

- The referenced model name is correct.
- The logged signals are available.
- The reference and estimated SoC signals use compatible time bases.
- Missing or invalid values are handled correctly.

Signals logged at different sample rates must be aligned by their timestamps before calculating error metrics.

## 6. Neural-Network Data Preparation

The neural-network preparation script is located at:

```text
scripts/neural-network/prepare_train_nn.m
```

The repository also contains saved MATLAB datasets and a trained-network artifact.

The current workflow should be treated as preliminary. Before interpreting the network as an SoC estimator, verify:

1. The meaning of every input variable.
2. The meaning and units of the target variable.
3. That the target actually represents SoC.
4. That input variables are normalized or scaled appropriately, and that the same normalization is applied during inference.
5. That training, validation, and test data are separated without data leakage.
6. That the evaluation uses data not seen during training.

The saved network should not be considered a validated SoC estimator until these checks are complete.

## 7. Results

Existing figures are stored under:

```text
results/figures/
```

These figures are provided as records of the project's analysis and simulation work. Their interpretation should be tied to the corresponding model, input conditions, and simulation configuration.

## 8. Reproducibility Notes

For reproducible results:

- Record the MATLAB release and relevant toolbox versions.
- Record model parameters and initial conditions.
- Use consistent current profiles and simulation durations.
- Keep track of the working directory and data dependencies.
- Save simulation settings alongside generated results.
- Document any modifications to the models or scripts.
Some workflows may require path corrections or additional validation before they can be executed directly from a fresh clone of the repository.

For example, if a script fails to find a required file, check that your MATLAB current folder matches the script's expected working directory, or update any hardcoded paths in the script.

If you encounter issues after cloning, see the [Troubleshooting](#troubleshooting) section below for common solutions.
Some workflows may require path corrections or additional validation before they can be executed directly from a fresh clone of the repository.
