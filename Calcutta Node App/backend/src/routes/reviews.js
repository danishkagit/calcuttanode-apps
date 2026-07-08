import { Router } from 'express';
const router = Router();
router.get('/', (req, res) => res.json([]));
router.post('/', (req, res) => res.json({ message: 'Review submitted' }));
export default router;
