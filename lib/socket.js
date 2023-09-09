// // Require the necessary modules
// const express = require('express');
// const http = require('http');
// const socketIO = require('socket.io');

// // Create an Express app
// const app = express();
// const server = http.createServer(app);

// // Create a Socket.IO instance
// const io = socketIO(server);

// let activeUsers = [];

// io.on("connection", (socket) => {
//   // add new User
//   socket.on("new-user-add", (newUserId) => {
//     // if user is not added previously
//     if (!activeUsers.some((user) => user.userId === newUserId)) {
//       activeUsers.push({ userId: newUserId, socketId: socket.id });
//       console.log("New User Connected", activeUsers);
//     }
//     // send all active users to new user
//     io.emit("get-users", activeUsers);
//   });

//   socket.on("disconnect", () => {
//     // remove user from active users
//     activeUsers = activeUsers.filter((user) => user.socketId !== socket.id);
//     console.log("User Disconnected", activeUsers);
//     // send all active users to all users
//     io.emit("get-users", activeUsers);
//   });

// //   // send message to a specific user
// //   socket.on("send-message", (data) => {
// //     const { receiverId } = data;
// //     const user = activeUsers.find((user) => user.userId === receiverId);
// //     console.log(user)
// //     console.log("Sending from socket to :", receiverId)
// //     console.log("Data: ", data)
// //     // if (user) {
// //       io.emit("recieve-message", data);
// //     //   to(user.socketId).
// //     // }
// //   });


// socket.on('send-message', ({ to, message }) => {
//     const toSocketId = activeUsers.some(user => user.userId === to);
//     console.log(activeUsers);
//     console.log(to);
//     console.log(activeUsers.find(user => user.userId === to))
//     console.log(toSocketId)
//     if (toSocketId) {
//       io.to(toSocketId).emit('recieve-message', {
//         from: socket.id,
//         message: message,
//       });
//       console.log(`Message sent from ${socket.id} to ${to}`);
//     } else {
//       console.log(`User ${to} not found`);
//     }
//   });
// });

// // Start the server
// const port = 3434;
// server.listen(port, () => {
//       console.log(`Server is running on port ${port}`);
// });



const http = require('http');
const socketIO = require('socket.io');

const server = http.createServer();
const io = socketIO(server);

// Store user information (you might want to use a database instead)
const users = {};

io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('join', (userId) => {
    users[userId] = socket.id;
    console.log(`User ${userId} joined`);
  });

  socket.on('privateMessage', (message) => {
    const receiverSocketId = users[message.receiver];
    if (receiverSocketId) {
      socket.to(receiverSocketId).emit('privateMessage', message);
    } else {
      console.log(`User ${userId} not found`);
    }
  });

  socket.on('disconnect', () => {
    const userId = Object.keys(users).find((key) => users[key] === socket.id);
    if (userId) {
      console.log(`User ${userId} disconnected`);
      delete users[userId];
    }
  });
});

const PORT = 3434;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


