import 'package:event_ease/features/auth/presentation/widgets/regular/ticket%20get%20section/ticket_archive_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketArchivePage extends StatelessWidget {
  final TicketController controller = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    controller.fetchMyTickets();
    return Scaffold(
      appBar: AppBar(title: const Text("My Tickets"),backgroundColor: Colors.white,surfaceTintColor: Colors.transparent,),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.ticketList.isEmpty) {
          return const Center(child: Text("No tickets found"));
        } else {
          return ListView.builder(
            itemCount: controller.ticketList.length,
            itemBuilder: (context, index) {
              final ticket = controller.ticketList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child: Stack(
                  children: [
                    ListTile(
                      
                      title: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(ticket.typeOfIssue,
                        maxLines: 2,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      subtitle: Text(ticket.description),
                    
                    ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Text(
                                            "${ticket.createdAt.toLocal()}".split(' ')[0],
                                            style: const TextStyle(fontSize: 12,),
                                          ),
                      ),
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
