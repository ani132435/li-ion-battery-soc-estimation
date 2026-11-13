% --- Script to Run Simulation with Signal Logging and Analyze EKF vs CC ---
clear; clc; close all; format compact;

fprintf('Starting Simulation and Analysis using Signal Logging...\n');

% --- Configuration ---
% <<< EDIT THESE >>>
model_name = 'Battery_Model_First_Order_EKF'; % Your Simulink model filename (without .slx)
stop_time = 500; % Simulation stop time (seconds)

% Signal Logging Names (MUST EXACTLY MATCH names set in Simulink Wire Properties->Logging)
voltage_log_name = 'LoggedVoltage';
current_log_name = 'LoggedCurrent';
true_soc_log_name= 'LoggedTrueSoC'; % Output of the basic CC Integrator (Reference)
cc_soc_log_name  = 'LoggedCCSoC';   % <<< NEW: Explicitly logged CC SoC signal
ekf_soc_log_name = 'LoggedEKFSoC';  % Output of the EKF MATLAB Function block
% temp_log_name    = 'LoggedTemp';    % Uncomment if you logged temperature

% Battery Parameters (MUST match those used in the EKF function/Simulink model)
Q = 3600;      % Total capacity in Coulombs (1 Ah)
eta = 0.995;   % Coulombic efficiency

% --- Simulation Setup ---
% (Keep commented out unless needed)
% fprintf('Setting simulation parameters...\n');
% load_system(model_name);
% set_param(...)
% save_system(model_name);
% close_system(model_name, 0);

fprintf('Running simulation: %s for %d seconds...\n', model_name, stop_time);

% --- Run Simulation using sim() with Signal Logging ---
try
    simOut = sim(model_name, 'StopTime', num2str(stop_time), ...
                 'SaveOutput', 'on', 'OutputSaveName', 'simLogs', ...
                 'SignalLogging', 'on', 'SignalLoggingName', 'logsout');

    fprintf('Simulation complete. Processing logged data...\n');

    % --- Extract Logged Data ---
    if ~exist('simOut', 'var') || ~isfield(simOut, 'logsout') || isempty(simOut.logsout)
         error('CRITICAL ERROR: Simulation ran, but NO signal logging data (logsout) was found in simOut. PLEASE RE-CHECK SIGNAL LOGGING SETUP IN SIMULINK MODEL (Right-click wire -> Properties -> Logging -> Check "Log signal data" -> SAVE MODEL).');
    end

    logsout = simOut.logsout;
    fprintf('logsout dataset found. Attempting to extract signals...\n');

    % Access individual signals by name using getElement
    try
        voltage_ts = logsout.getElement(voltage_log_name);
        current_ts = logsout.getElement(current_log_name);
        soc_true_ts= logsout.getElement(true_soc_log_name); % Reference
        soc_cc_ts  = logsout.getElement(cc_soc_log_name);   % <<< NEW: Get logged CC signal
        soc_ekf_ts = logsout.getElement(ekf_soc_log_name);
        % temp_ts    = logsout.getElement(temp_log_name); % Uncomment if logged
        fprintf('Successfully extracted signals by name.\n');
    catch ME
         error('Failed to extract logged signals using getElement with specified names. Error: %s\n*** ACTION REQUIRED: Check the names you entered in Simulink Wire Properties -> Logging -> Name MATCH EXACTLY (case-sensitive!) the *_log_name variables in this script. ***', ME.message);
    end

    % Extract numerical data and time vector
    time_vector = soc_true_ts.Time; % Use one signal's time vector as reference
    voltage     = voltage_ts.Data;
    current     = current_ts.Data;
    soc_true    = soc_true_ts.Data; % Ground truth reference
    soc_cc      = soc_cc_ts.Data;   % <<< NEW: Use the directly logged CC data
    soc_ekf     = soc_ekf_ts.Data;  % EKF estimate
    % temp        = temp_ts.Data;   % Uncomment if logged

    % --- Data Sanity Check ---
    if isempty(time_vector) || isempty(voltage) || isempty(current) || isempty(soc_true) || isempty(soc_cc) || isempty(soc_ekf)
        error('One or more extracted data vectors are empty. Logging might have failed partially.');
    end
    fprintf('Logged data vectors extracted successfully (%d points).\n', length(time_vector));

    % --- Calculate Errors ---
    fprintf('Calculating estimation errors...\n');
    error_cc = soc_true - soc_cc;   % Calculate error vs reference
    error_ekf = soc_true - soc_ekf; % Calculate error vs reference

    valid_idx = ~isnan(error_ekf) & ~isnan(error_cc) & ~isnan(soc_true);
    time_valid = time_vector(valid_idx);
    error_cc_valid = error_cc(valid_idx);
    error_ekf_valid = error_ekf(valid_idx);
    soc_true_valid = soc_true(valid_idx);
    soc_ekf_valid = soc_ekf(valid_idx);
    soc_cc_valid = soc_cc(valid_idx); % Use logged CC for plotting

    if isempty(time_valid)
       error('No valid (non-NaN) data points found after error calculation.');
    end

    % --- Calculate Metrics (RMSE & MAE) ---
    fprintf('Calculating performance metrics...\n');
    rmse_cc = sqrt(mean(error_cc_valid.^2));
    rmse_ekf = sqrt(mean(error_ekf_valid.^2));
    mae_cc = mean(abs(error_cc_valid));
    mae_ekf = mean(abs(error_ekf_valid));

    % --- Display Results ---
    fprintf('\n--- SoC Estimation Performance Metrics ---\n');
    fprintf('Method           | RMSE (%% SoC) | MAE (%% SoC)\n');
    fprintf('-----------------|---------------|--------------\n');
    fprintf('Coulomb Counting | %13.4f | %12.4f\n', rmse_cc * 100, mae_cc * 100);
    fprintf('EKF              | %13.4f | %12.4f\n', rmse_ekf * 100, mae_ekf * 100);
    fprintf('------------------------------------------------\n');

    % --- Generate Plots ---
    fprintf('Generating comparison plots...\n');

    % Plot 1: SoC Comparison (Figure for Report Fig 3.9)
    figure('Name', 'SoC Estimation Comparison');
    plot(time_valid, soc_true_valid, 'k-', 'LineWidth', 2); hold on;
    plot(time_valid, soc_ekf_valid, 'b--', 'LineWidth', 1.5);
    plot(time_valid, soc_cc_valid, 'r:', 'LineWidth', 1.5); % Now plots the logged CC signal
    hold off;
    title('SoC Estimation Comparison (EKF vs CC)');
    xlabel('Time (s)'); ylabel('State of Charge (SoC)');
    legend('True SoC (Simulated Ref)', 'EKF Estimate', 'Coulomb Counting Estimate', 'Location', 'best'); % Updated Legend
    grid on;
    ylim_soc = [min(soc_true_valid)-0.05, max(soc_true_valid)+0.05];
    ylim([max(0, ylim_soc(1)), min(1, ylim_soc(2))]);

    % Plot 2: Error Comparison (Figure for Report Fig 3.10)
    figure('Name', 'SoC Estimation Error');
    plot(time_valid, error_ekf_valid * 100, 'b-', 'LineWidth', 1.5); hold on;
    plot(time_valid, error_cc_valid * 100, 'r-', 'LineWidth', 1.5); % Now plots the error of logged CC vs True
    yline(0,'k--');
    hold off;
    title('SoC Estimation Error Comparison (EKF vs CC)');
    xlabel('Time (s)'); ylabel('SoC Error (%)');
    legend('EKF Error', 'Coulomb Counting Error', 'Location', 'best'); % Updated Legend
    grid on;

    % Optional Plot 3: Voltage and Current (Context for Report Figs 3.7 & 3.8)
    figure('Name', 'Voltage and Current Profiles');
    subplot(2,1,1); plot(time_vector, voltage, 'm-');
    title('Terminal Voltage Response'); xlabel('Time (s)'); ylabel('Voltage (V)'); grid on;
    subplot(2,1,2); plot(time_vector, current, 'g-');
    title('Input Current Profile'); xlabel('Time (s)'); ylabel('Current (A)'); grid on;

    fprintf('\nAnalysis complete.\n');

catch ME % Catch errors during simulation or analysis
    fprintf('\n--- SCRIPT FAILED ---\n');
    fprintf('Error message: %s\n', ME.message);
    if ~isempty(ME.stack)
        fprintf('Error occurred in function %s, line %d\n', ME.stack(1).name, ME.stack(1).line);
    end
    fprintf('Check Simulink model setup, signal logging configuration/names, paths, or script logic.\n');
    % Uncomment to display detailed error report
    % disp(getReport(ME, 'extended'));
end