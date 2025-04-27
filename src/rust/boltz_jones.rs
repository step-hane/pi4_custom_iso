use rustfft::{FftPlanner, num_complex::Complex};
use std::f32::consts::PI;
use std::time::{Duration, Instant};

/// Détecteur BPM basé sur Boltz & Jones.
pub struct BoltzJonesDetector {
    sample_rate: usize,
    history: Vec<f32>,
    timestamps: Vec<Instant>, // stock temps
    max_history_len: usize,
}


impl BoltzJonesDetector {
    pub fn new(sample_rate: usize) -> Self {
        Self {
            sample_rate,
            history: Vec::new(),
            max_history_len: sample_rate * 10, // 10 secondes d'historique maximum
        }
    }

    /// Ajoute une impulsion flux temporel.
    pub fn add_pulse(&mut self, energy: f32) {
        self.history.push(energy);
		self.timestamps.push(Instant::now());
        if self.history.len() > self.max_history_len {
            self.history.remove(0);
			self.timestamps.remove(0);
        }
    }

    /// Analyse impulsions BPM dominant.
    pub fn detect_bpm(&self) -> Option<f32> {
        if self.history.len() < self.sample_rate {
            return None;
        }

        let mut planner = FftPlanner::new();
        let fft = planner.plan_fft_forward(self.history.len());
        let mut buffer: Vec<Complex<f32>> = self.history
            .iter()
            .map(|&v| Complex { re: v, im: 0.0 })
            .collect();

        fft.process(&mut buffer);

        let magnitude: Vec<f32> = buffer.iter().map(|c| c.norm()).collect();
        let dominant_index = magnitude
            .iter()
            .enumerate()
            .skip(1)
            .max_by(|a, b| a.1.partial_cmp(b.1).unwrap())
            .map(|(idx, _)| idx)?;

        let freq_hz = dominant_index as f32 * (self.sample_rate as f32 / self.history.len() as f32);
        let bpm = freq_hz * 60.0;

        if bpm >= 60.0 && bpm <= 180.0 {
            Some((bpm * 100.0).round() / 100.0) // Deux décimales
        } else {
            None
        }
    }

    /// Détection snare sur un seuil input brutal.
    pub fn detect_snare(&self, threshold: f32) -> bool {
        if let Some(&last) = self.history.last() {
            return last > threshold;
        }
        false
    }
}
