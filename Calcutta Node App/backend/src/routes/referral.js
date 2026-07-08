import { Router } from 'express';
import { verifyToken } from '../middleware/auth.js';
import User from '../models/User.js';

const router = Router();

router.get('/info', verifyToken, async (req, res) => {
  const user = await User.findById(req.user.id);
  res.json({ code: user.referralCode, earnings: user.referralEarnings, link: `https://calcuttanode.app/ref/${user.referralCode}` });
});

export default router;
