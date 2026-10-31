import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/lookin_widgets.dart';
import '../../main.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _month = DateTime.now();
  int _selectedDay = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(_month.year, _month.month, 1);
    final offset = firstDay.weekday - 1;
    final daysInMonth = DateUtils.getDaysInMonth(_month.year, _month.month);
    final cells = ((offset + daysInMonth + 6) ~/ 7) * 7;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        const LookInLogo(compact: true),
        const SizedBox(height: 20),
        const SectionTitle('Riwayat Presensi'),
        const SizedBox(height: 16),
        SurfaceCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(
                      () => _month = DateTime(_month.year, _month.month - 1),
                    ),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text(
                      DateFormat('MMMM yyyy', 'id_ID').format(_month),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(
                      () => _month = DateTime(_month.year, _month.month + 1),
                    ),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              Row(
                children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF718096),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cells,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: .86,
                ),
                itemBuilder: (context, index) {
                  final day = index - offset + 1;
                  if (day < 1 || day > daysInMonth) {
                    return const SizedBox.shrink();
                  }
                  final selected = day == _selectedDay;
                  final hasAttendance = day <= 20 && day % 7 != 0;
                  return InkWell(
                    onTap: () => setState(() => _selectedDay = day),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected ? lookInBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$day',
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF334155),
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (hasAttendance)
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF18A768),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionTitle(
          'Detail ${_selectedDay.toString().padLeft(2, '0')} ${DateFormat('MMM yyyy', 'id_ID').format(_month)}',
        ),
        const SizedBox(height: 12),
        SurfaceCard(
          child: Column(
            children: [
              _HistoryRow(
                icon: Icons.login_rounded,
                color: const Color(0xFF18A768),
                label: 'Jam Masuk',
                value: _selectedDay <= 20 ? '08:15 AM' : 'Belum tercatat',
              ),
              const Divider(height: 22),
              _HistoryRow(
                icon: Icons.logout_rounded,
                color: const Color(0xFFEF4444),
                label: 'Jam Pulang',
                value: _selectedDay < DateTime.now().day
                    ? '05:30 PM'
                    : 'Belum tercatat',
              ),
              const Divider(height: 22),
              const _HistoryRow(
                icon: Icons.timelapse_rounded,
                color: lookInBlue,
                label: 'Total Jam Kerja',
                value: '08j 15m',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Titik hijau menandakan presensi tercatat.',
          style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
        ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(width: 12),
      Expanded(
        child: Text(label, style: const TextStyle(color: Color(0xFF64748B))),
      ),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
  );
}
