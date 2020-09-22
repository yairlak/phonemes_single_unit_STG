clear all; close all; clc

%% Load settings and parameters
settings.patient = 'All';
[settings, params] = load_settings_params(settings);
rng(params.seed)
%% Load desired set of phonemes (conditions)
settings = load_phonemes(settings);

%%
path2wavfiles = fullfile('..', 'data', 'phoneme_stimuli_cut');

%% PHONEMES
for ph = 1:length(settings.phonemes)
    curr_phonemes_IPA{ph} = settings.ph_name_to_IPA(settings.phonemes{ph});
end

num_phonemes = length(settings.phonemes);

%% SPECTROGRAMS
for i_ph = 1:num_phonemes
    for i_speaker = 1:3
        ph_name_IPA = settings.ph_name_to_IPA(settings.phonemes{i_ph});
        fprintf('Phone %i, speaker %i\n', i_ph, i_speaker)
        fname_wav = sprintf('%i.wav', settings.phonemes_serial_number(i_ph) + (i_speaker-1)*27);
        new_fname = ['ph_', ph_name_IPA, '_speaker_',  num2str(i_speaker), '_serial_num_', fname_wav];
       
        [y, fs] = audioread(fullfile(path2wavfiles, new_fname));
        
        fs_low = 16000;
        y_downsampled = resample(y,fs_low, fs);

        f_spec = figure('Color', [1, 1, 1], 'Position', [20 20 800 500], 'PaperPositionMode', 'auto', 'Visible', 'off');
        subplot(2,1,1);
        t = 1:length(y_downsampled);
        t = t/fs_low;
        plot(t, y_downsampled)
        ylabel('Waveform Amplitude', 'fontsize', 16)
        axis([0 length(y_downsampled)/fs_low  -1 1]);
        set(gca, 'Position', [0.15 0.55 0.7 0.35])
        xticks();
        title(['Phoneme name - ', ph_name_IPA], 'fontsize', 16)
        subplot(2,1,2); 
        
        [S, F, T] = spectrogram(y_downsampled,80,40,2048,fs_low, 'yaxis');
        S = abs(S);                         % compute magnitude spectrum 
        S = S/max(max(S));                  % normalize magntide spectrum
        S = 20*log10(S);                    % compute power spectrum in dB    
        imagesc(T, F, S, [-59 -1]);
        axis('xy');
        axis([0 length(y_downsampled)/fs_low  0 fs_low/2]);
        colormap('gray');
        map=colormap;
        colormap(1-map);
        
        set(gca, 'Position', [0.15 0.1 0.7 0.35])
        cbar = colorbar('Position', [0.9  0.1  0.02  0.35]);
        ylabel(cbar, 'dB')
        xlabel('Time (s)', 'FontSize', 16);
        ylabel('Frequency (Hz)', 'FontSize', 16);
        fig_file_name = ['spec_speaker_', num2str(i_speaker), '_', ph_name_IPA, '.png'];
        saveas(f_spec, fullfile('..', 'figures', 'spectrograms', fig_file_name), 'png')
        close(f_spec)
        
    end
end
