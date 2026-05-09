///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_generator;
  mailbox #(bzu_packet) mb_user;

  function new(mailbox #(bzu_packet) mb_user_i);
    mb_user = mb_user_i;
  endfunction

  task transmit(input bzu_packet pkt);
    mb_user.put(pkt);
  endtask
endclass

