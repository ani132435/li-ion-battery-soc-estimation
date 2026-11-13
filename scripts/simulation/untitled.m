clear; clc; close all;
format compact;

model_name = 'Battery_Model_Second_Order';

temp_block_path = [model_name '/Constant '];     
soc_init_block_path = [model_name '/Integrator SoC']; 
current_input_block_path = [model_name '/From Workspace Current']; 

workspace_var_name = 'simData'; 

temps_to_run = [0, 25, 40];
start_socs_to_run = [0.8, 0.5, 0.2];

time_vec1 = [0; 50; 100; 150; 200; 250; 300; 500];
current_vec1 = [15; 15; 0; 0; 10; 10; 0; 0];
profile1 = timeseries(current_vec1, time_vec1, 'Name', 'PulseProfile');

time_vec2 = [0; 20; 60; 70; 100; 150; 200; 250; 300; 500];
current_vec2 = [50; 50; 20; -30; -30; 0; 0; 40; 40; 0];
profile2 = timeseries(current_vec2, time_vec2, 'Name', 'MixedProfile');

profiles_to_run = {profile1, profile2};
profile_names = {'Profile1', 'Profile2'};

run_counter = 1;
all_sim_data = {};

fprintf('Starting simulation runs...\n');
load_system(model_name);

for T = temps_to_run
    for SoC_start = start_socs_to_run
        for p_idx = 1:length(profiles_to_run)

            current_profile = profiles_to_run{p_idx};
            profile_name = profile_names{p_idx};
            assignin('base', 'current_profile', current_profile);

            fprintf('Running Sim %d: T=%.0fC, SoC0=%.1f, Profile=%s\n', ...
                    run_counter, T, SoC_start, profile_name);

            try
                set_param(temp_block_path, 'Value', num2str(T));
                set_param(soc_init_block_path, 'InitialCondition', num2str(SoC_start));
                set_param(current_input_block_path, 'VariableName', 'current_profile');
            catch ME
                fprintf('ERROR setting parameters for Run %d: %s\n', run_counter, ME.message);
                close_system(model_name, 0);
                return;
            end

            try
                simOut = sim(model_name, 'SaveOutput', 'on', ...
                             'OutputSaveName', workspace_var_name, ...
                             'SrcWorkspace', 'base');

                if isprop(simOut, workspace_var_name)
                    run_data = simOut.(workspace_var_name);
                else
                    run_data = simOut.get(workspace_var_name);
                end

                output_var_name_in_file = sprintf('Data_T%.0f_SoC%.0f_%s', ...
                                                  T, SoC_start*100, profile_name);
                save_filename = [output_var_name_in_file '.mat'];
                save(save_filename, 'run_data');

                fprintf('Saved data to %s\n', save_filename);
                all_sim_data{run_counter} = run_data;
                run_counter = run_counter + 1;

            catch ME
                fprintf('ERROR during simulation for Run %d: %s\n', run_counter, ME.message);
            end
        end
    end
end

fprintf('All simulations complete. %d datasets generated.\n', run_counter - 1);
% close_system(model_name, 0);
