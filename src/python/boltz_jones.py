import time
import json

class BeatDetector:
    def __init__(self):
        self.last_beat = time.perf_counter()
        self.bpm_estimate = 120.0

    def process_beat(self):
        now = time.perf_counter()
        interval = now - self.last_beat
        self.last_beat = now

        ms = interval * 1000
        if ms > 0:
            self.bpm_estimate = 60000.0 / ms

        return {
            "bpm": round(self.bpm_estimate, 2),
            "phase_offset_ms": round(ms, 2),
            "timestamp": time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
            "confidence": 0.95
        }
