import { Router } from 'express';
const router = Router();
router.get('/', (req, res) => res.json([]));
router.post('/toggle', (req, res) => res.json({ wishlisted: true }));
export default router;
