# Battery Models

This document describes the battery modelling approaches represented in this repository.

## 1. Rint Model

The Rint model represents a battery using an ideal voltage source and an internal series resistance.

It provides a simple representation of the relationship between open-circuit voltage, current and terminal voltage.

## 2. First-Order RC Equivalent-Circuit Model

The first-order RC model extends the Rint representation by including an additional resistor-capacitor branch.

The RC branch represents transient battery behaviour that cannot be captured by a purely resistive model.

## 3. Second-Order RC Equivalent-Circuit Model

The second-order RC model uses two resistor-capacitor branches to represent multiple dynamic voltage-response characteristics.

It provides a more detailed representation of battery transient behaviour than the first-order model, at the cost of additional parameters.

## 4. Hysteresis Model

The hysteresis model accounts for differences in battery voltage behaviour associated with the battery's operating history.

It is included to explore the effect of hysteresis on terminal-voltage representation.

## 5. Shepherd Model

The Shepherd model is an empirical battery model used to represent the relationship between battery voltage, current and state of charge.

It provides an alternative to equivalent-circuit representations.

## 6. EKF-Based Estimation

An Extended Kalman Filter (EKF) is explored for estimating battery SoC using a first-order battery model.

The approach uses a model-based prediction and measurement correction process.

The corresponding model and estimation scripts are included in the repository. Their accuracy and behaviour should be assessed using the limitations and validation requirements described in `KNOWN_LIMITATIONS.md`.

## 7. Model Comparison

The models differ in complexity, parameter requirements and their ability to represent transient battery behaviour.

| Model | General representation |
|---|---|
| Rint | Ideal voltage source and series resistance |
| First-order RC | One dynamic RC branch |
| Second-order RC | Two dynamic RC branches |
| Hysteresis | Includes voltage hysteresis behaviour |
| Shepherd | Empirical battery representation |
| First-order + EKF | Battery model combined with state estimation |

The presence of a model in this repository does not imply that it has been experimentally validated or optimally parameterised.