import { Router } from 'express';
import { verifyToken } from '../middleware/auth.js';
import User from '../models/User.js';

const router = Router();

router.get('/info', verifyToken, async (req, res) => {
  const user = await User.findById(req.user.id);
  res.json({ points: user.loyaltyPoints, rate: '1 pt per ₹1 spent', redemption: '100 pts = ₹50' });
});

router.post('/redeem', verifyToken, async (req, res) => {
  const { points } = req.body;
  const user = await User.findById(req.user.id);
  if (user.loyaltyPoints < points) return res.status(400).json({ message: 'Insufficient points' });
  const credit = Math.floor(points / 2);
  user.loyaltyPoints -= points;
  user.walletBalance += credit;
  await user.save();
  res.json({ points: user.loyaltyPoints, walletBalance: user.walletBalance, credit });
});

export default router;
