const http  = require('http');
const { spawn } = require('child_process');

const PORT = 55555;

const INDEX_HTML = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Debug Console</title>
  <style>
    body { font-family: monospace; background: #1e1e1e; color: #eee; padding:10px; }
    #controls { margin-bottom: 1em; }
    button { padding: 0.5em 1em; font-size: 1em; }
    #log  { white-space: pre-wrap; max-height:80vh; overflow-y:auto; border:1px solid #444; padding:0.5em; }
  </style>
</head>
<body>
  <h1>Debug Console</h1>
  <div id="controls">
    <button id="download">Download Full Kernel Log</button>
  </div>
  <div id="log"></div>
  <script>
    (function(){
      // Download button triggers file download
      document.getElementById('download')
        .addEventListener('click', () => { window.location = '/download'; });

      const logEl = document.getElementById('log');
      const evt   = new EventSource('/logs');

      // Log when SSE connection opens
      evt.onopen = () => console.log('[SSE] connection opened');

      // Append each incoming log line
      evt.onmessage = e => {
        const line = e.data;
        const timestamp = new Date().toLocaleTimeString();
        logEl.textContent += '[' + timestamp + '] ' + line + '\\n';
        logEl.scrollTop = logEl.scrollHeight;
      };

      // Handle SSE errors
      evt.onerror = err => {
        console.error('[SSE] error', err);
        evt.close();
      };
    })();
  </script>
</body>
</html>`;

const server = http.createServer((req, res) => {
  if (req.url === '/logs') {
    // SSE endpoint for streaming kernel logs
    res.writeHead(200, {
      'Content-Type':        'text/event-stream; charset=utf-8',
      'Cache-Control':       'no-cache, no-transform',
      'Connection':          'keep-alive',
      'Access-Control-Allow-Origin': '*'
    });
    res.write('\n'); // flush headers

    // Spawn journalctl to fetch last 1000 kernel lines and follow new entries
    const journal = spawn('journalctl', [
      '-k',           // only kernel messages
      '-n', '2000',   // last 2000 lines
      '-f',           // follow new messages
      '--no-pager'
    ]);

    // Send each chunk line-by-line as SSE data events
    journal.stdout.on('data', chunk => {
      chunk.toString().split(/\r?\n/).forEach(line => {
        if (line) res.write(`data: ${line}\n\n`);
      });
    });

    // Forward any journalctl errors to the client
    journal.stderr.on('data', chunk => {
      const errMsg = chunk.toString().trim();
      res.write(`event: error\ndata: [journalctl error] ${errMsg}\n\n`);
    });

    // Clean up when client disconnects
    req.on('close', () => {
      journal.kill();
    });

  } else if (req.url === '/download') {
    // Download endpoint for full kernel log
    res.writeHead(200, {
      'Content-Type': 'text/plain; charset=utf-8',
      'Content-Disposition': 'attachment; filename="kernel.log"'
    });

    // Spawn journalctl to output all kernel logs
    const hist = spawn('journalctl', ['-n', '50000', '--no-pager']);
    hist.stdout.pipe(res);

    // Append any errors in the download stream
    hist.stderr.on('data', chunk => {
      res.write(`# error: ${chunk.toString()}`);
    });

    hist.on('close', () => res.end());

  } else {
    // Serve the main HTML page
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    res.end(INDEX_HTML);
  }
});

server.listen(PORT, () => {
  console.log(`Server listening on http://0.0.0.0:${PORT}/`);
});