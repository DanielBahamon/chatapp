import WebSocket from 'ws';

const token =
  'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMCIsInNjcCI6InVzZXIiLCJhdWQiOm51bGwsImlhdCI6MTcxMzcwNzExOSwiZXhwIjoxNzEzNzkzNTE5LCJqdGkiOiJlMDZlMjc1Mi1hZDk4LTRlOTgtYWMzOS0yODA1MDUyNzA5OTUifQ.PV7f9Sum45aC6RX5rZMK2al2V0lsdW9c5njih_LcJD0';

const ws = new WebSocket(`ws://localhost:3000/cable?token=${token}`);

ws.on('error', console.error);

ws.on('open', function open() {
  const message = JSON.stringify({
    command: 'subscribe',
    identifier: JSON.stringify({
      channel: 'ChatChannel',
      application_token: 'bdfe300a16',
      chat_number: '1',
    }),
  });

  ws.send(message);
});

ws.on('message', function message(data) {
  data = JSON.parse(data);

  if (data.type === 'ping') {
    const date = new Date(data.message * 1000);

    data.message = date.toISOString();
  }
  console.log('received: %s', JSON.stringify(data, null, 2));

  if (data.type === 'confirm_subscription') {
    const speak = JSON.stringify({
      command: 'message',
      identifier: JSON.stringify({
        channel: 'ChatChannel',
        application_token: 'bdfe300a16',
        chat_number: '1',
      }),
      data: JSON.stringify({
        action: 'receive',
        body: 'Hello, Chat',
      }),
    });

    ws.send(speak);
    console.log('sent: %s', speak);
  }
});
