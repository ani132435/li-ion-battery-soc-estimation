% --- Script to Run Multiple Simulations (Using Repeating Sequence Interpolated) ---
clear; clc; close all;

% --- Configuration ---
model_name = 'Battery_Model_First_Order'; % <<< EDIT THIS >>>

temp_block_path = [model_name '/Constant'];      
soc_init_block_path = [model_name '/Integrator']; 
current_input_block_path = [model_name '/CurrentProfileSequence']; 

workspace_var_name = 'simData'; 

temps_to_run = [0, 25, 40];         
start_socs_to_run = [0.8, 0.5, 0.2]; 

% --- Define Dynamic Load Profiles ---
time_vec1 = [0; 50; 100; 150; 200; 250; 300; 500];
current_vec1 = [15; 15; 0; 0; 10; 10; 0; 0];
profile1 = timeseries(current_vec1, time_vec1, 'Name', 'PulseProfile');

time_vec2 = [0; 20; 60; 70; 100; 150; 200; 250; 300; 500];
current_vec2 = [50; 50; 20; -30; -30; 0; 0; 40; 40; 0];
profile2 = timeseries(current_vec2, time_vec2, 'Name', 'MixedProfile');

profiles_to_run = {profile1, profile2};
profile_names = {'Profile1', 'Profile2'};

% --- Test Set Config ---
test_temp = 25;
test_soc = 0.5;
test_profile_idx = 2;

trainValDataFolder = 'TrainValData_1stOrder';
testDataFolderName = 'TestData_1stOrder';
if ~exist(trainValDataFolder, 'dir'), mkdir(trainValDataFolder); end
if ~exist(testDataFolderName, 'dir'), mkdir(testDataFolderName); end

% --- Run Simulations ---
fprintf('Starting simulation runs using %s...\n', model_name);
load_system(model_name);

run_counter = 1;

for T = temps_to_run
    for SoC_start = start_socs_to_run
        for p_idx = 1:length(profiles_to_run)

            current_timeseries = profiles_to_run{p_idx};
            profile_name = profile_names{p_idx};
            is_test_set = (T == test_temp && SoC_start == test_soc && p_idx == test_profile_idx);

            flagStr = '';
            if is_test_set
                flagStr = '(TEST SET)';
            end

            fprintf('Running Sim %d: T=%.0fC, SoC0=%.1f, Profile=%s %s\n', ...
                run_counter, T, SoC_start, profile_name, flagStr);

            try
                set_param(temp_block_path, 'Value', num2str(T));
                set_param(soc_init_block_path, 'InitialCondition', num2str(SoC_start));

                time_vector_string = mat2str(current_timeseries.Time');
                value_vector_string = mat2str(current_timeseries.Data');
                set_param(current_input_block_path, 'TimeValues', time_vector_string);
                set_param(current_input_block_path, 'OutValues', value_vector_string);

            catch ME
                fprintf('ERROR setting parameters for Run %d.\n', run_counter);
                fprintf('Error message: %s\n', ME.message);
                disp(getReport(ME, 'extended'));
                close_system(model_name, 0);
                return;
            end

            try
                simOut = sim(model_name, 'SaveOutput', 'on', 'OutputSaveName', workspace_var_name);
                run_data = simOut.(workspace_var_name);

                output_var_name_in_file = sprintf('Data_T%.0f_S%.0f_%s', T, SoC_start*100, profile_name);
                if is_test_set
                    save_folder = testDataFolderName;
                else
                    save_folder = trainValDataFolder;
                end
                save_filename = fullfile(save_folder, [output_var_name_in_file '.mat']);
                save(save_filename, 'run_data');

                fprintf('Saved data to %s\n', save_filename);
                run_counter = run_counter + 1;

            catch ME
                fprintf('ERROR during simulation for Run %d.\n', run_counter);
                fprintf('Error message: %s\n', ME.message);
                disp(getReport(ME, 'extended'));
            end

        end
    end
end

close_system(model_name, 0);
fprintf('\nAll simulations complete. %d datasets generated.\n', run_counter - 1);
fprintf('Training/Validation data saved in: %s\n', trainValDataFolder);
fprintf('Test data saved in: %s\n', testDataFolderName);
