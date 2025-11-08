// publisher.js
const mqtt = require("mqtt");

// Адреса публічного брокера (той самий, який ти вводиш у Flutter)
const client = mqtt.connect("mqtt://broker.hivemq.com:1883");

const topic = "sensor/temperature";

client.on("connect", () => {
  console.log("✅ Connected to MQTT broker");
  // Кожні 2 секунди публікуємо рандомну температуру
  setInterval(() => {
    const temp = (20 + Math.random() * 10).toFixed(2);
    client.publish(topic, temp);
    console.log("📤 Sent:", temp);
  }, 2000);
});

client.on("error", (err) => {
  console.error("❌ Error:", err);
});
