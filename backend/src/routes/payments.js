import { Router } from 'express';
import { verifyToken } from '../middleware/auth.js';

const router = Router();

router.post('/razorpay/create-order', verifyToken, (req, res) => {
  res.json({ orderId: 'order_demo_' + Date.now(), amount: req.body.amount, currency: 'INR' });
});

router.post('/razorpay/verify', verifyToken, (req, res) => {
  res.json({ success: true, message: 'Payment verified' });
});

export default router;
