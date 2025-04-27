use std::time::{Duration, Instant};

pub struct BeatDetector {
    last_beat: Instant,
    bpm_estimate: f32,
}

impl BeatDetector {
    pub fn new() -> Self {
        BeatDetector {
            last_beat: Instant::now(),
            bpm_estimate: 120.0, // valeur par défaut
        }
    }

    pub fn process_beat(&mut self) -> (f32, u128) {
        let now = Instant::now();
        let interval = now.duration_since(self.last_beat);
        self.last_beat = now;

        let ms = interval.as_millis();
        if ms > 0 {
            self.bpm_estimate = 60_000.0 / ms as f32;
        }

        (self.bpm_estimate, ms)
    }
}
use std::time::{Duration, Instant};

pub struct BeatDetector {
    last_beat: Instant,
    bpm_estimate: f32,
}

impl BeatDetector {
    pub fn new() -> Self {
        BeatDetector {
            last_beat: Instant::now(),
            bpm_estimate: 120.0, // valeur par défaut
        }
    }

    pub fn process_beat(&mut self) -> (f32, u128) {
        let now = Instant::now();
        let interval = now.duration_since(self.last_beat);
        self.last_beat = now;

        let ms = interval.as_millis();
        if ms > 0 {
            self.bpm_estimate = 60_000.0 / ms as f32;
        }

        (self.bpm_estimate, ms)
    }
}
