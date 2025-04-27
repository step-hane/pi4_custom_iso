use rosc::encoder;
use rosc::OscPacket;
use std::net::UdpSocket;

pub struct BeatManager {
    ip: String,
    port: u16,
}

impl BeatManager {
    pub fn new(ip: &str, port: u16) -> Self {
        Self {
            ip: ip.to_string(),
            port,
        }
    }

    fn send_osc_message(&self, addr: &str, args: Vec<rosc::OscType>) {
        if let Ok(socket) = UdpSocket::bind("0.0.0.0:0") {
            let packet = OscPacket::Message(rosc::OscMessage {
                addr: addr.to_string(),
                args,
            });
            if let Ok(buf) = encoder::encode(&packet) {
                let _ = socket.send_to(&buf, format!("{}:{}", self.ip, self.port));
            }
        }
    }

    pub fn send_bpm(&self, bpm: f32) {
        self.send_osc_message("/bpm", vec![rosc::OscType::Float(bpm)]);
    }

    pub fn send_potentiometer(&self, value: f32) {
        self.send_osc_message("/potentiometer1", vec![rosc::OscType::Float(value)]);
    }

    pub fn send_snare_trigger(&self) {
        self.send_osc_message("/snare_trigger", vec![rosc::OscType::Int(1)]);
    }
}
