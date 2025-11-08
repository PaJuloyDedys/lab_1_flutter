import 'package:flutter/material.dart';
import 'package:lab_3/services/mqtt_service.dart';
import 'package:lab_3/widgets/app_scaffold.dart';
import 'package:lab_3/widgets/app_text_field.dart';
import 'package:lab_3/widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Твої вже існуючі контролери (наприклад, для displayName/bio) — залиш.
  final displayName = TextEditingController();
  final bio = TextEditingController();

  // Нові під MQTT
  final broker = TextEditingController(text: 'broker.hivemq.com');
  final port = TextEditingController(text: '1883');
  final topic = TextEditingController(text: 'sensor/temperature');

  @override
  void dispose() {
    displayName.dispose();
    bio.dispose();
    broker.dispose();
    port.dispose();
    topic.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final p = int.tryParse(port.text) ?? 1883;
    await MqttService.I.connect(
      host: broker.text.trim(),
      port: p,
      clientId: 'movie_watchlist_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  void _disconnect() {
    MqttService.I.disconnect();
  }

  void _subscribe() {
    final t = topic.text.trim();
    if (t.isNotEmpty) MqttService.I.subscribe(t);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Profile & MQTT',
      child: SingleChildScrollView(
        child: Column(
          children: [
            // --- Профіль ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text('User profile', style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            AppTextField(controller: displayName, label: 'Display Name'),
            const SizedBox(height: 8),
            AppTextField(controller: bio, label: 'Bio'),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Save profile (local)',
              onPressed: () {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved locally')),
                );
              },
            ),

            const Divider(height: 32),

            // --- MQTT Налаштування ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text('MQTT settings', style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            AppTextField(controller: broker, label: 'Broker host'),
            const SizedBox(height: 8),
            AppTextField(controller: port, label: 'Port (default 1883)'),
            const SizedBox(height: 8),
            AppTextField(controller: topic, label: 'Topic (e.g. sensor/temperature)'),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(text: 'Connect', onPressed: _connect),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PrimaryButton(text: 'Disconnect', onPressed: _disconnect),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(text: 'Subscribe', onPressed: _subscribe),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // --- Статус ---
            _Section(
              title: 'Status',
              child: StreamBuilder<String>(
                stream: MqttService.I.statusStream,
                builder: (context, snap) {
                  final text = snap.data ?? (MqttService.I.isConnected ? 'Connected' : 'Disconnected');
                  return Text(text);
                },
              ),
            ),

            const SizedBox(height: 12),

            // --- Останнє повідомлення ---
            _Section(
              title: 'Last message',
              child: StreamBuilder<String>(
                stream: MqttService.I.messageStream,
                builder: (context, snap) {
                  return Text(snap.data ?? '—');
                },
              ),
            ),

            const SizedBox(height: 12),

            // --- Температура (розпарсена) ---
            _Section(
              title: 'Temperature (parsed)',
              child: StreamBuilder<double?>(
                stream: MqttService.I.temperatureStream,
                builder: (context, snap) {
                  final v = snap.data;
                  return Text(v == null ? '—' : '${v.toStringAsFixed(2)} °C');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
