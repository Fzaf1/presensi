import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/widgets/lookin_widgets.dart';
import '../../main.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _reasonController = TextEditingController();
  String _requestType = 'Cuti Tahunan';
  DateTimeRange? _dateRange;
  String? _attachmentName;
  String _latestType = 'Izin Sakit';
  String _latestStatus = 'Disetujui';

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _chooseDates() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      initialDateRange: _dateRange,
    );
    if (range != null) setState(() => _dateRange = range);
  }

  Future<void> _chooseFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result.isNotEmpty) {
      setState(() => _attachmentName = result.first.name);
    }
  }

  void _submit() {
    if (_reasonController.text.trim().isEmpty || _dateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi rentang tanggal dan alasan pengajuan.'),
        ),
      );
      return;
    }
    setState(() {
      _latestType = _requestType;
      _latestStatus = 'Menunggu';
      _reasonController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengajuan berhasil dikirim.')),
    );
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
    children: [
      const LookInLogo(compact: true),
      const SizedBox(height: 20),
      Row(
        children: [
          const Expanded(child: SectionTitle('Buat Pengajuan')),
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFE5EEFF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: Text(
                'Sisa Cuti: 10',
                style: TextStyle(
                  color: lookInBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel('Jenis Pengajuan'),
            DropdownButtonFormField<String>(
              initialValue: _requestType,
              decoration: const InputDecoration(),
              items:
                  const [
                    'Cuti Tahunan',
                    'Izin Pribadi',
                    'Izin Sakit',
                    'Lembur',
                  ].map((value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _requestType = value);
              },
            ),
            const SizedBox(height: 16),
            const _FieldLabel('Rentang Tanggal'),
            InkWell(
              onTap: _chooseDates,
              child: InputDecorator(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_month_outlined),
                ),
                child: Text(
                  _dateRange == null
                      ? 'Pilih tanggal'
                      : '${_dateRange!.start.day} ${_monthName(_dateRange!.start.month)} - ${_dateRange!.end.day} ${_monthName(_dateRange!.end.month)} ${_dateRange!.end.year}',
                  style: TextStyle(
                    color: _dateRange == null
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF334155),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('Keterangan / Alasan'),
            TextField(
              controller: _reasonController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tuliskan alasan pengajuan...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('Lampiran (Opsional)'),
            OutlinedButton.icon(
              onPressed: _chooseFile,
              icon: const Icon(Icons.attach_file),
              label: Text(_attachmentName ?? 'Unggah File (.pdf, .jpg)'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                foregroundColor: const Color(0xFF475569),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Kirim Pengajuan',
              icon: Icons.send_rounded,
              color: lookInBlue,
              onPressed: _submit,
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      const SectionTitle('Status Terakhir'),
      const SizedBox(height: 12),
      SurfaceCard(
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.assignment_outlined, color: lookInBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _latestType,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    '15 Sep 2026',
                    style: TextStyle(fontSize: 11, color: Color(0xFF718096)),
                  ),
                ],
              ),
            ),
            _StatusBadge(status: _latestStatus),
          ],
        ),
      ),
    ],
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(
      text,
      style: const TextStyle(
        color: Color(0xFF334155),
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;
  @override
  Widget build(BuildContext context) {
    final pending = status == 'Menunggu';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: pending ? const Color(0xFFFFF4D6) : const Color(0xFFD9F7E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: pending ? const Color(0xFF9A6700) : const Color(0xFF16804A),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _monthName(int month) => const [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
][month];
