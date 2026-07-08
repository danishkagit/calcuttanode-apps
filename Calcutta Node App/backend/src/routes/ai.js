import { Router } from 'express';

const router = Router();

const models = [
  { id: 'deepseek-v4-flash-free', name: 'DeepSeek V4 Flash Free', icon: '🔍', color: '#7EBBC5', provider: 'opencode' },
  { id: 'mimo-v2.5-free', name: 'MiMo V2.5 Free', icon: '🧠', color: '#543A67', provider: 'opencode' },
  { id: 'north-mini-code-free', name: 'North Mini Code Free', icon: '⚡', color: '#FFD700', provider: 'opencode' },
  { id: 'nemotron-3-ultra-free', name: 'Nemotron 3 Ultra Free', icon: '🚀', color: '#FF6B6B', provider: 'opencode' },
  { id: 'hy3-free', name: 'Hy3 Free', icon: '🌊', color: '#4FC3F7', provider: 'opencode' },
  { id: 'big-pickle', name: 'Big Pickle Free', icon: '🥒', color: '#81C784', provider: 'opencode' },
  { id: 'antigravity-gemini-3.1-pro', name: 'Gemini 3.1 Pro', icon: '🌟', color: '#4285F4', provider: 'antigravity' },
  { id: 'antigravity-gemini-3-flash', name: 'Gemini 3 Flash', icon: '⚡', color: '#34A853', provider: 'antigravity' },
  { id: 'gemini-2.5-flash', name: 'Gemini 2.5 Flash', icon: '💎', color: '#EA4335', provider: 'antigravity' },
  { id: 'antigravity-claude-sonnet-4-6', name: 'Claude Sonnet 4.6', icon: '🎯', color: '#FBBC04', provider: 'antigravity' },
  { id: 'antigravity-claude-opus-4-6-thinking', name: 'Claude Opus 4.6 Thinking', icon: '🧠', color: '#8E24AA', provider: 'antigravity' },
];

router.get('/models', (req, res) => res.json(models));

router.post('/chat', async (req, res) => {
  try {
    const { message, model } = req.body;
    const replies = {
      'what services do you offer': 'We offer Website Development (₹4,999), App Development (₹9,999), Digital Marketing (₹2,999), Remote IT Support (₹499-₹1,999), UI/UX Design (₹2,999), Data Recovery (₹1,499), and more. All delivered 100% remotely worldwide.',
      'how can i fix a slow computer': 'Try these steps: 1) Close unused browser tabs 2) Run Disk Cleanup 3) Disable startup programs 4) Check for malware 5) Upgrade to an SSD. If issues persist, our Remote IT Support starts at ₹499.',
    };
    const key = message?.toLowerCase().trim();
    const reply = replies[key] || `Good question! I'm a demo AI assistant. For the full AI experience with 11 free models, visit our web dashboard. You asked about: "${message}"`;
    res.json({ reply, model: model || 'deepseek-v4-flash-free' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

export default router;
