import { Router } from 'express';
import { verifyToken, adminOnly } from '../middleware/auth.js';
import User from '../models/User.js';
import Order from '../models/Order.js';

const router = Router();

router.get('/overview', verifyToken, adminOnly, async (req, res) => {
  const [users, orders] = await Promise.all([
    User.countDocuments(),
    Order.countDocuments(),
  ]);
  res.json({ totalUsers: users, totalOrders: orders });
});

export default router;
