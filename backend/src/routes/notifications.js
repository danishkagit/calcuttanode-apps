import { Router } from 'express';
const router = Router();
router.get('/', (req, res) => res.json([]));
router.patch('/read-all', (req, res) => res.json({ message: 'All read' }));
export default router;
