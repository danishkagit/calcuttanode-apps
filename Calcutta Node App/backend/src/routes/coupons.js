import { Router } from 'express';

const router = Router();

router.post('/validate', (req, res) => {
  const { code } = req.body;
  if (code === 'WELCOME10') return res.json({ valid: true, discount: 10, message: '10% off applied' });
  res.json({ valid: false, message: 'Invalid coupon code' });
});

export default router;
