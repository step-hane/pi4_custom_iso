from src.python.boltz_jones import BeatDetector
import time

detector = BeatDetector()

print("Simulation de 4 battements espacés de 500ms (BPM attendu ≈ 120)")
for _ in range(4):
    time.sleep(0.5)  # 500 ms
    result = detector.process_beat()
    print(f"BPM: {result['bpm']}, Phase offset: {result['phase_offset_ms']} ms, Timestamp: {result['timestamp']}, Confidence: {result['confidence']}")
