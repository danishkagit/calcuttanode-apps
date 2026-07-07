import { Router } from 'express';
import { verifyToken } from '../middleware/auth.js';
import Order from '../models/Order.js';
import User from '../models/User.js';

const router = Router();

router.get('/overview', verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    const activeOrders = await Order.countDocuments({ user: req.user.id, status: { $in: ['pending', 'in-progress'] } });
    res.json({ activeOrders, walletBalance: user.walletBalance, loyaltyPoints: user.loyaltyPoints, referralEarnings: user.referralEarnings });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

router.get('/orders', verifyToken, async (req, res) => {
  try {
    const orders = await Order.find({ user: req.user.id }).populate('service', 'name price category').sort({ createdAt: -1 });
    res.json(orders);
  } catch (e) { res.status(500).json({ message: e.message }); }
});

router.get('/wallet', verifyToken, async (req, res) => {
  const user = await User.findById(req.user.id);
  res.json({ balance: user.walletBalance });
});

router.get('/transactions', verifyToken, async (req, res) => {
  const Transaction = (await import('../models/Order.js')).default;
  const orders = await Order.find({ user: req.user.id }).sort({ createdAt: -1 }).limit(50);
  const txns = orders.map(o => ({ _id: o._id, type: 'debit', amount: o.amount, createdAt: o.createdAt }));
  res.json(txns);
});

router.post('/order', verifyToken, async (req, res) => {
  try {
    const { serviceId, notes, coupon } = req.body;
    const Service = (await import('../models/Service.js')).default;
    const service = await Service.findById(serviceId);
    if (!service) return res.status(404).json({ message: 'Service not found' });
    const order = await Order.create({ user: req.user.id, service: serviceId, amount: service.price, notes, coupon });
    res.json(order);
  } catch (e) { res.status(500).json({ message: e.message }); }
});

export default router;
