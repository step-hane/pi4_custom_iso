mod boltz_jones;
use std::thread;
use std::time::Duration;

fn main() {
    let mut detector = boltz_jones::BoltzJonesDetector::new(0);

    println!("Simulation de 4 battements espacés de 500ms (BPM attendu ≈ 120)");
    for _ in 0..4 {
        thread::sleep(Duration::from_millis(500));
        let (bpm, phase) = detector.process_beat();
        println!("BPM: {:.2}, Phase offset: {} ms", bpm, phase);
    }
}
