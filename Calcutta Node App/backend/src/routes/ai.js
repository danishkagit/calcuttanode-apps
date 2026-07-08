import { Router } from 'express';

const router = Router();

const models = [
  { id: 'deepseek', name: 'DeepSeek V4 Flash Free', icon: '🧠' },
  { id: 'mimo', name: 'MiMo V2.5 Free', icon: '✨' },
  { id: 'north', name: 'North Mini Code Free', icon: '⚡' },
  { id: 'nemotron', name: 'Nemotron 3 Ultra Free', icon: '🔬' },
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
    const reply = replies[key] || `Good question! I'm a demo AI assistant. For a full AI experience, visit our web dashboard where we have DeepSeek, MiMo, North Mini Code, and Nemotron 3 Ultra models available. You asked about: "${message}"`;
    res.json({ reply, model: model || 'deepseek' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

export default router;
