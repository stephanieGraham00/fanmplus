const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const path = require('path');
const Database = require('better-sqlite3');

const app = express();
const PORT = 3000;
const JWT_SECRET = 'fanmplus-secret-key-2026';

app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.static(path.join(__dirname, 'public')));

// ===== DATABASE =====
const db = new Database('fanmplus.db');
db.pragma('journal_mode = WAL');

db.exec(`
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    bio TEXT DEFAULT '',
    health_info TEXT DEFAULT '',
    avatar TEXT DEFAULT '♥',
    role TEXT DEFAULT 'user',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME
  );

  CREATE TABLE IF NOT EXISTS cycle_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    date TEXT NOT NULL,
    flow TEXT DEFAULT 'none',
    symptoms TEXT DEFAULT '[]',
    notes TEXT DEFAULT '',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
  );

  CREATE TABLE IF NOT EXISTS journal_entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title TEXT DEFAULT '',
    content TEXT DEFAULT '',
    mood TEXT DEFAULT '',
    tags TEXT DEFAULT '[]',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
  );

  CREATE TABLE IF NOT EXISTS appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    doctor_name TEXT NOT NULL,
    doctor_spec TEXT DEFAULT '',
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    notes TEXT DEFAULT '',
    status TEXT DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
  );

  CREATE TABLE IF NOT EXISTS posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    likes INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
  );

  CREATE TABLE IF NOT EXISTS activity_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    action TEXT NOT NULL,
    details TEXT DEFAULT '',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  );
`);

// ===== MIDDLEWARE =====
function authenticate(req, res, next) {
  const header = req.headers.authorization;
  if (!header) return res.status(401).json({ error: 'Pa gen token' });
  try {
    const token = header.split(' ')[1];
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch (e) {
    res.status(401).json({ error: 'Token pa valab' });
  }
}

function log(userId, action, details = '') {
  db.prepare('INSERT INTO activity_log (user_id, action, details) VALUES (?, ?, ?)').run(userId, action, details);
}

// ===== AUTH API =====
app.post('/api/register', (req, res) => {
  const { name, email, password, healthInfo } = req.body;
  if (!name || !email || !password) return res.status(400).json({ error: 'Non, imèl ak modpas nesesè' });

  const existing = db.prepare('SELECT id FROM users WHERE email = ?').get(email);
  if (existing) return res.status(400).json({ error: 'Imèl sa deja egziste' });

  const hash = bcrypt.hashSync(password, 10);
  const result = db.prepare('INSERT INTO users (name, email, password, health_info) VALUES (?, ?, ?, ?)').run(name, email, hash, healthInfo || '');
  
  log(result.lastInsertRowid, 'Enskripsyon', `Nouvo itilizatè: ${name}`);

  const token = jwt.sign({ id: result.lastInsertRowid, email, name, role: 'user' }, JWT_SECRET);
  res.json({ token, user: { id: result.lastInsertRowid, name, email, role: 'user' } });
});

app.post('/api/login', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ error: 'Imèl ak modpas nesesè' });

  let user = db.prepare('SELECT * FROM users WHERE email = ?').get(email);
  
  // Default admin account
  if (!user && email === 'admin@fanmplus.com') {
    const hash = bcrypt.hashSync('admin123', 10);
    db.prepare('INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)').run('Admin Fanm+', email, hash, 'admin');
    user = db.prepare('SELECT * FROM users WHERE email = ?').get(email);
  }

  if (!user) return res.status(400).json({ error: 'Imèl pa egziste' });
  if (!bcrypt.compareSync(password, user.password)) return res.status(400).json({ error: 'Modpas pa kòrèk' });

  db.prepare('UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?').run(user.id);
  log(user.id, 'Koneksyon', `${user.name} konekte`);

  const token = jwt.sign({ id: user.id, email: user.email, name: user.name, role: user.role }, JWT_SECRET);
  res.json({ token, user: { id: user.id, name: user.name, email: user.email, role: user.role, bio: user.bio, avatar: user.avatar } });
});

// ===== USER API =====
app.get('/api/users', authenticate, (req, res) => {
  if (req.user.role !== 'admin') return res.status(403).json({ error: 'Pa gen aksè' });
  const users = db.prepare('SELECT id, name, email, role, created_at, last_login FROM users ORDER BY created_at DESC').all();
  res.json(users);
});

app.get('/api/users/:id', authenticate, (req, res) => {
  const user = db.prepare('SELECT id, name, email, bio, avatar, role, health_info, created_at, last_login FROM users WHERE id = ?').get(req.params.id);
  if (!user) return res.status(404).json({ error: 'Itilizatè pa egziste' });
  res.json(user);
});

app.put('/api/users/:id', authenticate, (req, res) => {
  if (req.user.id != req.params.id && req.user.role !== 'admin') return res.status(403).json({ error: 'Pa gen aksè' });
  const { name, bio, email } = req.body;
  db.prepare('UPDATE users SET name = COALESCE(?, name), bio = COALESCE(?, bio), email = COALESCE(?, email) WHERE id = ?').run(name, bio, email, req.params.id);
  log(req.user.id, 'Pwofil ajoute', `Itilizatè #${req.params.id} modifye`);
  res.json({ success: true });
});

// ===== CYCLE API =====
app.post('/api/cycle', authenticate, (req, res) => {
  const { date, flow, symptoms, notes } = req.body;
  const existing = db.prepare('SELECT id FROM cycle_logs WHERE user_id = ? AND date = ?').get(req.user.id, date);
  if (existing) {
    db.prepare('UPDATE cycle_logs SET flow = ?, symptoms = ?, notes = ? WHERE id = ?').run(flow || 'none', JSON.stringify(symptoms || []), notes || '', existing.id);
  } else {
    db.prepare('INSERT INTO cycle_logs (user_id, date, flow, symptoms, notes) VALUES (?, ?, ?, ?, ?)').run(req.user.id, date, flow || 'none', JSON.stringify(symptoms || []), notes || '');
  }
  res.json({ success: true });
});

app.get('/api/cycle', authenticate, (req, res) => {
  const logs = db.prepare('SELECT * FROM cycle_logs WHERE user_id = ? ORDER BY date DESC LIMIT 90').all(req.user.id);
  res.json(logs.map(l => ({ ...l, symptoms: JSON.parse(l.symptoms) })));
});

// ===== JOURNAL API =====
app.post('/api/journal', authenticate, (req, res) => {
  const { title, content, mood, tags } = req.body;
  const result = db.prepare('INSERT INTO journal_entries (user_id, title, content, mood, tags) VALUES (?, ?, ?, ?, ?)').run(req.user.id, title || '', content || '', mood || '', JSON.stringify(tags || []));
  res.json({ id: result.lastInsertRowid });
});

app.get('/api/journal', authenticate, (req, res) => {
  const entries = db.prepare('SELECT * FROM journal_entries WHERE user_id = ? ORDER BY created_at DESC').all(req.user.id);
  res.json(entries.map(e => ({ ...e, tags: JSON.parse(e.tags) })));
});

app.delete('/api/journal/:id', authenticate, (req, res) => {
  db.prepare('DELETE FROM journal_entries WHERE id = ? AND user_id = ?').run(req.params.id, req.user.id);
  res.json({ success: true });
});

// ===== APPOINTMENT API =====
app.post('/api/appointments', authenticate, (req, res) => {
  const { doctorName, doctorSpec, date, time, notes } = req.body;
  const result = db.prepare('INSERT INTO appointments (user_id, doctor_name, doctor_spec, date, time, notes) VALUES (?, ?, ?, ?, ?, ?)').run(req.user.id, doctorName, doctorSpec, date, time, notes || '');
  res.json({ id: result.lastInsertRowid });
});

app.get('/api/appointments', authenticate, (req, res) => {
  const appts = db.prepare('SELECT * FROM appointments WHERE user_id = ? ORDER BY date DESC, time DESC').all(req.user.id);
  res.json(appts);
});

app.delete('/api/appointments/:id', authenticate, (req, res) => {
  db.prepare('DELETE FROM appointments WHERE id = ? AND user_id = ?').run(req.params.id, req.user.id);
  res.json({ success: true });
});

// ===== POSTS API =====
app.get('/api/posts', (req, res) => {
  const posts = db.prepare(`
    SELECT p.*, u.name as author_name, u.avatar as author_avatar 
    FROM posts p JOIN users u ON p.user_id = u.id 
    ORDER BY p.created_at DESC LIMIT 50
  `).all();
  res.json(posts);
});

app.post('/api/posts', authenticate, (req, res) => {
  const { content } = req.body;
  const result = db.prepare('INSERT INTO posts (user_id, content) VALUES (?, ?)').run(req.user.id, content);
  log(req.user.id, 'Post pibliye', content.substring(0, 50));
  res.json({ id: result.lastInsertRowid });
});

app.post('/api/posts/:id/like', authenticate, (req, res) => {
  db.prepare('UPDATE posts SET likes = likes + 1 WHERE id = ?').run(req.params.id);
  res.json({ success: true });
});

// ===== ADMIN API =====
app.get('/api/admin/stats', authenticate, (req, res) => {
  if (req.user.role !== 'admin') return res.status(403).json({ error: 'Pa gen aksè' });
  const users = db.prepare('SELECT COUNT(*) as count FROM users').get();
  const posts = db.prepare('SELECT COUNT(*) as count FROM posts').get();
  const apps = db.prepare('SELECT COUNT(*) as count FROM appointments').get();
  const journals = db.prepare('SELECT COUNT(*) as count FROM journal_entries').get();
  const todayLogins = db.prepare("SELECT COUNT(*) as count FROM activity_log WHERE action = 'Koneksyon' AND date(created_at) = date('now')").get();
  res.json({ users: users.count, posts: posts.count, appointments: apps.count, journals: journals.count, todayLogins: todayLogins.count });
});

app.get('/api/admin/activity', authenticate, (req, res) => {
  if (req.user.role !== 'admin') return res.status(403).json({ error: 'Pa gen aksè' });
  const logs = db.prepare(`
    SELECT al.*, u.name as user_name 
    FROM activity_log al 
    LEFT JOIN users u ON al.user_id = u.id 
    ORDER BY al.created_at DESC LIMIT 50
  `).all();
  res.json(logs);
});

// ===== ADMIN DASHBOARD =====
app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'admin', 'dashboard.html'));
});

// ===== SERVE FRONTEND =====
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log('♥ Fanm+ Backend lanse! ♥');
  console.log(`  Lokal: http://localhost:${PORT}`);
  console.log('  Admin: http://localhost:' + PORT + '/admin');
  console.log('');
  console.log('  Mwen pare pou sèvi tout fanm! 🌸');
});
