// import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
// import 'package:flutter/material.dart';

// class DiscussionComen extends StatelessWidget {
//   const AddQuestionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController titleController = TextEditingController();
//     final TextEditingController contentController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF55C173),
//         title: CustomText("Buat Pertanyaan", fontWeight: FontWeight.bold),
//         centerTitle: true,
//       ),
//       backgroundColor: const Color(0xFFF7F8FA),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomText("Judul Pertanyaan", fontWeight: FontWeight.w600),
//             const SizedBox(height: 8),
//             TextField(
//               controller: titleController,
//               decoration: InputDecoration(
//                 hintText: "Tulis judul/topik pertanyaan...",
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             CustomText("Isi Pertanyaan", fontWeight: FontWeight.w600),
//             const SizedBox(height: 8),
//             Expanded(
//               child: TextField(
//                 controller: contentController,
//                 maxLines: null,
//                 expands: true,
//                 decoration: InputDecoration(
//                   hintText: "Tulis pertanyaanmu di sini...",
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // TODO: simpan pertanyaan ke database / API
//                   Navigator.pop(context); // kembali ke halaman forum
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF55C173),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 child: const Text(
//                   "Posting Pertanyaan",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
