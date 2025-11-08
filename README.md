# Yes/No Question Share (static)

A lightweight two-page static web app that lets someone create a shareable yes/no question link and send it to others. No backend required — everything runs in the browser.

Files
- `index.html` — Invite page and sender interface. Enter your name and question, generate a shareable link, or open a link containing `sender` and `question` URL params.
- `question.html` — Question page for recipients. Shows the question and two buttons: `Yes` (confirms) and `No` (dodges on hover/touch/click).
- `styles.css` — Clean, responsive styles.

How it works — Sender (create & share)

1. Open `index.html` in your browser.
2. Enter your name in the "Your name" field and type a yes/no question in the "Question" field.
3. Click "Generate Link" — this builds an encoded URL containing your name and question and places it in the share field below.
4. Click "Copy link" to copy the URL to your clipboard.
5. Share that URL with friends. When they open it, the invite page will read the `sender` and `question` params and show "{Name} wants to ask you a question." — they can then proceed to view and answer the question.

How it works — Recipient (answering)

1. Open the shared link in a browser.
2. The invite page shows the sender's name and a preview of the question. Click "what?? ok ask." to go to the question page.
3. On the question page, the `No` button dodges on hover/touch/click to make it tricky to press. The `Yes` button shows a thank-you alert and attempts to close the window; if the browser blocks closure, a small thank-you screen appears.

Examples

- Example link (URL-encoded):

  https://example.com/index.html?sender=Alice&question=Do%20you%20like%20cats%3F

- Local file example (PowerShell):

```powershell
# Replace <ABS_PATH> with your folder, for example D:/fun/index.html
start "" "file:///<ABS_PATH>/index.html?sender=Alice&question=Do%20you%20like%20cats%3F"
```

Local server (recommended for full clipboard & mobile testing)

Run a simple static server from the project folder and open `http://localhost:8000` in your browser:

```powershell
# from d:/fun
python -m http.server 8000
# then open http://localhost:8000/index.html in your browser
```

Notes & troubleshooting
- The app is static: all data is in the URL. There is no persistence.
- Clipboard copy uses the modern Clipboard API (`navigator.clipboard`) when available; a fallback `document.execCommand('copy')` is provided for older environments. Copying may require a secure context (HTTPS or localhost).
- `window.close()` may be blocked by browsers if the page wasn't opened by script. The app falls back to an in-page thank-you message in that case.
- The `No` button's dodge behavior attempts to avoid overlapping the `Yes` button and stays inside its container. On very small screens the available movement is limited but still constrained inside the button area.

Want a README screenshot or a web-hosted demo? I can add a small GIF or deploy a demo if you want — tell me how you'd like to share it.
# Yes/No Question Share (static)

Two-page static web app that lets someone share a personalized yes/no question via a link.

Files
- `index.html` — Invite page. Reads URL params `sender` and `question` and shows an invite message with a button.
- `question.html` — Question page. Shows the question and two buttons: `Yes` and `No`. The `No` button dodges on hover/touch/click.
- `styles.css` — Simple, responsive styling.

Usage

1. Open `index.html` in a browser. Add URL params, for example:

```powershell
# Windows PowerShell example (file path may vary). Open in default browser:
start "" "file:///<absolute-path-to-workspace>/index.html?sender=Alice&question=Do%20you%20like%20cats%3F"
```

Or simply open `index.html` and append `?sender=Alice&question=Do%20you%20like%20cats%3F` in the address bar.

2. Click the “what?? ok ask.” button to go to the question page. The `No` button will dodge; `Yes` shows a thank-you alert and attempts to close the window.

Notes
- This is a static front-end only app (no backend). URL parameters power the dynamic content.
- The No button movement keeps it inside the button container and uses smooth transitions.
