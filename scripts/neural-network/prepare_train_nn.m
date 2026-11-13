% --- Script for Preparing Data and Training SoC Estimation NN (Corrected Attempt) ---
clear; clc; close all; format compact; rng(42); % reproducibility

fprintf('Starting NN Data Preparation and Training...\n');

% --- Configuration ---
dataFolder = pwd; % assumes .mat files are in current folder
filePattern = 'Data_T*.mat'; % pattern matching simulation output files
outputNetFile = 'trained_soc_nn.mat'; % name for trained network
scalingFile = 'nn_scaling_settings.mat'; % name for scaling settings file

% --- 1. Load Simulation Data ---
fprintf('Loading simulation data files...\n');
matFiles = dir(fullfile(dataFolder, filePattern));
if isempty(matFiles)
    error('No data files found matching pattern "%s" in folder %s. Make sure files are generated and you excluded test files.', filePattern, dataFolder);
end

% Initialize arrays
all_V = [];
all_I = [];
all_T = [];
all_SoC = [];

for k = 1:length(matFiles)
    fileName = fullfile(dataFolder, matFiles(k).name);
    fprintf('  Loading %s...\n', matFiles(k).name);
    loadedData = load(fileName);

    % --- Check for variable name ---
    if isfield(loadedData, 'run_data')
        simData = loadedData.run_data;
    else
        varName = fields(loadedData);
        simData = loadedData.(varName{1});
    end

    %% --- Extract timeseries data ---
    if isa(simData, 'timeseries')
        data = simData.Data;
        time = simData.Time; % Also get time vector
    elseif isstruct(simData)
        if isfield(simData, 'signals') && isfield(simData.signals, 'values') && isfield(simData,'time')
            data = simData.signals.values;
            time = simData.time;
        else
            warning('Skipping file %s: unrecognized struct format.', matFiles(k).name);
            continue;
        end
    else
        warning('Skipping file %s: unsupported data type.', matFiles(k).name);
        continue;
    end

    % --- Check and extract columns (assuming order: V, I, SoC, T) ---
    if size(data, 2) < 4
        warning('Skipping %s: not enough columns (expected 4).', matFiles(k).name);
        continue;
    end

    % --- Data Sanity Check - Remove NaN or Inf if any ---
    if any(isinf(data(:))) || any(isnan(data(:)))
       warning('NaN or Inf found in %s. Attempting to clean.', matFiles(k).name);
       data(any(isnan(data),2) | any(isinf(data),2), :) = []; % Remove rows with NaN/Inf
       if isempty(data)
           warning('Skipping %s after cleaning resulted in empty data.', matFiles(k).name);
           continue;
       end
    end

    % Optional: verify visually on first file
    if k == 1
        figure;
        plot(time, data(:,1:4)); % Use time vector for plotting
        legend('Voltage','Current','SoC','Temp');
        title('Data Check for First File');
        xlabel('Time (s)');
    end

    all_V   = [all_V; data(:,1)];
    all_I   = [all_I; data(:,2)];
    all_SoC = [all_SoC; data(:,3)];
    all_T   = [all_T; data(:,4)];
end

if isempty(all_SoC)
    error('No valid data loaded. Check .mat files and signal order.');
end

%% --- 2. Create Combined Dataset ---
Inputs  = [all_V, all_I, all_T];  % Features: Voltage, Current, Temperature
Targets = all_SoC;                % Target: State of Charge
fprintf('Loaded %d data points.\n', size(Inputs, 1));

% Optional: save merged dataset
% save('merged_dataset.mat', 'Inputs', 'Targets');

%% --- 3. Shuffle Data ---
fprintf('Shuffling data...\n');
numSamples = size(Inputs, 1);
idx = randperm(numSamples);
shuffled_Inputs  = Inputs(idx, :);
shuffled_Targets = Targets(idx, :);

%% --- 4. Normalize / Scale Data ---
fprintf('Scaling data...\n');
% Scale inputs (V, I, T) to [-1, 1]
% Scale targets (SoC) also to [-1, 1] (helps prevent saturation)
[scaledInputs, settings_in]  = mapminmax(shuffled_Inputs');  % features x samples
[scaledTargets, settings_out] = mapminmax(shuffled_Targets'); % 1 x samples

% --- Verification Step: Check Scaled Data Range ---
fprintf('Min/Max Scaled Inputs: [%.2f, %.2f]\n', min(scaledInputs(:)), max(scaledInputs(:)));
fprintf('Min/Max Scaled Targets: [%.2f, %.2f]\n', min(scaledTargets(:)), max(scaledTargets(:)));
if any(isinf(scaledInputs(:))) || any(isnan(scaledInputs(:))) || any(isinf(scaledTargets(:))) || any(isnan(scaledTargets(:)))
   error('NaN or Inf detected AFTER scaling. Check original data for extreme values or errors.');
end
% --- End Verification ---

save(scalingFile, 'settings_in', 'settings_out');
fprintf('Scaling settings saved to %s.\n', scalingFile);

%% --- 5. Define and Configure Neural Network ---
fprintf('Defining network architecture...\n');
hiddenLayerSize = [20 15]; % two hidden layers
net = feedforwardnet(hiddenLayerSize);

% Training data division (train/val/test)
net.divideParam.trainRatio = 0.70;
net.divideParam.valRatio   = 0.15;
net.divideParam.testRatio  = 0.15;

% --- **** CHANGE TRAINING FUNCTION **** ---
fprintf('Setting Training Function to trainlm (Levenberg-Marquardt).\n');
net.trainFcn = 'trainlm'; % <<<--- USE THIS INSTEAD OF trainbr FOR THIS ATTEMPT ---<<<
% --- **** END CHANGE **** ---

net.performFcn = 'mse';   % Mean squared error
net.trainParam.showWindow = true; % show training GUI

% Optional: Adjust training parameters for trainlm if needed
% net.trainParam.mu = 0.005; % Initial damping factor
% net.trainParam.mu_dec = 0.1;
% net.trainParam.mu_inc = 10;

disp('Neural network configuration:');
disp(net);

%% --- 6. Train the Network ---
fprintf('Starting Neural Network training (this may take a while)...\n');
[trainedNet, tr] = train(net, scaledInputs, scaledTargets);

%% --- 7. Save the Trained Network ---
fprintf('Training complete. Saving trained network...\n');
save(outputNetFile, 'trainedNet', 'tr');
fprintf('Trained network saved to %s.\n', outputNetFile);

%% --- 8. Post-Training Analysis ---
% Performance plot (MSE vs epochs)
figure;
plotperform(tr);
title('Neural Network Training Performance (trainlm)');

% Regression plot (Predicted vs Actual)
outputs = trainedNet(scaledInputs);
figure;
plotregression(scaledTargets, outputs);
title('Regression Analysis (Train/Validation/Test Sets - trainlm)');

fprintf('\nAll steps complete.\n');
