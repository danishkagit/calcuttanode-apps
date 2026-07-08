import { Router } from 'express';
import { verifyToken } from '../middleware/auth.js';

const router = Router();

const planSchema = { name: String, slug: String, description: String, price: Number, duration: Number, features: [String], badge: String, active: Boolean };
let Plans = [];

router.get('/plans', (req, res) => {
  res.json(Plans.length ? Plans : [
    { _id: '1', name: 'Content Pass', slug: 'content-pass', description: 'Exclusive articles & tutorials', price: 199, duration: 30, features: ['Exclusive articles', 'Video tutorials', 'Downloadable resources', 'Ad-free reading', 'New content weekly'], badge: '', active: true },
    { _id: '2', name: 'Monthly Tune-Up', slug: 'monthly-tune-up', description: 'Monthly PC cleanup & optimization', price: 999, duration: 30, features: ['Monthly PC cleanup', 'Performance optimization', 'Priority email support', 'Security check', 'Driver updates'], badge: 'Most Popular', active: true },
    { _id: '3', name: 'Pro Retainer', slug: 'pro-retainer', description: 'Full IT support & security audit', price: 2499, duration: 30, features: ['Everything in Tune-Up', 'Weekly check-in calls', 'Full security audit', '24/7 priority support', 'Network monitoring', 'Business hours SLA'], badge: 'Best Value', active: true },
  ]);
});

export default router;
