# Battery Models

## Overview

This project explores several mathematical models used to represent lithium-ion battery behaviour. The models differ in complexity and in how they represent internal resistance, transient response, polarization, and voltage characteristics.

The implementations are available in the `models/` directory.

## 1. Rint Model

The Rint model is a basic equivalent-circuit representation of a battery.

It consists of an ideal voltage source representing the open-circuit voltage (OCV), in series with an internal resistance.

A simplified terminal-voltage relationship is:

\[
V_t = OCV(SoC) - I R_0
\]

where:

- \(V_t\) is terminal voltage.
- \(OCV(SoC)\) is the open-circuit voltage as a function of SoC.
- \(I\) is battery current, using the discharge-positive convention.
- \(R_0\) is the internal resistance.

The model is computationally simple but does not explicitly represent transient polarization dynamics.

## 2. First-Order RC Model

The first-order RC model extends the Rint model by adding an RC network to represent transient battery behaviour.

The model includes:

- An open-circuit voltage source.
- An ohmic resistance.
- One resistor-capacitor polarization branch.

The polarization branch introduces a dynamic voltage response rather than representing the battery using only an instantaneous resistive drop.

A common state equation for the polarization voltage is:

\[
\frac{dV_1}{dt}
=
-\frac{V_1}{R_1C_1}
+
\frac{I}{C_1}
\]

For a discharge-positive current convention, the terminal voltage can be represented as:

\[
V_t = OCV(SoC)-IR_0-V_1
\]

The exact implementation and signal conventions should be checked against the corresponding Simulink model.

## 3. Second-Order RC Model

The second-order RC model uses two polarization branches to represent battery dynamics at different time scales.

It can provide a more detailed approximation of transient voltage behaviour than the first-order model, at the cost of additional states and parameters.

A typical terminal-voltage representation is:

\[
V_t = OCV(SoC)-IR_0-V_1-V_2
\]

where \(V_1\) and \(V_2\) are the polarization voltages associated with the two RC branches.

## 4. Hysteresis Model

The repository includes a hysteresis-oriented battery model.

Hysteresis represents the dependence of battery voltage on its previous operating history. In practical terms, the voltage response during charging may differ from the response during discharging at the same SoC.

The model is included for exploration of this additional battery characteristic. Its parameterization and behaviour should be evaluated against the corresponding Simulink implementation.

## 5. Shepherd Model

The Shepherd model is another battery representation included in the repository.

It uses an empirical mathematical relationship to describe battery terminal voltage as a function of current, discharged capacity, and model parameters.

It is useful for exploring battery voltage behaviour under different operating conditions, although its accuracy depends on parameter identification and the range of conditions for which it is used.

## 6. Model Comparison

| Model | Main representation | Relative complexity |
|---|---|---|
| Rint | OCV and internal resistance | Low |
| First-order RC | OCV, resistance, one RC branch | Moderate |
| Second-order RC | OCV, resistance, two RC branches | Higher |
| Hysteresis | Voltage-history effects | Implementation-dependent |
| Shepherd | Empirical battery-voltage relationship | Implementation-dependent |

## 7. Important Notes

- Model equations above describe common formulations; the exact block-level implementation may differ.
- Parameter values must be checked before making quantitative comparisons.
- The models should be evaluated under consistent initial conditions and current profiles.
- A model that produces a plausible voltage response is not automatically validated against a real battery.
- Further work should include parameter identification and comparison against experimental battery data.